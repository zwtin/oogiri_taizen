import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/authentication_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/push_notification_use_case.dart';
import 'package:oogiri_taizen/domain/use_case_impl/authentication_use_case_impl.dart';
import 'package:oogiri_taizen/domain/use_case_impl/push_notification_use_case_impl.dart';

final bottomTabViewModelProvider =
    ChangeNotifierProvider.autoDispose<BottomTabViewModel>(
  (ref) {
    final bottomTabViewModel = BottomTabViewModel(
      ref.read,
      ref.watch(authenticationUseCaseProvider),
      ref.watch(pushNotificationUseCaseProvider(UniqueKey())),
    );
    ref.onDispose(bottomTabViewModel.disposed);
    return bottomTabViewModel;
  },
);

class BottomTabViewModel extends ChangeNotifier {
  BottomTabViewModel(
    this._reader,
    this._authenticationUseCase,
    this._pushNotificationUseCase,
  ) {
    _pushNotificationUseCase.requestPermission();
  }

  final Reader _reader;

  final AuthenticationUseCase _authenticationUseCase;
  final PushNotificationUseCase _pushNotificationUseCase;

  int selected = 0;
  final Map<int, UniqueKey> _keyMap = {};
  UniqueKey? currentKey;

  void tapped(int index) {
    if (selected == index) {
      final key = _keyMap[selected];
      if (key != null) {
        _reader.call(routerNotiferProvider(key)).popToRoot();
      }
    } else {
      selected = index;
      notifyListeners();
    }
  }

  void pop() {
    final key = _keyMap[selected];
    if (key != null) {
      _reader.call(routerNotiferProvider(key)).pop();
    }
  }

  void setUniqueKey({required int index, required UniqueKey key}) {
    _keyMap[index] = key;
  }

  Future<void> openWithDynamicLinks({
    required String? apiKey,
    required String? mode,
    required String? oobCode,
    required String? continueUrl,
    required String? lang,
  }) async {
    switch (mode) {
      case 'verifyEmail':
        if (oobCode == null) {
          return;
        }
        final result =
            await _authenticationUseCase.applyActionCode(code: oobCode);
        result.when(
          success: (_) {
            if (currentKey != null) {
              _reader.call(routerNotiferProvider(currentKey!)).popToRoot();
            }
            _reader.call(alertNotiferProvider).show(
                  title: '完了',
                  message: '本会員登録が完了しました',
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          },
          failure: (exception) {
            if (exception is OTException) {
              final alertMessage = exception.alertMessage ?? '';
              if (alertMessage.isNotEmpty) {
                _reader.call(alertNotiferProvider).show(
                      title: 'エラー',
                      message: alertMessage,
                      okButtonTitle: 'OK',
                      cancelButtonTitle: null,
                      okButtonAction: () {
                        _reader.call(alertNotiferProvider).dismiss();
                      },
                      cancelButtonAction: null,
                    );
              }
            }
          },
        );
        break;
      default:
        break;
    }
  }

  Future<void> disposed() async {
    debugPrint('BottomTabViewModel disposed');
  }
}

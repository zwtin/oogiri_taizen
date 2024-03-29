import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/authentication_use_case.dart';

final bottomTabViewModelProvider =
    ChangeNotifierProvider.autoDispose<BottomTabViewModel>(
  (ref) {
    return BottomTabViewModel(
      ref.read,
      ref.watch(authenticationUseCaseProvider(UniqueKey())),
    );
  },
);

class BottomTabViewModel extends ChangeNotifier {
  BottomTabViewModel(
    this._reader,
    this._authenticationUseCase,
  );

  final Reader _reader;
  final _logger = Logger();

  final AuthenticationUseCase _authenticationUseCase;

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
              final alertTitle = exception.title;
              final alertText = exception.text;
              if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
                _reader.call(alertNotiferProvider).show(
                      title: alertTitle,
                      message: alertText,
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

  @override
  void dispose() {
    super.dispose();
    _logger.d('BottomTabViewModel dispose');
  }
}

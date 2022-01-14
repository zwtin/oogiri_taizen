import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/authentication_use_case.dart';
import 'package:oogiri_taizen/domain/use_case_impl/authentication_use_case_impl.dart';

final signInViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<SignInViewModel, UniqueKey>(
  (ref, key) {
    final signInViewModel = SignInViewModel(
      key,
      ref.read,
      ref.watch(authenticationUseCaseProvider),
    );
    ref.onDispose(signInViewModel.disposed);
    return signInViewModel;
  },
);

class SignInViewModel extends ChangeNotifier {
  SignInViewModel(
    this._key,
    this._reader,
    this._authenticationUseCase,
  );

  final UniqueKey _key;
  final Reader _reader;
  final AuthenticationUseCase _authenticationUseCase;

  bool isConnecting = false;
  String email = '';
  String password = '';

  Future<void> loginWithEmailAndPassword() async {
    if (isConnecting) {
      return;
    }
    _showIndicator();
    final result = await _authenticationUseCase.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
    _hideIndicator();
    result.when(
      success: (_) {
        _reader.call(routerNotiferProvider(_key)).pop();
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
  }

  Future<void> loginWithGoogle() async {
    if (isConnecting) {
      return;
    }
    _showIndicator();
    final result = await _authenticationUseCase.loginWithGoogle();
    _hideIndicator();
    result.when(
      success: (_) {
        _reader.call(routerNotiferProvider(_key)).pop();
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
  }

  Future<void> loginWithApple() async {
    if (isConnecting) {
      return;
    }
    _showIndicator();
    final result = await _authenticationUseCase.loginWithApple();
    _hideIndicator();
    result.when(
      success: (_) {
        _reader.call(routerNotiferProvider(_key)).pop();
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
  }

  void _showIndicator() {
    isConnecting = true;
    notifyListeners();
  }

  void _hideIndicator() {
    isConnecting = false;
    notifyListeners();
  }

  Future<void> disposed() async {
    debugPrint('SignInViewModel disposed $_key');
  }
}
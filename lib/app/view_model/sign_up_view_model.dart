import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view/temporary_register_complete_view.dart';
import 'package:oogiri_taizen/app/view/terms_of_service_view.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/use_case/authentication_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/authentication_use_case_impl.dart';

final signUpViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<SignUpViewModel, UniqueKey>(
  (ref, key) {
    final signUpViewModel = SignUpViewModel(
      key,
      ref.read,
      ref.watch(authenticationUseCaseProvider),
    );
    ref.onDispose(signUpViewModel.disposed);
    return signUpViewModel;
  },
);

class SignUpViewModel extends ChangeNotifier {
  SignUpViewModel(
    this._key,
    this._reader,
    this._authenticationUseCase,
  );

  final UniqueKey _key;
  final Reader _reader;
  final AuthenticationUseCase _authenticationUseCase;

  bool isConnecting = false;
  bool? isAgreeWithTerms = false;
  String email = '';
  String password = '';

  Future<void> createWithEmailAndPassword() async {
    if (isConnecting) {
      return;
    }
    if (isAgreeWithTerms != true) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: '利用規約に同意してください',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
            },
            cancelButtonAction: null,
          );
      return;
    }
    _showIndicator();
    final loginResult = await _authenticationUseCase.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (loginResult is Success) {
      _hideIndicator();
      _reader.call(routerNotiferProvider(_key)).pop();
      return;
    }
    final result = await _authenticationUseCase.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    _hideIndicator();
    result.when(
      success: (_) {
        _reader
            .call(routerNotiferProvider(_key))
            .pushReplacement(nextScreen: TemporaryRegisterCompleteView());
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

  void changeAgreeState({
    required bool? isAgree,
  }) {
    isAgreeWithTerms = isAgree;
    notifyListeners();
  }

  void _showIndicator() {
    isConnecting = true;
    notifyListeners();
  }

  void _hideIndicator() {
    isConnecting = false;
    notifyListeners();
  }

  Future<void> transitionToTermsOfService() async {
    await _reader.call(routerNotiferProvider(_key)).present(
          nextScreen: TermsOfServiceView(),
        );
  }

  Future<void> disposed() async {
    debugPrint('SignUpViewModel disposed $_key');
  }
}

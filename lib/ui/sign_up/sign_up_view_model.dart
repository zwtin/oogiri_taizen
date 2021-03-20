import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/entity/alert_entity.dart';
import 'package:oogiritaizen/model/use_case/authentication_use_case.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';
import 'package:oogiritaizen/model/use_case_impl/authentication_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/user_use_case_impl.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';

final signUpViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<SignUpViewModel, SignUpViewModelParameter>(
  (ref, parameter) {
    final signUpViewModel = SignUpViewModel(
      parameter.screenId,
      ref,
      ref.watch(authenticationUseCaseProvider(parameter.screenId)),
      ref.watch(userUseCaseProvider(parameter.screenId)),
    );
    ref.onDispose(signUpViewModel.disposed);
    return signUpViewModel;
  },
);

class SignUpViewModelParameter {
  SignUpViewModelParameter({
    @required this.screenId,
  });
  final String screenId;
}

class SignUpViewModel extends ChangeNotifier {
  SignUpViewModel(
    this.id,
    this.providerReference,
    this.authenticationUseCase,
    this.userUseCase,
  );

  final String id;
  final ProviderReference providerReference;
  final AuthenticationUseCase authenticationUseCase;
  final UserUseCase userUseCase;

  bool isLoading = false;

  Future<void> loginWithGoogle() async {
    try {
      isLoading = true;
      notifyListeners();
      await authenticationUseCase.loginWithGoogle();
      providerReference.read(navigatorViewModelProvider(id)).pop();
    } on Exception catch (error) {
      isLoading = false;
      providerReference.read(alertViewModelProvider(id)).show(
            alertEntity: AlertEntity()
              ..title = 'エラー'
              ..subtitle = 'ログインに失敗しました'
              ..showCancelButton = false
              ..onPress = null
              ..style = null,
          );
      notifyListeners();
    }
  }

  Future<void> sendLoginEmail({
    @required String email,
  }) async {
    assert(email != null);
    if (email.isEmpty) {
      providerReference.read(alertViewModelProvider(id)).show(
            alertEntity: AlertEntity()
              ..title = 'エラー'
              ..subtitle = 'メールアドレスを入力してください'
              ..showCancelButton = false
              ..onPress = null
              ..style = null,
          );
      return;
    }
    try {
      isLoading = true;
      notifyListeners();
      await userUseCase.registerUser(
        email: email,
      );
      isLoading = false;
      providerReference.read(alertViewModelProvider(id)).show(
            alertEntity: AlertEntity()
              ..title = '完了'
              ..subtitle = '確認メールを送信しました'
              ..showCancelButton = false
              ..onPress = null
              ..style = null,
          );
      notifyListeners();
    } on Exception catch (error) {
      isLoading = false;
      providerReference.read(alertViewModelProvider(id)).show(
            alertEntity: AlertEntity()
              ..title = 'エラー'
              ..subtitle = 'メールの送信に失敗しました'
              ..showCancelButton = false
              ..onPress = null
              ..style = null,
          );
      notifyListeners();
    }
  }

  Future<void> disposed() async {
    debugPrint(id);
  }
}

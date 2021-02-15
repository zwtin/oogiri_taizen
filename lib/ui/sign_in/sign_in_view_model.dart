import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/entity/alert_entity.dart';
import 'package:oogiritaizen/model/use_case/authentication_use_case.dart';
import 'package:oogiritaizen/model/use_case_impl/authentication_use_case_impl.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';

final signInViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<SignInViewModel, String>(
  (ref, id) {
    final signInViewModel = SignInViewModel(
      id,
      ref.watch(alertViewModelProvider(id)),
      ref.watch(navigatorViewModelProvider(id)),
      ref.watch(authenticationUseCaseProvider(id)),
    );
    ref.onDispose(signInViewModel.disposed);
    return signInViewModel;
  },
);

class SignInViewModel extends ChangeNotifier {
  SignInViewModel(
    this.id,
    this.alertViewModel,
    this.navigatorViewModel,
    this.authenticationUseCase,
  );

  final String id;
  final AlertViewModel alertViewModel;
  final NavigatorViewModel navigatorViewModel;
  final AuthenticationUseCase authenticationUseCase;

  bool isLoading = false;

  Future<void> loginWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    if (email.isEmpty) {
      alertViewModel.show(
        alertEntity: AlertEntity()
          ..title = 'エラー'
          ..subtitle = 'メールアドレスを入力してください'
          ..showCancelButton = false
          ..onPress = null
          ..style = null,
      );
      return;
    } else if (password.isEmpty) {
      alertViewModel.show(
        alertEntity: AlertEntity()
          ..title = 'エラー'
          ..subtitle = 'パスワードを入力してください'
          ..showCancelButton = false
          ..onPress = null
          ..style = null,
      );
      return;
    }
    try {
      isLoading = true;
      notifyListeners();
      await authenticationUseCase.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
      navigatorViewModel.pop();
    } on Exception catch (error) {
      isLoading = false;
      alertViewModel.show(
        alertEntity: AlertEntity()
          ..title = 'エラー'
          ..subtitle = 'メールアドレスまたはパスワードが間違っています'
          ..showCancelButton = false
          ..onPress = null
          ..style = null,
      );
      notifyListeners();
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      isLoading = true;
      notifyListeners();
      await authenticationUseCase.loginWithGoogle();
      navigatorViewModel.pop();
    } on Exception catch (error) {
      isLoading = false;
      alertViewModel.show(
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

  Future<void> disposed() async {
    debugPrint(id);
  }
}

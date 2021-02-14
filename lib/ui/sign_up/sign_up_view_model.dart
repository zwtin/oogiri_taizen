import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/entity/alert_entity.dart';
import 'package:oogiritaizen/model/use_case/authentication_use_case.dart';
import 'package:oogiritaizen/model/use_case_impl/authentication_use_case_impl.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';

final signUpViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<SignUpViewModel, String>(
  (ref, id) {
    return SignUpViewModel(
      id,
      ref.watch(alertViewModelProvider(id)),
      ref.watch(navigatorViewModelProvider(id)),
      ref.watch(authenticationUseCaseProvider(id)),
    );
  },
);

class SignUpViewModel extends ChangeNotifier {
  SignUpViewModel(
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

  Future<void> sendLoginEmail({
    @required String email,
  }) async {
    assert(email != null);
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
    }
    try {
      isLoading = true;
      notifyListeners();
      await authenticationUseCase.loginWithGoogle();
      isLoading = false;
      alertViewModel.show(
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
      alertViewModel.show(
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
}

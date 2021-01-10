import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/model/repository/firebase_authentication_repository.dart';
import 'package:oogiritaizen/data/provider/alert.dart';
import 'package:oogiritaizen/data/provider/tab_navigator.dart';

final signUpViewModelProvider = ChangeNotifierProvider<SignUpViewModel>(
  (ref) {
    return SignUpViewModel(
      alert: ref.read(
        alertProvider,
      ),
      navigator: ref.read(
        tabNavigatorProvider,
      ),
    );
  },
);

class SignUpViewModel extends ChangeNotifier {
  SignUpViewModel({@required this.alert, @required this.navigator});
  final Alert alert;
  final TabNavigator navigator;
  final FirebaseAuthenticationRepository _firebaseAuthenticationRepository =
      FirebaseAuthenticationRepository();
  bool isLoading = false;

  Future<void> googleSignIn() async {
    await _firebaseAuthenticationRepository.signInWithGoogle();
    navigator.pop();
  }

  Future<void> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null);
    assert(password != null);

    if (email.isEmpty) {
      alert.show(
        viewName: 'SignInView',
        title: 'エラー',
        subtitle: 'メールアドレスを入力してください',
        showCancelButton: false,
        onPress: null,
        style: null,
      );
      return;
    } else if (password.isEmpty) {
      alert.show(
        viewName: 'SignInView',
        title: 'エラー',
        subtitle: 'パスワードを入力してください',
        showCancelButton: false,
        onPress: null,
        style: null,
      );
      return;
    }
    try {
      isLoading = true;
      notifyListeners();
      await _firebaseAuthenticationRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      navigator.pop();
    } on Exception catch (error) {
      isLoading = false;
      alert.show(
        viewName: 'SignInView',
        title: 'エラー',
        subtitle: 'メールアドレスまたはパスワードが間違っています',
        showCancelButton: false,
        onPress: null,
        style: null,
      );
      notifyListeners();
    }
  }

  Future<void> sendSignInWithEmailLink({
    @required String email,
  }) async {
    await _firebaseAuthenticationRepository.sendSignInWithEmailLink(
      email: email,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/model/repository/firebase_authentication_repository.dart';
import 'package:oogiritaizen/data/provider/alert_notifier.dart';
import 'package:oogiritaizen/data/provider/navigator_notifier.dart';

final signInViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<SignInViewModel, String>(
  (ref, id) {
    return SignInViewModel(
      ref,
      id,
    );
  },
);

class SignInViewModel extends ChangeNotifier {
  SignInViewModel(
    this.providerReference,
    this.id,
  );

  final ProviderReference providerReference;
  final String id;

  final FirebaseAuthenticationRepository _firebaseAuthenticationRepository =
      FirebaseAuthenticationRepository();
  bool isLoading = false;

  Future<void> googleSignIn() async {
    await _firebaseAuthenticationRepository.signInWithGoogle();
    providerReference.read(navigatorNotifierProvider(id)).pop();
  }

  Future<void> signInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    assert(email != null);
    assert(password != null);

    if (email.isEmpty) {
      providerReference.read(alertNotifierProvider(id)).show(
            title: 'エラー',
            subtitle: 'メールアドレスを入力してください',
            showCancelButton: false,
            onPress: null,
            style: null,
          );
      return;
    } else if (password.isEmpty) {
      providerReference.read(alertNotifierProvider(id)).show(
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
      providerReference.read(navigatorNotifierProvider(id)).pop();
    } on Exception catch (error) {
      isLoading = false;
      providerReference.read(alertNotifierProvider(id)).show(
            title: 'エラー',
            subtitle: 'メールアドレスまたはパスワードが間違っています',
            showCancelButton: false,
            onPress: null,
            style: null,
          );
      notifyListeners();
    }
  }
}

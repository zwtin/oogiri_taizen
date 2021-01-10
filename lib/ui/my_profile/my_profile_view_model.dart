import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/model/entity/answer.dart';
import 'package:oogiritaizen/data/model/entity/current_user.dart';
import 'package:oogiritaizen/data/model/repository/firebase_authentication_repository.dart';
import 'package:oogiritaizen/data/provider/alert.dart';

final myProfileViewModelProvider = ChangeNotifierProvider<MyProfileViewModel>(
  (ref) {
    return MyProfileViewModel(
      alert: ref.read(
        alertProvider,
      ),
    );
  },
);

class MyProfileViewModel extends ChangeNotifier {
  MyProfileViewModel({@required this.alert}) {
    _firebaseAuthenticationRepository.getCurrentUserStream().listen(
      (CurrentUser currentUser) {
        userId = currentUser?.id;
        notifyListeners();
      },
    );
  }

  final Alert alert; // アラート表示用
  final FirebaseAuthenticationRepository _firebaseAuthenticationRepository =
      FirebaseAuthenticationRepository();

  String userId;

  bool isConnecting = false;
  List<Answer> items = [
    Answer(),
    Answer(),
    Answer(),
    Answer(),
    Answer(),
    Answer(),
    Answer(),
    Answer(),
    Answer(),
    Answer(),
    Answer(),
    Answer(),
    Answer(),
    Answer(),
    Answer(),
    Answer(),
    Answer(),
    Answer(),
    Answer(),
    Answer(),
  ];

  Future<void> signOut() async {
    await _firebaseAuthenticationRepository.signOut();
  }

  Future<void> addAnswer() async {
    if (isConnecting) {
      return;
    }
    isConnecting = true;
    await Future<void>.delayed(const Duration(microseconds: 500));
    for (var i = 0; i < 20; i++) {
      items.add(Answer());
    }
    isConnecting = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    items = [
      Answer(),
      Answer(),
      Answer(),
      Answer(),
      Answer(),
      Answer(),
      Answer(),
      Answer(),
      Answer(),
      Answer(),
      Answer(),
      Answer(),
      Answer(),
      Answer(),
      Answer(),
      Answer(),
      Answer(),
      Answer(),
      Answer(),
      Answer(),
    ];
    notifyListeners();
  }
}

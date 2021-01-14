import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/model/entity/answer.dart';
import 'package:oogiritaizen/data/model/entity/current_user.dart';
import 'package:oogiritaizen/data/model/entity/user.dart';
import 'package:oogiritaizen/data/model/repository/firebase_authentication_repository.dart';
import 'package:oogiritaizen/data/model/repository/firestore_user_repository.dart';

final myProfileViewModelProvider =
    ChangeNotifierProvider.family<MyProfileViewModel, String>(
  (ref, id) {
    return MyProfileViewModel(
      ref,
      id,
    );
  },
);

class MyProfileViewModel extends ChangeNotifier {
  MyProfileViewModel(
    this.providerReference,
    this.id,
  ) {
    _firebaseAuthenticationRepository.getCurrentUserStream().listen(
      (CurrentUser currentUser) {
        if (currentUser == null) {
          user = null;
          notifyListeners();
        } else {
          _firestoreUserRepository.getUserStream(userId: currentUser.id).listen(
            (User _user) {
              user = _user;
              notifyListeners();
            },
          );
        }
      },
    );
  }

  final ProviderReference providerReference;
  final String id;

  final FirebaseAuthenticationRepository _firebaseAuthenticationRepository =
      FirebaseAuthenticationRepository();
  final FirestoreUserRepository _firestoreUserRepository =
      FirestoreUserRepository();

  User user;

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

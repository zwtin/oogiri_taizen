import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/model/entity/answer.dart';
import 'package:oogiritaizen/data/model/entity/current_user.dart';
import 'package:oogiritaizen/data/model/entity/user.dart';
import 'package:oogiritaizen/data/model/repository/firebase_authentication_repository.dart';
import 'package:oogiritaizen/data/model/repository/firestore_user_repository.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/repository_impl/authentication_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/user_repository_impl.dart';
import 'package:oogiritaizen/model/use_case/authentication_use_case.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';
import 'package:oogiritaizen/model/use_case_impl/authentication_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/user_use_case_impl.dart';

final myProfileViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<MyProfileViewModel, String>(
  (ref, id) {
    final viewModel = MyProfileViewModel(
      id,
      ref.watch(authenticationUseCaseProvider(id)),
      ref.watch(userUseCaseProvider(id)),
    );
    ref.onDispose(viewModel.disposed);
    return viewModel;
  },
);

class MyProfileViewModel extends ChangeNotifier {
  MyProfileViewModel(
    this.id,
    this.authenticationUseCase,
    this.userUseCase,
  ) {
    userUseCase.getLoginUserStream().listen(
      (UserEntity userEntity) {
        user = User()
          ..id = userEntity.id
          ..name = userEntity.name
          ..introduction = userEntity.introduction
          ..imageUrl = userEntity.imageUrl;
        notifyListeners();
      },
    );
  }

  final String id;
  final AuthenticationUseCase authenticationUseCase;
  final UserUseCase userUseCase;

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

  void signOut() {
    authenticationUseCase.logout();
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

  void disposed() {
    debugPrint('aaaaa');
  }
}

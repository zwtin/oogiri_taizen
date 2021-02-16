import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/entity/answer_list_entity.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/use_case/authentication_use_case.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';
import 'package:oogiritaizen/model/use_case_impl/authentication_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/user_use_case_impl.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';

final myProfileViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<MyProfileViewModel, String>(
  (ref, id) {
    final myProfileViewModel = MyProfileViewModel(
      id,
      ref,
      ref.watch(authenticationUseCaseProvider(id)),
      ref.watch(userUseCaseProvider(id)),
    );
    ref.onDispose(myProfileViewModel.disposed);
    return myProfileViewModel;
  },
);

class MyProfileViewModel extends ChangeNotifier {
  MyProfileViewModel(
    this.id,
    this.providerReference,
    this.authenticationUseCase,
    this.userUseCase,
  ) {
    setup();
  }

  final String id;
  final ProviderReference providerReference;
  final AuthenticationUseCase authenticationUseCase;
  final UserUseCase userUseCase;

  UserEntity loginUser;

  bool isConnecting = false;
  List<AnswerListEntity> items = [
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
    AnswerListEntity(),
  ];

  Future<void> setup() async {
    userUseCase.getLoginUserStream().listen(
      (UserEntity userEntity) {
        loginUser = userEntity;
        notifyListeners();
      },
    );
    notifyListeners();
  }

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
      items.add(AnswerListEntity());
    }
    isConnecting = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    items = [
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
      AnswerListEntity(),
    ];
    notifyListeners();
  }

  Future<void> disposed() async {
    debugPrint(id);
  }
}

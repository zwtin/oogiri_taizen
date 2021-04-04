import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/entity/alert_entity.dart';
import 'package:oogiritaizen/model/entity/answer_entity.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/extension/string_extension.dart';
import 'package:oogiritaizen/model/use_case/answer_use_case.dart';
import 'package:oogiritaizen/model/use_case/authentication_use_case.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';
import 'package:oogiritaizen/model/use_case_impl/answer_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/authentication_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/user_use_case_impl.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/answer_detail/answer_detail_view.dart';
import 'package:oogiritaizen/ui/answer_detail/answer_detail_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/ui/edit_profile/edit_profile_view.dart';
import 'package:oogiritaizen/ui/edit_profile/edit_profile_view_model.dart';
import 'package:oogiritaizen/ui/setting/setting_view.dart';
import 'package:oogiritaizen/ui/setting/setting_view_model.dart';
import 'package:oogiritaizen/ui/sign_in/sign_in_view.dart';
import 'package:oogiritaizen/ui/sign_in/sign_in_view_model.dart';
import 'package:oogiritaizen/ui/sign_up/sign_up_view.dart';
import 'package:oogiritaizen/ui/sign_up/sign_up_view_model.dart';

final myProfileViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<MyProfileViewModel, MyProfileViewModelParameter>(
  (ref, parameter) {
    final myProfileViewModel = MyProfileViewModel(
      ref,
      parameter.screenId,
      ref.watch(authenticationUseCaseProvider(parameter.screenId)),
      ref.watch(userUseCaseProvider(parameter.screenId)),
      ref.watch(answerUseCaseProvider(parameter.screenId)),
    );
    ref.onDispose(myProfileViewModel.disposed);
    return myProfileViewModel;
  },
);

class MyProfileViewModelParameter {
  MyProfileViewModelParameter({
    @required this.screenId,
  });
  final String screenId;
}

class MyProfileViewModel extends ChangeNotifier {
  MyProfileViewModel(
    this.providerReference,
    this.screenId,
    this.authenticationUseCase,
    this.userUseCase,
    this.answerUseCase,
  ) {
    setup();
  }

  final String screenId;
  final ProviderReference providerReference;
  final AuthenticationUseCase authenticationUseCase;
  final UserUseCase userUseCase;
  final AnswerUseCase answerUseCase;

  UserEntity loginUser;

  bool isConnectingInCreate = false;
  List<AnswerEntity> createAnswers = [];
  bool hasNextInCreate = false;

  bool isConnectingInFavor = false;
  List<AnswerEntity> favorAnswers = [];
  bool hasNextInFavor = false;

  Future<void> setup() async {
    userUseCase.getLoginUserStream().listen(
      (UserEntity userEntity) {
        loginUser = userEntity;
        if (userEntity != null) {
          refreshCreateAnswerList();
          refreshFavorAnswerList();
        }
        notifyListeners();
      },
    );
    notifyListeners();
  }

  void signOut() {
    authenticationUseCase.logout();
  }

  Future<void> refreshCreateAnswerList() async {
    createAnswers = [];
    await getCreateAnswerList();
  }

  Future<void> getCreateAnswerList() async {
    if (isConnectingInCreate) {
      return;
    }
    isConnectingInCreate = true;
    notifyListeners();
    try {
      final lastAnswerDate =
          createAnswers.isNotEmpty ? createAnswers.last.createdAt : null;
      final answerListEntity = await answerUseCase.getUserCreateAnswerList(
        userId: loginUser.id,
        beforeTime: lastAnswerDate,
      );
      createAnswers.addAll(answerListEntity.answers);
      hasNextInCreate = answerListEntity.hasNext;
      isConnectingInCreate = false;
      notifyListeners();
    } on Exception catch (error) {
      isConnectingInCreate = false;
      providerReference.read(alertViewModelProvider(screenId)).show(
            alertEntity: AlertEntity()
              ..title = 'エラー'
              ..subtitle = '通信エラーが発生しました'
              ..showCancelButton = false
              ..onPress = null
              ..style = null,
          );
      notifyListeners();
    }
  }

  Future<void> refreshFavorAnswerList() async {
    favorAnswers = [];
    await getFavorAnswerList();
  }

  Future<void> getFavorAnswerList() async {
    if (isConnectingInFavor) {
      return;
    }
    isConnectingInFavor = true;
    notifyListeners();
    try {
      final lastAnswerDate =
          favorAnswers.isNotEmpty ? favorAnswers.last.createdAt : null;
      final answerListEntity = await answerUseCase.getUserFavorAnswerList(
        userId: loginUser.id,
        beforeTime: lastAnswerDate,
      );
      favorAnswers.addAll(answerListEntity.answers);
      hasNextInFavor = answerListEntity.hasNext;
      isConnectingInFavor = false;
      notifyListeners();
    } on Exception catch (error) {
      isConnectingInFavor = false;
      providerReference.read(alertViewModelProvider(screenId)).show(
            alertEntity: AlertEntity()
              ..title = 'エラー'
              ..subtitle = '通信エラーが発生しました'
              ..showCancelButton = false
              ..onPress = null
              ..style = null,
          );
      notifyListeners();
    }
  }

  void transitionToAnswerDetail({@required String answerId}) {
    final parameter = AnswerDetailViewModelParameter(
      screenId: StringExtension.randomString(8),
      answerId: answerId,
    );
    providerReference.read(navigatorViewModelProvider('Tab1')).push(
          AnswerDetailView(parameter),
        );
  }

  void transitionToImageDetail({
    @required String imageUrl,
    @required String imageTag,
  }) {
    providerReference.read(navigatorViewModelProvider('Tab1')).presentImage(
          imageUrl: imageUrl,
          imageTag: imageTag,
        );
  }

  void transitionToSignIn() {
    final parameter = SignInViewModelParameter(
      screenId: StringExtension.randomString(8),
    );
    providerReference.read(navigatorViewModelProvider('Tab1')).present(
          SignInView(parameter),
        );
  }

  void transitionToSignUp() {
    final parameter = SignUpViewModelParameter(
      screenId: StringExtension.randomString(8),
    );
    providerReference.read(navigatorViewModelProvider('Tab1')).present(
          SignUpView(parameter),
        );
  }

  void transitionToEditProfile() {
    final parameter = EditProfileViewModelParameter(
      screenId: StringExtension.randomString(8),
    );
    providerReference.read(navigatorViewModelProvider('Tab1')).present(
          EditProfileView(parameter),
        );
  }

  void transitionToSetting() {
    final parameter = SettingViewModelParameter(
      screenId: StringExtension.randomString(8),
    );
    providerReference.read(navigatorViewModelProvider('Tab1')).present(
          SettingView(parameter),
        );
  }

  Future<void> disposed() async {
    debugPrint(screenId);
  }
}

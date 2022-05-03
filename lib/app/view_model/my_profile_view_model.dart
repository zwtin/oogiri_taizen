import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view/answer_detail_view.dart';
import 'package:oogiri_taizen/app/view/edit_profile_view.dart';
import 'package:oogiri_taizen/app/view/setting_view.dart';
import 'package:oogiri_taizen/app/view/sign_in_view.dart';
import 'package:oogiri_taizen/app/view/sign_up_view.dart';
import 'package:oogiri_taizen/app/view_data/my_profile_view_data.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/authentication_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/my_profile_use_case.dart';

final myProfileViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<MyProfileViewModel, UniqueKey>(
  (ref, key) {
    return MyProfileViewModel(
      key,
      ref.read,
      ref.watch(myProfileUseCaseProvider(key)),
      ref.watch(authenticationUseCaseProvider(key)),
    );
  },
);

class MyProfileViewModel extends ChangeNotifier {
  MyProfileViewModel(
    this._key,
    this._reader,
    this._myProfileUseCase,
    this._authenticationUseCase,
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  final MyProfileUseCase _myProfileUseCase;
  final AuthenticationUseCase _authenticationUseCase;

  MyProfileViewData? get viewData {
    final loginUser = _myProfileUseCase.loginUser;
    if (loginUser == null || loginUser.user == null) {
      return null;
    }
    return MyProfileViewData(
      id: loginUser.user!.id,
      name: loginUser.user!.name,
      imageUrl: loginUser.user!.imageUrl,
      introduction: loginUser.user!.introduction,
      emailVerified: loginUser.emailVerified,
    );
  }

  Future<void> logout() async {
    final result = await _authenticationUseCase.logout();
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          }
        }
      },
    );
  }

  Future<void> transitionToSignIn() async {
    await _reader.call(routerNotiferProvider(_key)).present(
          nextScreen: SignInView(),
        );
  }

  Future<void> transitionToSignUp() async {
    await _reader.call(routerNotiferProvider(_key)).present(
          nextScreen: SignUpView(),
        );
  }

  Future<void> transitionToEditProfile() async {
    await _reader.call(routerNotiferProvider(_key)).push(
          nextScreen: EditProfileView(),
        );
  }

  Future<void> transitionToSetting() async {
    await _reader.call(routerNotiferProvider(_key)).push(
          nextScreen: SettingView(),
        );
  }

  Future<void> transitionToAnswerDetail({required String id}) async {
    await _reader.call(routerNotiferProvider(_key)).push(
          nextScreen: AnswerDetailView(
            answerId: id,
          ),
        );
  }

  Future<void> transitionToImageDetail({
    required String imageUrl,
    required String imageTag,
  }) async {
    if (imageUrl.isEmpty) {
      return;
    }
    await _reader.call(routerNotiferProvider(_key)).presentImage(
          imageUrl: imageUrl,
          imageTag: imageTag,
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('MyProfileViewModel dispose $_key');
  }
}

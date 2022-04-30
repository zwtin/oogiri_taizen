import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/mapper/answer_view_data_mapper.dart';
import 'package:oogiri_taizen/app/mapper/login_user_view_data_mapper.dart';
import 'package:oogiri_taizen/app/mapper/topic_view_data_mapper.dart';
import 'package:oogiri_taizen/app/mapper/user_view_data_mapper.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view/answer_detail_view.dart';
import 'package:oogiri_taizen/app/view/edit_profile_view.dart';
import 'package:oogiri_taizen/app/view/setting_view.dart';
import 'package:oogiri_taizen/app/view/sign_in_view.dart';
import 'package:oogiri_taizen/app/view/sign_up_view.dart';
import 'package:oogiri_taizen/app/view_data/answer_view_data.dart';
import 'package:oogiri_taizen/app/view_data/login_user_view_data.dart';
import 'package:oogiri_taizen/app/view_data/topic_view_data.dart';
import 'package:oogiri_taizen/app/view_data/user_view_data.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';
import 'package:oogiri_taizen/domain/entity/login_user.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/authentication_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/authentication_use_case_impl.dart';
import 'package:oogiri_taizen/domain/use_case/block_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/block_use_case_impl.dart';
import 'package:oogiri_taizen/domain/use_case/favor_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/favor_use_case_impl.dart';
import 'package:oogiri_taizen/domain/use_case/like_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/like_use_case_impl.dart';
import 'package:oogiri_taizen/domain/use_case/my_create_answer_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/my_create_answer_use_case_impl.dart';
import 'package:oogiri_taizen/domain/use_case/my_favor_answer_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/my_favor_answer_use_case_impl.dart';
import 'package:tuple/tuple.dart';

final myProfileViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<MyProfileViewModel, UniqueKey>(
  (ref, key) {
    final myProfileViewModel = MyProfileViewModel(
      key,
      ref.read,
      ref.watch(authenticationUseCaseProvider),
      ref.watch(blockUseCaseProvider),
      ref.watch(favorUseCaseProvider),
      ref.watch(likeUseCaseProvider),
      ref.watch(myCreateAnswerUseCaseProvider(key)),
      ref.watch(myFavorAnswerUseCaseProvider(key)),
    );
    ref.onDispose(myProfileViewModel.disposed);
    return myProfileViewModel;
  },
);

class MyProfileViewModel extends ChangeNotifier {
  MyProfileViewModel(
    this._key,
    this._reader,
    this._authenticationUseCase,
    this._blockUseCase,
    this._favorUseCase,
    this._likeUseCase,
    this._myCreateAnswerUseCase,
    this._myFavorAnswerUseCase,
  ) {
    loginUserSubscription?.cancel();
    loginUserSubscription = _authenticationUseCase.getLoginUserStream().listen(
      (user) async {
        if (user == null) {
          loginUser = null;
          notifyListeners();
        } else {
          loginUser =
              LoginUserViewDataMapper.convertToViewData(loginUser: user);
          notifyListeners();
        }
      },
    );

    createAnswersSubscription?.cancel();
    createAnswersSubscription =
        _myCreateAnswerUseCase.getAnswersStream().listen(
      (answers) {
        createAnswers = answers.list.map(
          (answer) {
            return AnswerViewDataMapper.convertToViewData(answer: answer);
          },
        ).toList();
        hasNextInCreate = answers.hasNext;
        notifyListeners();
      },
    );

    favorAnswersSubscription?.cancel();
    favorAnswersSubscription = _myFavorAnswerUseCase.getAnswersStream().listen(
      (answers) {
        favorAnswers = answers.list.map(
          (answer) {
            return AnswerViewDataMapper.convertToViewData(answer: answer);
          },
        ).toList();
        hasNextInFavor = answers.hasNext;
        notifyListeners();
      },
    );
  }

  final UniqueKey _key;
  final Reader _reader;

  final AuthenticationUseCase _authenticationUseCase;
  final BlockUseCase _blockUseCase;
  final FavorUseCase _favorUseCase;
  final LikeUseCase _likeUseCase;
  final MyCreateAnswerUseCase _myCreateAnswerUseCase;
  final MyFavorAnswerUseCase _myFavorAnswerUseCase;

  LoginUserViewData? loginUser;
  StreamSubscription<LoginUser?>? loginUserSubscription;

  List<AnswerViewData> createAnswers = [];
  bool hasNextInCreate = true;
  StreamSubscription<Answers>? createAnswersSubscription;

  List<AnswerViewData> favorAnswers = [];
  bool hasNextInFavor = true;
  StreamSubscription<Answers>? favorAnswersSubscription;

  Future<void> resetCreatedAnswers() async {
    final result = await _myCreateAnswerUseCase.resetAnswers();
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
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

  Future<void> resetFavorAnswers() async {
    final result = await _myFavorAnswerUseCase.resetAnswers();
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
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

  Future<void> fetchCreatedAnswers() async {
    final result = await _myCreateAnswerUseCase.fetchAnswers();
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
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

  Future<void> fetchFavorAnswers() async {
    final result = await _myFavorAnswerUseCase.fetchAnswers();
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
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

  Future<void> likeAnswer(AnswerViewData answerViewData) async {
    final result = await _likeUseCase.like(
      answer: AnswerViewDataMapper.convertToEntity(
        answerViewData: answerViewData,
      ),
    );
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
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

  Future<void> favorAnswer(AnswerViewData answerViewData) async {
    final result = await _favorUseCase.favor(
      answer: AnswerViewDataMapper.convertToEntity(
        answerViewData: answerViewData,
      ),
    );
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
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

  Future<void> logout() async {
    final result = await _authenticationUseCase.logout();
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
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

  Future<void> addBlockAnswer(AnswerViewData answerViewData) async {
    final result = await _blockUseCase.addAnswer(
      answer: AnswerViewDataMapper.convertToEntity(
        answerViewData: answerViewData,
      ),
    );
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
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

  Future<void> addBlockTopic(TopicViewData topicViewData) async {
    final result = await _blockUseCase.addTopic(
      topic: TopicViewDataMapper.convertToEntity(
        topicViewData: topicViewData,
      ),
    );
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
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

  Future<void> addBlockUser(UserViewData userViewData) async {
    final result = await _blockUseCase.addUser(
      user: UserViewDataMapper.convertToEntity(
        userViewData: userViewData,
      ),
    );
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertMessage = exception.alertMessage ?? '';
          if (alertMessage.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: 'エラー',
                  message: alertMessage,
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

  Future<void> disposed() async {
    await loginUserSubscription?.cancel();
    await createAnswersSubscription?.cancel();
    await favorAnswersSubscription?.cancel();

    debugPrint('MyProfileViewModel disposed $_key');
  }
}

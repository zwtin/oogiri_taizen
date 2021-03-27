import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/entity/alert_entity.dart';
import 'package:oogiritaizen/model/extension/string_extension.dart';
import 'package:oogiritaizen/model/use_case/answer_use_case.dart';
import 'package:oogiritaizen/model/use_case/favor_use_case.dart';
import 'package:oogiritaizen/model/use_case/like_use_case.dart';
import 'package:oogiritaizen/model/use_case/topic_use_case.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';

import 'package:oogiritaizen/model/entity/answer_entity.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/use_case_impl/answer_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/favor_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/like_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/topic_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/user_use_case_impl.dart';

import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/answer_detail/answer_detail_view.dart';
import 'package:oogiritaizen/ui/answer_detail/answer_detail_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/ui/post_topic/post_topic_view.dart';
import 'package:oogiritaizen/ui/post_topic/post_topic_view_model.dart';
import 'package:oogiritaizen/ui/topic_list/topic_list_view.dart';
import 'package:oogiritaizen/ui/topic_list/topic_list_view_model.dart';

final answerListViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<AnswerListViewModel, AnswerListViewModelParameter>(
  (ref, parameter) {
    final answerListViewModel = AnswerListViewModel(
      ref,
      parameter.screenId,
      ref.watch(answerUseCaseProvider(parameter.screenId)),
      ref.watch(likeUseCaseProvider(parameter.screenId)),
      ref.watch(favorUseCaseProvider(parameter.screenId)),
      ref.watch(topicUseCaseProvider(parameter.screenId)),
      ref.watch(userUseCaseProvider(parameter.screenId)),
    );
    ref.onDispose(answerListViewModel.disposed);
    return answerListViewModel;
  },
);

class AnswerListViewModelParameter {
  AnswerListViewModelParameter({
    @required this.screenId,
  });
  final String screenId;
}

class AnswerListViewModel extends ChangeNotifier {
  AnswerListViewModel(
    this.providerReference,
    this.screenId,
    this.answerUseCase,
    this.likeUseCase,
    this.favorUseCase,
    this.topicUseCase,
    this.userUseCase,
  ) {
    setup();
  }

  final String screenId;
  final ProviderReference providerReference;

  final AnswerUseCase answerUseCase;
  final LikeUseCase likeUseCase;
  final FavorUseCase favorUseCase;
  final TopicUseCase topicUseCase;
  final UserUseCase userUseCase;

  UserEntity loginUser = UserEntity();

  bool isConnectingInNew = false;
  List<AnswerEntity> newAnswers = [];
  bool hasNextInNew = false;

  bool isConnectingInPopular = false;
  List<AnswerEntity> popularAnswers = [];
  bool hasNextInPopular = false;

  Future<void> setup() async {
    loginUser = await userUseCase.getLoginUser();
    await refreshNewAnswerList();
    notifyListeners();
  }

  Future<void> refreshNewAnswerList() async {
    newAnswers = [];
    await getNewAnswerList();
  }

  Future<void> getNewAnswerList() async {
    if (isConnectingInNew) {
      return;
    }
    isConnectingInNew = true;
    notifyListeners();
    try {
      final lastAnswerDate =
          newAnswers.isNotEmpty ? newAnswers.last.createdAt : null;
      final answerListEntity =
          await answerUseCase.getNewAnswerList(beforeTime: lastAnswerDate);
      for (final answerEntity in answerListEntity.answers) {
        likeUseCase
            .getLikeStream(answerId: answerEntity.id)
            .listen((bool isLike) {
          if (answerEntity.isLike == false && isLike == true) {
            answerEntity
              ..isLike = true
              ..likedTime += 1;
          } else if (answerEntity.isLike == true && isLike == false) {
            answerEntity
              ..isLike = false
              ..likedTime -= 1;
          }

          notifyListeners();
        });

        favorUseCase
            .getFavorStream(answerId: answerEntity.id)
            .listen((bool isFavor) {
          if (answerEntity.isFavor == false && isFavor == true) {
            answerEntity
              ..isFavor = true
              ..favoredTime += 1;
          } else if (answerEntity.isFavor == true && isFavor == false) {
            answerEntity
              ..isFavor = false
              ..favoredTime -= 1;
          }

          notifyListeners();
        });
      }
      newAnswers.addAll(answerListEntity.answers);
      hasNextInNew = answerListEntity.hasNext;
      isConnectingInNew = false;
      notifyListeners();
    } on Exception catch (error) {
      isConnectingInNew = false;
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

  Future<void> likeButtonAction({
    @required int index,
  }) async {
    final answerEntity = newAnswers.elementAt(index);
    try {
      if (answerEntity.isLike) {
        await likeUseCase.unlike(answerId: answerEntity.id);
        answerEntity
          ..isLike = false
          ..likedTime = answerEntity.likedTime - 1;
      } else {
        await likeUseCase.like(answerId: answerEntity.id);
        answerEntity
          ..isLike = true
          ..likedTime = answerEntity.likedTime + 1;
      }
      notifyListeners();
    } on Exception catch (error) {
      providerReference.read(alertViewModelProvider(screenId)).show(
            alertEntity: AlertEntity()
              ..title = 'エラー'
              ..subtitle = '通信エラーが発生しました'
              ..showCancelButton = false
              ..onPress = null
              ..style = null,
          );
    }
  }

  Future<void> favorButtonAction({
    @required int index,
  }) async {
    final answerEntity = newAnswers.elementAt(index);
    try {
      if (answerEntity.isFavor) {
        await favorUseCase.unfavor(answerId: answerEntity.id);
        answerEntity
          ..isFavor = false
          ..favoredTime = answerEntity.favoredTime - 1;
      } else {
        await favorUseCase.favor(answerId: answerEntity.id);
        answerEntity
          ..isFavor = true
          ..favoredTime = answerEntity.favoredTime + 1;
      }
      notifyListeners();
    } on Exception catch (error) {
      providerReference.read(alertViewModelProvider(screenId)).show(
            alertEntity: AlertEntity()
              ..title = 'エラー'
              ..subtitle = '通信エラーが発生しました'
              ..showCancelButton = false
              ..onPress = null
              ..style = null,
          );
    }
  }

  void transitionToImageDetail({
    @required String imageUrl,
    @required String imageTag,
  }) {
    providerReference.read(navigatorViewModelProvider('Tab0')).presentImage(
          imageUrl: imageUrl,
          imageTag: imageTag,
        );
  }

  void transitionToAnswerDetail({@required String answerId}) {
    final parameter = AnswerDetailViewModelParameter(
      screenId: StringExtension.randomString(8),
      answerId: answerId,
    );
    providerReference.read(navigatorViewModelProvider('Tab0')).push(
          AnswerDetailView(parameter),
        );
  }

  void transitionToPostTopic() {
    final parameter = PostTopicViewModelParameter(
      screenId: StringExtension.randomString(8),
    );
    providerReference.read(navigatorViewModelProvider('Tab0')).present(
          PostTopicView(parameter),
        );
  }

  void transitionToTopicList() {
    final parameter = TopicListViewModelParameter(
      screenId: StringExtension.randomString(8),
    );
    providerReference.read(navigatorViewModelProvider('Tab0')).present(
          TopicListView(parameter),
        );
  }

  Future<void> disposed() async {
    debugPrint(screenId);
  }
}

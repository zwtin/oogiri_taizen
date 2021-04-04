import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/entity/alert_entity.dart';
import 'package:oogiritaizen/model/entity/is_favor_entity.dart';
import 'package:oogiritaizen/model/entity/is_like_entity.dart';
import 'package:oogiritaizen/model/entity/topic_entity.dart';
import 'package:oogiritaizen/model/extension/string_extension.dart';
import 'package:oogiritaizen/model/use_case/answer_use_case.dart';
import 'package:oogiritaizen/model/use_case/block_use_case.dart';
import 'package:oogiritaizen/model/use_case/favor_use_case.dart';
import 'package:oogiritaizen/model/use_case/like_use_case.dart';
import 'package:oogiritaizen/model/use_case/topic_use_case.dart';
import 'package:oogiritaizen/model/use_case/user_use_case.dart';

import 'package:oogiritaizen/model/entity/answer_entity.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/use_case_impl/answer_use_case_impl.dart';
import 'package:oogiritaizen/model/use_case_impl/block_use_case_impl.dart';
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
      ref.watch(blockUseCaseProvider(parameter.screenId)),
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
    this.blockUseCase,
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
  final BlockUseCase blockUseCase;
  final LikeUseCase likeUseCase;
  final FavorUseCase favorUseCase;
  final TopicUseCase topicUseCase;
  final UserUseCase userUseCase;

  UserEntity loginUser;

  bool isConnectingInNew = false;
  List<AnswerEntity> newAnswers = [];
  List<AnswerEntity> showingNewAnswers = [];
  bool hasNextInNew = false;

  bool isConnectingInPopular = false;
  List<AnswerEntity> popularAnswers = [];
  List<AnswerEntity> showingPopularAnswers = [];
  bool hasNextInPopular = false;

  Future<void> setup() async {
    userUseCase.getLoginUserStream().listen(
      (UserEntity userEntity) {
        loginUser = userEntity;
        notifyListeners();
      },
    );

    blockUseCase.getBlockUsersListStream().listen(
      (List<UserEntity> blockUsers) async {
        final blockAnswers = await blockUseCase.getBlockAnswersList();
        final blockTopics = await blockUseCase.getBlockTopicsList();
        final filteredList = List<AnswerEntity>.from(
          newAnswers.where(
            (AnswerEntity answer) {
              return !(blockUsers
                      .map((user) => user.id)
                      .contains(answer.createdUser.id) ||
                  blockUsers
                      .map((user) => user.id)
                      .contains(answer.topic.createdUser.id) ||
                  blockAnswers.map((answer) => answer.id).contains(answer.id) ||
                  blockTopics
                      .map((topic) => topic.id)
                      .contains(answer.topic.id));
            },
          ),
        );
        showingNewAnswers = filteredList;
        notifyListeners();
      },
    );

    blockUseCase.getBlockAnswersListStream().listen(
      (List<AnswerEntity> blockAnswers) async {
        final blockUsers = await blockUseCase.getBlockUsersList();
        final blockTopics = await blockUseCase.getBlockTopicsList();
        final filteredList = List<AnswerEntity>.from(
          newAnswers.where(
            (AnswerEntity answer) {
              return !(blockUsers
                      .map((user) => user.id)
                      .contains(answer.createdUser.id) ||
                  blockUsers
                      .map((user) => user.id)
                      .contains(answer.topic.createdUser.id) ||
                  blockAnswers.map((answer) => answer.id).contains(answer.id) ||
                  blockTopics
                      .map((topic) => topic.id)
                      .contains(answer.topic.id));
            },
          ),
        );
        showingNewAnswers = filteredList;
        notifyListeners();
      },
    );

    blockUseCase.getBlockTopicsListStream().listen(
      (List<TopicEntity> blockTopics) async {
        final blockAnswers = await blockUseCase.getBlockAnswersList();
        final blockUsers = await blockUseCase.getBlockUsersList();
        final filteredList = List<AnswerEntity>.from(
          newAnswers.where(
            (AnswerEntity answer) {
              return !(blockUsers
                      .map((user) => user.id)
                      .contains(answer.createdUser.id) ||
                  blockUsers
                      .map((user) => user.id)
                      .contains(answer.topic.createdUser.id) ||
                  blockAnswers.map((answer) => answer.id).contains(answer.id) ||
                  blockTopics
                      .map((topic) => topic.id)
                      .contains(answer.topic.id));
            },
          ),
        );
        showingNewAnswers = filteredList;
        notifyListeners();
      },
    );

    await refreshNewAnswerList();
    notifyListeners();
  }

  Future<void> addBlockUser({@required String userId}) async {
    await blockUseCase.addBlockUser(userId: userId);
  }

  Future<void> addBlockAnswer({@required String answerId}) async {
    await blockUseCase.addBlockAnswer(answerId: answerId);
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
        answerEntity
          ..likeSubscription = likeUseCase
              .getLikeStream(answerId: answerEntity.id)
              .listen((IsLikeEntity isLikeEntity) {
            if (answerEntity.isLike == null) {
              if (isLikeEntity == null) {
              } else if (isLikeEntity.isLike) {
                answerEntity.isLike = IsLikeEntity()..isLike = true;
              } else if (!isLikeEntity.isLike) {
                answerEntity.isLike = IsLikeEntity()..isLike = false;
              }
            } else if (answerEntity.isLike.isLike) {
              if (isLikeEntity == null) {
                answerEntity.isLike = null;
              } else if (isLikeEntity.isLike) {
              } else if (!isLikeEntity.isLike) {
                final isLike = IsLikeEntity()..isLike = false;
                answerEntity
                  ..likedTime = answerEntity.likedTime - 1
                  ..isLike = isLike;
              }
            } else if (!answerEntity.isLike.isLike) {
              if (isLikeEntity == null) {
                answerEntity.isLike = null;
              } else if (isLikeEntity.isLike) {
                final isLike = IsLikeEntity()..isLike = true;
                answerEntity
                  ..likedTime = answerEntity.likedTime + 1
                  ..isLike = isLike;
              } else if (!isLikeEntity.isLike) {}
            }
            notifyListeners();
          })
          ..favorSubscription = favorUseCase
              .getFavorStream(answerId: answerEntity.id)
              .listen((IsFavorEntity isFavorEntity) {
            if (answerEntity.isFavor == null) {
              if (isFavorEntity == null) {
              } else if (isFavorEntity.isFavor) {
                answerEntity.isFavor = IsFavorEntity()..isFavor = true;
              } else if (!isFavorEntity.isFavor) {
                answerEntity.isFavor = IsFavorEntity()..isFavor = false;
              }
            } else if (answerEntity.isFavor.isFavor) {
              if (isFavorEntity == null) {
                answerEntity.isFavor = null;
              } else if (isFavorEntity.isFavor) {
              } else if (!isFavorEntity.isFavor) {
                final isFavor = IsFavorEntity()..isFavor = false;
                answerEntity
                  ..favoredTime = answerEntity.favoredTime - 1
                  ..isFavor = isFavor;
              }
            } else if (!answerEntity.isFavor.isFavor) {
              if (isFavorEntity == null) {
                answerEntity.isFavor = null;
              } else if (isFavorEntity.isFavor) {
                final isFavor = IsFavorEntity()..isFavor = true;
                answerEntity
                  ..favoredTime = answerEntity.favoredTime + 1
                  ..isFavor = isFavor;
              } else if (!isFavorEntity.isFavor) {}
            }
            notifyListeners();
          });
      }

      newAnswers.addAll(answerListEntity.answers);

      final blockUsers = await blockUseCase.getBlockUsersList();
      final blockAnswers = await blockUseCase.getBlockAnswersList();
      final blockTopics = await blockUseCase.getBlockTopicsList();

      final filteredList = List<AnswerEntity>.from(
        newAnswers.where(
          (AnswerEntity answer) {
            return !(blockUsers
                    .map((user) => user.id)
                    .contains(answer.createdUser.id) ||
                blockUsers
                    .map((user) => user.id)
                    .contains(answer.topic.createdUser.id) ||
                blockAnswers.map((answer) => answer.id).contains(answer.id) ||
                blockTopics.map((topic) => topic.id).contains(answer.topic.id));
          },
        ),
      );

      showingNewAnswers = filteredList;
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
    @required AnswerEntity answerEntity,
  }) async {
    try {
      if (answerEntity.isLike == null) {
        providerReference.read(alertViewModelProvider(screenId)).show(
              alertEntity: AlertEntity()
                ..title = 'エラー'
                ..subtitle = 'ログインしてください'
                ..showCancelButton = false
                ..onPress = null
                ..style = null,
            );
      } else if (answerEntity.isLike.isLike) {
        await likeUseCase.unlike(answerId: answerEntity.id);
      } else if (!answerEntity.isLike.isLike) {
        await likeUseCase.like(answerId: answerEntity.id);
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
    @required AnswerEntity answerEntity,
  }) async {
    try {
      if (answerEntity.isFavor == null) {
        providerReference.read(alertViewModelProvider(screenId)).show(
              alertEntity: AlertEntity()
                ..title = 'エラー'
                ..subtitle = 'ログインしてください'
                ..showCancelButton = false
                ..onPress = null
                ..style = null,
            );
      } else if (answerEntity.isFavor.isFavor) {
        await favorUseCase.unfavor(answerId: answerEntity.id);
      } else if (!answerEntity.isFavor.isFavor) {
        await favorUseCase.favor(answerId: answerEntity.id);
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

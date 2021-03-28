import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/entity/alert_entity.dart';
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

final blockListViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<BlockListViewModel, BlockListViewModelParameter>(
  (ref, parameter) {
    final blockListViewModel = BlockListViewModel(
      ref,
      parameter.screenId,
      ref.watch(answerUseCaseProvider(parameter.screenId)),
      ref.watch(blockUseCaseProvider(parameter.screenId)),
      ref.watch(likeUseCaseProvider(parameter.screenId)),
      ref.watch(favorUseCaseProvider(parameter.screenId)),
      ref.watch(topicUseCaseProvider(parameter.screenId)),
      ref.watch(userUseCaseProvider(parameter.screenId)),
    );
    ref.onDispose(blockListViewModel.disposed);
    return blockListViewModel;
  },
);

class BlockListViewModelParameter {
  BlockListViewModelParameter({
    @required this.screenId,
  });
  final String screenId;
}

class BlockListViewModel extends ChangeNotifier {
  BlockListViewModel(
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

  List<TopicEntity> blockTopics = [];
  List<AnswerEntity> blockAnswers = [];
  List<UserEntity> blockUsers = [];

  Future<void> setup() async {
    blockUseCase.getBlockUsersListStream().listen(
      (List<UserEntity> blockUserList) {
        blockUsers = blockUserList;
        notifyListeners();
      },
    );

    blockUseCase.getBlockAnswersListStream().listen(
      (List<AnswerEntity> blockAnswerList) {
        blockAnswers = blockAnswerList;
        notifyListeners();
      },
    );

    blockUseCase.getBlockTopicsListStream().listen(
      (List<TopicEntity> blockTopicList) {
        blockTopics = blockTopicList;
        notifyListeners();
      },
    );
  }

  Future<void> removeBlockTopic({@required String topicId}) async {
    await blockUseCase.removeBlockTopic(topicId: topicId);
  }

  Future<void> removeBlockAnswer({@required String answerId}) async {
    await blockUseCase.removeBlockAnswer(answerId: answerId);
  }

  Future<void> removeBlockUser({@required String userId}) async {
    await blockUseCase.removeBlockUser(userId: userId);
  }

  Future<void> disposed() async {
    debugPrint(screenId);
  }
}

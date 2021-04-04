import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:oogiritaizen/model/entity/answer_entity.dart';
import 'package:oogiritaizen/model/entity/is_favor_entity.dart';
import 'package:oogiritaizen/model/entity/is_like_entity.dart';
import 'package:oogiritaizen/model/entity/topic_entity.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/model/is_favor_model.dart';
import 'package:oogiritaizen/model/repository/answer_repository.dart';
import 'package:oogiritaizen/model/repository/authentication_repository.dart';
import 'package:oogiritaizen/model/repository/favor_repository.dart';
import 'package:oogiritaizen/model/repository/like_repository.dart';
import 'package:oogiritaizen/model/repository/topic_repository.dart';
import 'package:oogiritaizen/model/repository/user_repository.dart';
import 'package:oogiritaizen/model/repository_impl/answer_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/authentication_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/favor_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/like_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/topic_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/user_repository_impl.dart';
import 'package:oogiritaizen/model/use_case/block_use_case.dart';

import 'package:oogiritaizen/model/repository/block_repository.dart';
import 'package:oogiritaizen/model/repository_impl/block_repository_impl.dart';

final blockUseCaseProvider = Provider.autoDispose.family<BlockUseCase, String>(
  (ref, id) {
    final blockUseCase = BlockUseCaseImpl(
      id,
      ref.watch(authenticationRepositoryProvider),
      ref.watch(answerRepositoryProvider),
      ref.watch(blockRepositoryProvider),
      ref.watch(likeRepositoryProvider),
      ref.watch(favorRepositoryProvider),
      ref.watch(topicRepositoryProvider),
      ref.watch(userRepositoryProvider),
    );
    ref.onDispose(blockUseCase.disposed);
    return blockUseCase;
  },
);

class BlockUseCaseImpl implements BlockUseCase {
  BlockUseCaseImpl(
    this.id,
    this.authenticationRepository,
    this.answerRepository,
    this.blockRepository,
    this.likeRepository,
    this.favorRepository,
    this.topicRepository,
    this.userRepository,
  ) {
    blockRepository.getBlockTopicsListStream().listen(
      (List<String> blockTopicIds) async {
        final blockTopicList = <TopicEntity>[];
        for (final blockTopicId in blockTopicIds) {
          final topicEntity = await getTopic(topicId: blockTopicId);
          blockTopicList.add(topicEntity);
        }
        blockTopicsListStreamController.sink.add(blockTopicList);
      },
    );

    blockRepository.getBlockAnswersListStream().listen(
      (List<String> blockAnswerIds) async {
        final blockAnswerList = <AnswerEntity>[];
        for (final blockAnswerId in blockAnswerIds) {
          final answerEntity = await getAnswer(answerId: blockAnswerId);
          blockAnswerList.add(answerEntity);
        }
        blockAnswersListStreamController.sink.add(blockAnswerList);
      },
    );

    blockRepository.getBlockUsersListStream().listen(
      (List<String> blockUserIds) async {
        final blockUserList = <UserEntity>[];
        for (final blockUserId in blockUserIds) {
          final userEntity = await getUser(userId: blockUserId);
          blockUserList.add(userEntity);
        }
        blockUsersListStreamController.sink.add(blockUserList);
      },
    );
  }

  final String id;
  final AuthenticationRepository authenticationRepository;
  final AnswerRepository answerRepository;
  final BlockRepository blockRepository;
  final LikeRepository likeRepository;
  final FavorRepository favorRepository;
  final TopicRepository topicRepository;
  final UserRepository userRepository;

  StreamController<List<TopicEntity>> blockTopicsListStreamController =
      StreamController<List<TopicEntity>>();
  StreamController<List<AnswerEntity>> blockAnswersListStreamController =
      StreamController<List<AnswerEntity>>();
  StreamController<List<UserEntity>> blockUsersListStreamController =
      StreamController<List<UserEntity>>();

  @override
  Stream<List<TopicEntity>> getBlockTopicsListStream() {
    return blockTopicsListStreamController.stream;
  }

  @override
  Stream<List<AnswerEntity>> getBlockAnswersListStream() {
    return blockAnswersListStreamController.stream;
  }

  @override
  Stream<List<UserEntity>> getBlockUsersListStream() {
    return blockUsersListStreamController.stream;
  }

  @override
  Future<List<TopicEntity>> getBlockTopicsList() async {
    final blockTopicIds = blockRepository.getBlockTopicsList();
    final blockTopicList = <TopicEntity>[];

    try {
      for (final blockTopicId in blockTopicIds) {
        final topicEntity = await getTopic(topicId: blockTopicId);
        blockTopicList.add(topicEntity);
      }
      return blockTopicList;
    } on Exception catch (error) {}
  }

  @override
  Future<List<AnswerEntity>> getBlockAnswersList() async {
    final blockAnswerIds = blockRepository.getBlockAnswersList();
    final blockAnswerList = <AnswerEntity>[];

    try {
      for (final blockAnswerId in blockAnswerIds) {
        final answerEntity = await getAnswer(answerId: blockAnswerId);
        blockAnswerList.add(answerEntity);
      }
      return blockAnswerList;
    } on Exception catch (error) {}
  }

  @override
  Future<List<UserEntity>> getBlockUsersList() async {
    final blockUserIds = blockRepository.getBlockUsersList();
    final blockUserList = <UserEntity>[];

    try {
      for (final blockUserId in blockUserIds) {
        final userEntity = await getUser(userId: blockUserId);
        blockUserList.add(userEntity);
      }
      return blockUserList;
    } on Exception catch (error) {}
  }

  @override
  Future<void> addBlockTopic({@required String topicId}) async {
    try {
      await blockRepository.addBlockTopic(topicId: topicId);
    } on Exception catch (error) {}
  }

  @override
  Future<void> addBlockAnswer({@required String answerId}) async {
    try {
      await blockRepository.addBlockAnswer(answerId: answerId);
    } on Exception catch (error) {}
  }

  @override
  Future<void> addBlockUser({@required String userId}) async {
    try {
      await blockRepository.addBlockUser(userId: userId);
    } on Exception catch (error) {}
  }

  @override
  Future<void> removeBlockTopic({@required String topicId}) async {
    try {
      await blockRepository.removeBlockTopic(topicId: topicId);
    } on Exception catch (error) {}
  }

  @override
  Future<void> removeBlockAnswer({@required String answerId}) async {
    try {
      await blockRepository.removeBlockAnswer(answerId: answerId);
    } on Exception catch (error) {}
  }

  @override
  Future<void> removeBlockUser({@required String userId}) async {
    try {
      await blockRepository.removeBlockUser(userId: userId);
    } on Exception catch (error) {}
  }

  Future<TopicEntity> getTopic({
    @required String topicId,
  }) async {
    try {
      final topicModel = await topicRepository.getTopic(topicId: topicId);
      final createUserModel =
          await userRepository.getUser(userId: topicModel.createdUser);
      final createUserEntity = UserEntity()
        ..id = createUserModel.id
        ..name = createUserModel.name
        ..introduction = createUserModel.introduction
        ..imageUrl = createUserModel.imageUrl;
      final topicEntity = TopicEntity()
        ..id = topicModel.id
        ..text = topicModel.text
        ..imageUrl = topicModel.imageUrl
        ..answeredTime = topicModel.answeredTime
        ..createdAt = topicModel.createdAt
        ..createdUser = createUserEntity;
      return topicEntity;
    } on Exception catch (error) {}
  }

  Future<AnswerEntity> getAnswer({
    @required String answerId,
  }) async {
    try {
      final answerModel = await answerRepository.getAnswer(
        answerId: answerId,
      );
      final createUserModel = await userRepository.getUser(
        userId: answerModel.createdUser,
      );
      final createUserEntity = UserEntity()
        ..id = createUserModel.id
        ..name = createUserModel.name
        ..introduction = createUserModel.introduction
        ..imageUrl = createUserModel.imageUrl;
      final topicModel = await topicRepository.getTopic(
        topicId: answerModel.topic,
      );
      final topicCreateUserModel = await userRepository.getUser(
        userId: topicModel.createdUser,
      );
      final topicCreateUserEntity = UserEntity()
        ..id = topicCreateUserModel.id
        ..name = topicCreateUserModel.name
        ..introduction = topicCreateUserModel.introduction
        ..imageUrl = topicCreateUserModel.imageUrl;
      final topicEntity = TopicEntity()
        ..id = topicModel.id
        ..text = topicModel.text
        ..imageUrl = topicModel.imageUrl
        ..answeredTime = topicModel.answeredTime
        ..createdAt = topicModel.createdAt
        ..createdUser = topicCreateUserEntity;
      final loginUserModel = authenticationRepository.getLoginUser();
      final isLikeModel = await likeRepository.getLike(
        userId: loginUserModel?.id,
        answerId: answerModel.id,
      );
      final isLikeEntity = IsLikeEntity()..isLike = isLikeModel.isLike;
      final isFavorModel = await favorRepository.getFavor(
        userId: loginUserModel?.id,
        answerId: answerModel.id,
      );
      final isFavorEntity = IsFavorEntity()..isFavor = isFavorModel.isFavor;
      final answerEntity = AnswerEntity()
        ..id = answerModel.id
        ..text = answerModel.text
        ..viewedTime = answerModel.viewedTime
        ..isLike = isLikeEntity
        ..likedTime = answerModel.likedTime
        ..isFavor = isFavorEntity
        ..favoredTime = answerModel.favoredTime
        ..point = answerModel.point
        ..createdAt = answerModel.createdAt
        ..topic = topicEntity
        ..createdUser = createUserEntity;
      return answerEntity;
    } on Exception catch (error) {}
  }

  Future<UserEntity> getUser({
    @required String userId,
  }) async {
    try {
      final userModel = await userRepository.getUser(userId: userId);
      final userEntity = UserEntity()
        ..id = userModel.id
        ..name = userModel.name
        ..introduction = userModel.introduction
        ..imageUrl = userModel.imageUrl;
      return userEntity;
    } on Exception catch (error) {}
  }

  Future<void> disposed() async {
    await blockTopicsListStreamController.close();
    await blockAnswersListStreamController.close();
    await blockUsersListStreamController.close();
  }
}

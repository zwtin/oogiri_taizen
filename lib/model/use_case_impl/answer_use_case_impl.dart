import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiritaizen/model/entity/answer_entity.dart';
import 'package:oogiritaizen/model/entity/answer_list_entity.dart';
import 'package:oogiritaizen/model/entity/topic_entity.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/model/answer_model.dart';
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
import 'package:oogiritaizen/model/use_case/answer_use_case.dart';

final answerUseCaseProvider =
    Provider.autoDispose.family<AnswerUseCase, String>(
  (ref, id) {
    final answerUseCase = AnswerUseCaseImpl(
      id,
      ref.watch(answerRepositoryProvider),
      ref.watch(authenticationRepositoryProvider),
      ref.watch(likeRepositoryProvider),
      ref.watch(favorRepositoryProvider),
      ref.watch(topicRepositoryProvider),
      ref.watch(userRepositoryProvider),
    );
    ref.onDispose(answerUseCase.disposed);
    return answerUseCase;
  },
);

class AnswerUseCaseImpl implements AnswerUseCase {
  AnswerUseCaseImpl(
    this.id,
    this.answerRepository,
    this.authenticationRepository,
    this.likeRepository,
    this.favorRepository,
    this.topicRepository,
    this.userRepository,
  );

  final String id;
  final AnswerRepository answerRepository;
  final AuthenticationRepository authenticationRepository;
  final LikeRepository likeRepository;
  final FavorRepository favorRepository;
  final TopicRepository topicRepository;
  final UserRepository userRepository;

  @override
  Future<AnswerEntity> getAnswer({
    @required String answerId,
  }) async {
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
    final answerEntity = AnswerEntity()
      ..id = answerModel.id
      ..text = answerModel.text
      ..viewedTime = answerModel.viewedTime
      ..likedTime = answerModel.likedTime
      ..favoredTime = answerModel.favoredTime
      ..point = answerModel.point
      ..createdAt = answerModel.createdAt
      ..topic = topicEntity
      ..createdUser = createUserEntity;
    return answerEntity;
  }

  @override
  Future<void> postAnswer({
    @required String topicId,
    @required AnswerEntity editedAnswer,
  }) async {
    await answerRepository.postAnswer(
      userId: authenticationRepository.getLoginUser().id,
      topicId: topicId,
      answer: AnswerModel()..text = editedAnswer.text,
    );
  }

  @override
  Future<AnswerListEntity> getNewAnswerList({
    @required DateTime beforeTime,
  }) async {
    final answerModelList = await answerRepository.getNewAnswerList(
      beforeTime: beforeTime,
      count: 11,
    );
    final answerListEntity = AnswerListEntity();
    if (answerModelList.length == 11) {
      answerModelList.removeLast();
      answerListEntity.hasNext = true;
    } else {
      answerListEntity.hasNext = false;
    }
    final answerEntityList = <AnswerEntity>[];
    for (final answerModel in answerModelList) {
      final answerEntity = await getAnswer(answerId: answerModel.id);
      answerEntityList.add(answerEntity);
    }
    answerListEntity.answers = answerEntityList;
    return answerListEntity;
  }

  @override
  Future<AnswerListEntity> getUserCreateAnswerList({
    @required String userId,
    @required DateTime beforeTime,
  }) async {
    final createAnswerIds = await userRepository.getCreateAnswers(
      userId: userId,
      beforeTime: beforeTime,
      count: 11,
    );
    final answerListEntity = AnswerListEntity();
    if (createAnswerIds.length == 11) {
      createAnswerIds.removeLast();
      answerListEntity.hasNext = true;
    } else {
      answerListEntity.hasNext = false;
    }
    final answerEntityList = <AnswerEntity>[];
    for (final createAnswerId in createAnswerIds) {
      final answerEntity = await getAnswer(answerId: createAnswerId);
      answerEntityList.add(answerEntity);
    }
    answerListEntity.answers = answerEntityList;
    return answerListEntity;
  }

  @override
  Future<AnswerListEntity> getUserFavorAnswerList({
    @required String userId,
    @required DateTime beforeTime,
  }) async {
    final createAnswerIds = await userRepository.getFavorAnswers(
      userId: userId,
      beforeTime: beforeTime,
      count: 11,
    );
    final answerListEntity = AnswerListEntity();
    if (createAnswerIds.length == 11) {
      createAnswerIds.removeLast();
      answerListEntity.hasNext = true;
    } else {
      answerListEntity.hasNext = false;
    }
    final answerEntityList = <AnswerEntity>[];
    for (final createAnswerId in createAnswerIds) {
      final answerEntity = await getAnswer(answerId: createAnswerId);
      answerEntityList.add(answerEntity);
    }
    answerListEntity.answers = answerEntityList;
    return answerListEntity;
  }

  Future<void> disposed() async {}
}

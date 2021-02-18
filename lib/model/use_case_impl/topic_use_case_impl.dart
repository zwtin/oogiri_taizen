import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiritaizen/model/entity/topic_entity.dart';
import 'package:oogiritaizen/model/entity/topic_list_entity.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';
import 'package:oogiritaizen/model/model/topic_model.dart';
import 'package:oogiritaizen/model/repository/authentication_repository.dart';
import 'package:oogiritaizen/model/repository/storage_repository.dart';
import 'package:oogiritaizen/model/repository/topic_repository.dart';
import 'package:oogiritaizen/model/repository/user_repository.dart';
import 'package:oogiritaizen/model/repository_impl/authentication_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/storage_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/topic_repository_impl.dart';
import 'package:oogiritaizen/model/repository_impl/user_repository_impl.dart';
import 'package:oogiritaizen/model/use_case/topic_use_case.dart';

final topicUseCaseProvider = Provider.autoDispose.family<TopicUseCase, String>(
  (ref, id) {
    final topicUseCase = TopicUseCaseImpl(
      id,
      ref.watch(authenticationRepositoryProvider),
      ref.watch(storageRepositoryProvider),
      ref.watch(topicRepositoryProvider),
      ref.watch(userRepositoryProvider),
    );
    ref.onDispose(topicUseCase.disposed);
    return topicUseCase;
  },
);

class TopicUseCaseImpl implements TopicUseCase {
  TopicUseCaseImpl(
    this.id,
    this.authenticationRepository,
    this.storageRepository,
    this.topicRepository,
    this.userRepository,
  );

  final String id;
  final AuthenticationRepository authenticationRepository;
  final StorageRepository storageRepository;
  final TopicRepository topicRepository;
  final UserRepository userRepository;

  @override
  Future<TopicEntity> getTopic({
    @required String topicId,
  }) async {
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
  }

  @override
  Future<void> postTopic({
    @required File imageFile,
    @required TopicEntity editedTopic,
  }) async {
    var uploadedUrl = '';
    if (imageFile != null) {
      uploadedUrl = await storageRepository.upload(
        path: 'images/topics',
        file: imageFile,
      );
    }
    await topicRepository.postTopic(
      userId: authenticationRepository.getLoginUser().id,
      topic: TopicModel()
        ..text = editedTopic.text
        ..imageUrl = uploadedUrl,
    );
  }

  @override
  Future<TopicListEntity> getNewTopicList({
    @required DateTime beforeTime,
  }) async {
    final topicModelList = await topicRepository.getNewTopicList(
      beforeTime: beforeTime,
      count: 11,
    );
    final topicListEntity = TopicListEntity();
    if (topicModelList.length == 11) {
      topicModelList.removeLast();
      topicListEntity.hasNext = true;
    } else {
      topicListEntity.hasNext = false;
    }
    final topicEntityList = <TopicEntity>[];
    for (final topicModel in topicModelList) {
      final userModel = await userRepository.getUser(
        userId: topicModel.createdUser,
      );
      final userEntity = UserEntity()
        ..id = userModel.id
        ..name = userModel.name
        ..introduction = userModel.introduction
        ..imageUrl = userModel.imageUrl;
      final topicEntity = TopicEntity()
        ..id = topicModel.id
        ..text = topicModel.text
        ..imageUrl = topicModel.imageUrl
        ..answeredTime = topicModel.answeredTime
        ..createdAt = topicModel.createdAt
        ..createdUser = userEntity;
      topicEntityList.add(topicEntity);
    }
    topicListEntity.topics = topicEntityList;
    return topicListEntity;
  }

  Future<void> disposed() async {}
}

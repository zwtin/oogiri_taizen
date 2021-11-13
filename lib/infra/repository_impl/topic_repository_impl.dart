import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/entity/user.dart' as ot;
import 'package:oogiri_taizen/domain/repository/topic_repository.dart';

final topicRepositoryProvider = Provider.autoDispose<TopicRepository>(
  (ref) {
    final topicRepository = TopicRepositoryImpl();
    ref.onDispose(topicRepository.disposed);
    return topicRepository;
  },
);

class TopicRepositoryImpl implements TopicRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<Topic>> getTopic({
    required String id,
  }) async {
    try {
      final topicDoc = await _firestore.collection('topics').doc(id).get();
      final topicData = topicDoc.data();
      if (topicData == null) {
        throw OTException();
      }
      final createdUserId = topicData['created_user'] as String;
      final createdUserDoc =
          await _firestore.collection('users').doc(createdUserId).get();
      final createdUserData = createdUserDoc.data();
      if (createdUserData == null) {
        throw OTException();
      }
      final createdUser = ot.User(
        id: createdUserData['id'] as String,
        name: createdUserData['name'] as String,
        imageUrl: createdUserData['image_url'] as String,
        introduction: createdUserData['introduction'] as String,
      );
      final topic = Topic(
        id: topicData['id'] as String,
        text: topicData['text'] as String,
        imageUrl: topicData['image_url'] as String,
        answeredTime: topicData['answered_time'] as int,
        createdAt: (topicData['created_at'] as Timestamp).toDate(),
        createdUser: createdUser,
        isOwn: createdUser.id == _firebaseAuth.currentUser?.uid,
      );
      return Result.success(topic);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  Future<void> disposed() async {
    debugPrint('TopicRepositoryImpl disposed');
  }
}

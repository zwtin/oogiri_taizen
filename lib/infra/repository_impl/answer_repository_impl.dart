import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/entity/user.dart' as ot;
import 'package:oogiri_taizen/domain/repository/answer_repository.dart';

final answerRepositoryProvider = Provider.autoDispose<AnswerRepository>(
  (ref) {
    final answerRepository = AnswerRepositoryImpl();
    ref.onDispose(answerRepository.disposed);
    return answerRepository;
  },
);

class AnswerRepositoryImpl implements AnswerRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<Answer>> getAnswer({
    required String id,
  }) async {
    try {
      final answerDoc = await _firestore.collection('answers').doc(id).get();
      final answerData = answerDoc.data();
      if (answerData == null) {
        throw OTException();
      }
      final createdUserId = answerData['created_user'] as String;
      final createdUserDoc =
          await _firestore.collection('users').doc(createdUserId).get();
      final createdUserData = createdUserDoc.data();
      if (createdUserData == null) {
        throw OTException();
      }
      final topicId = answerData['topic'] as String;
      final topicDoc = await _firestore.collection('topics').doc(topicId).get();
      final topicData = topicDoc.data();
      if (topicData == null) {
        throw OTException();
      }
      final topicCreatedUserId = topicData['created_user'] as String;
      final topicCreatedUserDoc =
          await _firestore.collection('users').doc(topicCreatedUserId).get();
      final topicCreatedUserData = topicCreatedUserDoc.data();
      if (topicCreatedUserData == null) {
        throw OTException();
      }
      final topicCreatedUser = ot.User(
        id: topicCreatedUserData['id'] as String,
        name: topicCreatedUserData['name'] as String,
        imageUrl: topicCreatedUserData['image_url'] as String,
        introduction: topicCreatedUserData['introduction'] as String,
      );
      final topic = Topic(
        id: topicData['id'] as String,
        text: topicData['text'] as String,
        imageUrl: topicData['image_url'] as String,
        answeredTime: topicData['answered_time'] as int,
        createdAt: (topicData['created_at'] as Timestamp).toDate(),
        createdUser: topicCreatedUser,
        isOwn: topicCreatedUser.id == _firebaseAuth.currentUser?.uid,
      );
      final createdUser = ot.User(
        id: createdUserData['id'] as String,
        name: createdUserData['name'] as String,
        imageUrl: createdUserData['image_url'] as String,
        introduction: createdUserData['introduction'] as String,
      );
      final answer = Answer(
        id: answerData['id'] as String,
        text: answerData['text'] as String,
        viewedTime: answerData['viewed_time'] as int,
        isLike: false,
        likedTime: answerData['liked_time'] as int,
        isFavor: false,
        favoredTime: answerData['favored_time'] as int,
        point: answerData['point'] as int,
        createdAt: (answerData['created_at'] as Timestamp).toDate(),
        topic: topic,
        createdUser: createdUser,
        isOwn: topicCreatedUser.id == _firebaseAuth.currentUser?.uid,
      );
      return Result.success(answer);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<List<String>>> getNewAnswerIds({
    required DateTime? offset,
    required int limit,
  }) async {
    try {
      final QuerySnapshot query;
      if (offset != null) {
        query = await _firestore
            .collection('answers')
            .where(
              'created_at',
              isLessThan: offset.add(
                const Duration(
                  milliseconds: -1,
                ),
              ),
            )
            .orderBy('created_at', descending: true)
            .limit(limit)
            .get();
      } else {
        query = await _firestore
            .collection('answers')
            .orderBy('created_at', descending: true)
            .limit(limit)
            .get();
      }
      final newAnswerIds = query.docs
          .map(
            (doc) {
              final data = doc.data() as Map<String, dynamic>?;
              if (data == null) {
                return null;
              }
              return data['id'] as String;
            },
          )
          .whereType<String>()
          .toList();
      return Result.success(newAnswerIds);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<List<String>>> getCreatedAnswerIds({
    required String userId,
    required DateTime? offset,
    required int limit,
  }) async {
    try {
      final QuerySnapshot query;
      if (offset != null) {
        query = await _firestore
            .collection('users')
            .doc(userId)
            .collection('create_answers')
            .where(
              'create_at',
              isLessThan: offset.add(
                const Duration(
                  milliseconds: -1,
                ),
              ),
            )
            .orderBy('create_at', descending: true)
            .limit(limit)
            .get();
      } else {
        query = await _firestore
            .collection('users')
            .doc(userId)
            .collection('create_answers')
            .orderBy('create_at', descending: true)
            .limit(limit)
            .get();
      }
      final createdAnswerIds = query.docs
          .map(
            (doc) {
              final data = doc.data() as Map<String, dynamic>?;
              if (data == null) {
                return null;
              }
              return data['id'] as String;
            },
          )
          .whereType<String>()
          .toList();
      return Result.success(createdAnswerIds);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<List<String>>> getFavorAnswerIds({
    required String userId,
    required DateTime? offset,
    required int limit,
  }) async {
    try {
      final QuerySnapshot query;
      if (offset != null) {
        query = await _firestore
            .collection('users')
            .doc(userId)
            .collection('favor_answers')
            .where(
              'favor_at',
              isLessThan: offset.add(
                const Duration(
                  milliseconds: -1,
                ),
              ),
            )
            .orderBy('favor_at', descending: true)
            .limit(limit)
            .get();
      } else {
        query = await _firestore
            .collection('users')
            .doc(userId)
            .collection('favor_answers')
            .orderBy('favor_at', descending: true)
            .limit(limit)
            .get();
      }
      final favorAnswerIds = query.docs
          .map(
            (doc) {
              final data = doc.data() as Map<String, dynamic>?;
              if (data == null) {
                return null;
              }
              return data['id'] as String;
            },
          )
          .whereType<String>()
          .toList();
      return Result.success(favorAnswerIds);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  Future<void> disposed() async {
    debugPrint('AnswerRepositoryImpl disposed');
  }
}

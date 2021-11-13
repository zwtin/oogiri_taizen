import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';

import 'package:oogiri_taizen/domain/repository/like_repository.dart';

final likeRepositoryProvider = Provider.autoDispose<LikeRepository>(
  (ref) {
    final likeRepository = LikeRepositoryImpl();
    ref.onDispose(likeRepository.disposed);
    return likeRepository;
  },
);

class LikeRepositoryImpl implements LikeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<void>> like({
    required String userId,
    required String answerId,
  }) async {
    try {
      await _firestore.runTransaction<void>(
        (Transaction transaction) async {
          final answerRef = _firestore.collection('answers').doc(answerId);
          final answerDoc = await transaction.get(answerRef);
          final answerData = answerDoc.data();
          if (answerData == null) {
            throw OTException();
          }

          final userlikeAnswerRef = _firestore
              .collection('users')
              .doc(userId)
              .collection('like_answers')
              .doc(answerId);
          final userlikeAnswerDoc = await transaction.get(userlikeAnswerRef);
          if (userlikeAnswerDoc.exists) {
            throw OTException();
          }

          final answerLikedUserRef = _firestore
              .collection('answers')
              .doc(answerId)
              .collection('liked_users')
              .doc(userId);
          final answerLikedUserDoc = await transaction.get(answerLikedUserRef);
          if (answerLikedUserDoc.exists) {
            throw OTException();
          }

          final likedTime = answerData['liked_time'] as int;
          final likeUpdateMap = {
            'liked_time': likedTime + 1,
          };
          transaction.update(answerRef, likeUpdateMap);

          final answerLikedUserMap = {
            'id': userId,
            'liked_at': FieldValue.serverTimestamp(),
          };
          transaction.set(
            answerLikedUserRef,
            answerLikedUserMap,
          );

          final userMap = {
            'id': answerId,
            'like_at': FieldValue.serverTimestamp(),
          };
          transaction.set(
            userlikeAnswerRef,
            userMap,
          );
        },
      );
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<void>> unlike({
    required String userId,
    required String answerId,
  }) async {
    try {
      await _firestore.runTransaction<void>(
        (Transaction transaction) async {
          final answerRef = _firestore.collection('answers').doc(answerId);
          final answerDoc = await transaction.get(answerRef);
          final answerData = answerDoc.data();
          if (answerData == null) {
            throw OTException();
          }

          final userlikeAnswerRef = _firestore
              .collection('users')
              .doc(userId)
              .collection('like_answers')
              .doc(answerId);
          final userlikeAnswerDoc = await transaction.get(userlikeAnswerRef);
          if (!userlikeAnswerDoc.exists) {
            throw OTException();
          }

          final answerLikedUserRef = _firestore
              .collection('answers')
              .doc(answerId)
              .collection('liked_users')
              .doc(userId);
          final answerLikedUserDoc = await transaction.get(answerLikedUserRef);
          if (!answerLikedUserDoc.exists) {
            throw OTException();
          }

          final likedTime = answerData['liked_time'] as int;
          final likeUpdateMap = {
            'liked_time': likedTime - 1,
          };
          transaction.update(answerRef, likeUpdateMap)
            ..delete(answerLikedUserRef)
            ..delete(userlikeAnswerRef);
        },
      );
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<bool>> getLike({
    required String userId,
    required String answerId,
  }) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('like_answers')
          .doc(answerId)
          .get();
      return Result.success(doc.exists);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Stream<bool> getLikeStream({
    required String userId,
    required String answerId,
  }) {
    final likeStream = _firestore
        .collection('users')
        .doc(userId)
        .collection('like_answers')
        .doc(answerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists;
    });
    return likeStream;
  }

  Future<void> disposed() async {
    debugPrint('LikeRepositoryImpl disposed');
  }
}

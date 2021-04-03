import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:oogiritaizen/model/model/is_like_model.dart';

import 'package:oogiritaizen/model/repository/like_repository.dart';

final likeRepositoryProvider = Provider<LikeRepository>(
  (ref) {
    return LikeRepositoryImpl();
  },
);

class LikeRepositoryImpl implements LikeRepository {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<IsLikeModel> getLike({
    @required String userId,
    @required String answerId,
  }) async {
    if (userId == null ||
        userId.isEmpty ||
        answerId == null ||
        answerId.isEmpty) {
      return null;
    }

    final documentSnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('like_answers')
        .doc(answerId)
        .get();
    return IsLikeModel()..isLike = documentSnapshot.exists;
  }

  @override
  Stream<IsLikeModel> getLikeStream({
    @required String userId,
    @required String answerId,
  }) {
    if (userId == null ||
        userId.isEmpty ||
        answerId == null ||
        answerId.isEmpty) {
      return null;
    }

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('like_answers')
        .doc(answerId)
        .snapshots()
        .map(
      (DocumentSnapshot documentSnapshot) {
        return IsLikeModel()..isLike = documentSnapshot.exists;
      },
    );
  }

  @override
  Future<void> like({
    @required String userId,
    @required String answerId,
  }) async {
    assert(userId != null && userId.isNotEmpty);
    assert(answerId != null && answerId.isNotEmpty);

    try {
      await _firestore.runTransaction<void>(
        (Transaction transaction) async {
          final answerRef = _firestore.collection('answers').doc(answerId);
          final documentSnapshot = await transaction.get(answerRef);
          final likedTime = documentSnapshot.data()['liked_time'] as int;
          final likeUpdateMap = {
            'liked_time': likedTime + 1,
          };
          transaction.update(answerRef, likeUpdateMap);

          final answerLikedUserRef = _firestore
              .collection('answers')
              .doc(answerId)
              .collection('liked_users')
              .doc(userId);
          final answerLikedUserMap = {
            'id': userId,
            'liked_at': FieldValue.serverTimestamp(),
          };
          transaction.set(
            answerLikedUserRef,
            answerLikedUserMap,
          );
          final userlikeAnswerRef = _firestore
              .collection('users')
              .doc(userId)
              .collection('like_answers')
              .doc(answerId);
          final userMap = {
            'id': answerId,
            'like_at': FieldValue.serverTimestamp(),
          };
          transaction.set(
            userlikeAnswerRef,
            userMap,
          );
          return;
        },
      );
    } on Exception catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> unlike({
    @required String userId,
    @required String answerId,
  }) async {
    assert(userId != null && userId.isNotEmpty);
    assert(answerId != null && answerId.isNotEmpty);

    try {
      await _firestore.runTransaction<void>(
        (Transaction transaction) async {
          final answerRef = _firestore.collection('answers').doc(answerId);
          final documentSnapshot = await transaction.get(answerRef);
          final likedTime = documentSnapshot.data()['liked_time'] as int;
          final likeUpdateMap = {
            'liked_time': likedTime - 1,
          };
          transaction.update(answerRef, likeUpdateMap);

          final answerLikedUserRef = _firestore
              .collection('answers')
              .doc(answerId)
              .collection('liked_users')
              .doc(userId);
          transaction.delete(answerLikedUserRef);

          final userlikeAnswerRef = _firestore
              .collection('users')
              .doc(userId)
              .collection('like_answers')
              .doc(answerId);
          transaction.delete(userlikeAnswerRef);
          return;
        },
      );
    } on Exception catch (error) {
      rethrow;
    }
  }
}

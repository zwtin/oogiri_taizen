import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:oogiritaizen/model/model/is_favor_model.dart';
import 'package:oogiritaizen/model/repository/favor_repository.dart';

final favorRepositoryProvider = Provider<FavorRepository>(
  (ref) {
    return FavorRepositoryImpl();
  },
);

class FavorRepositoryImpl implements FavorRepository {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<IsFavorModel> getFavor({
    @required String userId,
    @required String answerId,
  }) async {
    if (userId == null ||
        userId.isEmpty ||
        answerId == null ||
        answerId.isEmpty) {
      return null;
    }

    try {
      final documentSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favor_answers')
          .doc(answerId)
          .get();
      return IsFavorModel()..isFavor = documentSnapshot.exists;
    } on Exception catch (error) {}
  }

  @override
  Stream<IsFavorModel> getFavorStream({
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
        .collection('favor_answers')
        .doc(answerId)
        .snapshots()
        .map(
      (DocumentSnapshot documentSnapshot) {
        return IsFavorModel()..isFavor = documentSnapshot.exists;
      },
    );
  }

  @override
  Future<void> favor({
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
          final favoredTime = documentSnapshot.data()['favored_time'] as int;
          final favorUpdateMap = {
            'favored_time': favoredTime + 1,
          };
          transaction.update(answerRef, favorUpdateMap);

          final answerFavoredUserRef = _firestore
              .collection('answers')
              .doc(answerId)
              .collection('favored_users')
              .doc(userId);
          final answerFavoredUserMap = {
            'id': userId,
            'favored_at': FieldValue.serverTimestamp(),
          };
          transaction.set(
            answerFavoredUserRef,
            answerFavoredUserMap,
          );
          final userFavorAnswerRef = _firestore
              .collection('users')
              .doc(userId)
              .collection('favor_answers')
              .doc(answerId);
          final userMap = {
            'id': answerId,
            'favor_at': FieldValue.serverTimestamp(),
          };
          transaction.set(
            userFavorAnswerRef,
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
  Future<void> unfavor({
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
          final favoredTime = documentSnapshot.data()['favored_time'] as int;
          final favorUpdateMap = {
            'favored_time': favoredTime - 1,
          };
          transaction.update(answerRef, favorUpdateMap);

          final answerFavoredUserRef = _firestore
              .collection('answers')
              .doc(answerId)
              .collection('favored_users')
              .doc(userId);
          transaction.delete(answerFavoredUserRef);

          final userFavorAnswerRef = _firestore
              .collection('users')
              .doc(userId)
              .collection('favor_answers')
              .doc(answerId);
          transaction.delete(userFavorAnswerRef);
          return;
        },
      );
    } on Exception catch (error) {
      rethrow;
    }
  }
}

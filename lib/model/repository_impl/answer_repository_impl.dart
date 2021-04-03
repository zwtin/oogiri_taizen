import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';

import 'package:oogiritaizen/model/model/answer_model.dart';
import 'package:oogiritaizen/model/repository/answer_repository.dart';

final answerRepositoryProvider = Provider<AnswerRepository>(
  (ref) {
    return AnswerRepositoryImpl();
  },
);

class AnswerRepositoryImpl implements AnswerRepository {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<AnswerModel> getAnswer({
    @required String answerId,
  }) async {
    assert(answerId != null && answerId.isNotEmpty);

    try {
      final documentSnapshot =
          await _firestore.collection('answers').doc(answerId).get();

      final answerModel = AnswerModel()
        ..id = documentSnapshot.data()['id'] as String
        ..text = documentSnapshot.data()['text'] as String
        ..viewedTime = documentSnapshot.data()['viewed_time'] as int
        ..likedTime = documentSnapshot.data()['liked_time'] as int
        ..favoredTime = documentSnapshot.data()['favored_time'] as int
        ..point = documentSnapshot.data()['point'] as int
        ..createdAt =
            (documentSnapshot.data()['created_at'] as Timestamp).toDate()
        ..topic = documentSnapshot.data()['topic'] as String
        ..createdUser = documentSnapshot.data()['created_user'] as String;
      return answerModel;
    } on Exception catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> postAnswer({
    @required String userId,
    @required String topicId,
    @required AnswerModel answer,
  }) async {
    assert(userId != null && userId.isNotEmpty);
    assert(topicId != null && topicId.isNotEmpty);
    assert(answer != null);

    try {
      await _firestore.runTransaction<void>(
        (Transaction transaction) async {
          final topicRef = _firestore.collection('topics').doc(topicId);
          final documentSnapshot = await transaction.get(topicRef);
          final answeredTime = documentSnapshot.data()['answered_time'] as int;
          final answerUpdateMap = {
            'answered_time': answeredTime + 1,
          };
          transaction.update(topicRef, answerUpdateMap);

          final answerRef = _firestore.collection('answers').doc();
          final answerMap = {
            'id': answerRef.id,
            'text': answer.text,
            'viewed_time': 0,
            'liked_time': 0,
            'favored_time': 0,
            'point': 0,
            'created_at': FieldValue.serverTimestamp(),
            'topic': topicId,
            'created_user': userId,
          };
          transaction.set(
            answerRef,
            answerMap,
          );
          final userCreateAnswerRef = _firestore
              .collection('users')
              .doc(userId)
              .collection('create_answers')
              .doc(answerRef.id);
          final userMap = {
            'id': answerRef.id,
            'create_at': FieldValue.serverTimestamp(),
          };
          transaction.set(
            userCreateAnswerRef,
            userMap,
          );
          final topicAnswerRef = _firestore
              .collection('topics')
              .doc(topicId)
              .collection('answers')
              .doc(answerRef.id);
          final topicMap = {
            'id': answerRef.id,
            'create_at': FieldValue.serverTimestamp(),
          };
          transaction.set(
            topicAnswerRef,
            topicMap,
          );
          return;
        },
      );
    } on Exception catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<AnswerModel>> getNewAnswerList({
    @required DateTime beforeTime,
    @required int count,
  }) async {
    assert(count != null && count > 0);

    try {
      QuerySnapshot querySnapshot;
      if (beforeTime != null) {
        querySnapshot = await _firestore
            .collection('answers')
            .where(
              'created_at',
              isLessThan: beforeTime.add(
                const Duration(
                  milliseconds: -1,
                ),
              ),
            )
            .orderBy('created_at', descending: true)
            .limit(count)
            .get();
      } else {
        querySnapshot = await _firestore
            .collection('answers')
            .orderBy('created_at', descending: true)
            .limit(count)
            .get();
      }

      return querySnapshot.docs.map((DocumentSnapshot documentSnapshot) {
        return AnswerModel()
          ..id = documentSnapshot.data()['id'] as String
          ..text = documentSnapshot.data()['text'] as String
          ..viewedTime = documentSnapshot.data()['viewed_time'] as int
          ..likedTime = documentSnapshot.data()['liked_time'] as int
          ..favoredTime = documentSnapshot.data()['favored_time'] as int
          ..point = documentSnapshot.data()['point'] as int
          ..createdAt =
              (documentSnapshot.data()['created_at'] as Timestamp).toDate()
          ..topic = documentSnapshot.data()['topic'] as String
          ..createdUser = documentSnapshot.data()['created_user'] as String;
      }).toList();
    } on Exception catch (error) {
      rethrow;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';

import 'package:oogiritaizen/model/model/topic_model.dart';
import 'package:oogiritaizen/model/repository/topic_repository.dart';

final topicRepositoryProvider = Provider<TopicRepository>(
  (ref) {
    return TopicRepositoryImpl();
  },
);

class TopicRepositoryImpl implements TopicRepository {
  final _firestore = FirebaseFirestore.instance;
  final Map<String, TopicModel> _cache = {};

  @override
  Future<TopicModel> getTopic({
    @required String topicId,
  }) async {
    assert(topicId != null && topicId.isNotEmpty);

    if (_cache[topicId] != null) {
      return _cache[topicId];
    }
    try {
      final documentSnapshot =
          await _firestore.collection('topics').doc(topicId).get();

      final topicModel = TopicModel()
        ..id = documentSnapshot.data()['id'] as String
        ..text = documentSnapshot.data()['text'] as String
        ..imageUrl = documentSnapshot.data()['image_url'] as String
        ..answeredTime = documentSnapshot.data()['answered_time'] as int
        ..createdAt =
            (documentSnapshot.data()['created_at'] as Timestamp).toDate()
        ..createdUser = documentSnapshot.data()['created_user'] as String;
      _cache[topicId] = topicModel;
      return topicModel;
    } on Exception catch (error) {
      rethrow;
    }
  }

  @override
  Future<void> postTopic({
    @required String userId,
    @required TopicModel topic,
  }) async {
    assert(userId != null);
    assert(topic != null);

    await _firestore.runTransaction<void>(
      (transaction) {
        final topicRef = _firestore.collection('topics').doc();
        final topicMap = {
          'id': topicRef.id,
          'text': topic.text,
          'image_url': topic.imageUrl ?? '',
          'answered_time': 0,
          'created_at': FieldValue.serverTimestamp(),
          'created_user': userId,
        };
        transaction.set(
          topicRef,
          topicMap,
        );
        final userCreateTopicRef = _firestore
            .collection('users')
            .doc(userId)
            .collection('create_topics')
            .doc(topicRef.id);
        final userMap = {
          'id': topicRef.id,
          'create_at': FieldValue.serverTimestamp(),
        };
        transaction.set(
          userCreateTopicRef,
          userMap,
        );
        return;
      },
    );
  }

  @override
  Future<List<TopicModel>> getNewTopicList({
    @required DateTime beforeTime,
    @required int count,
  }) async {
    assert(count != null);
    assert(count > 0);

    QuerySnapshot querySnapshot;
    if (beforeTime != null) {
      querySnapshot = await _firestore
          .collection('topics')
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
          .collection('topics')
          .orderBy('created_at', descending: true)
          .limit(count)
          .get();
    }

    return querySnapshot.docs.map((DocumentSnapshot documentSnapshot) {
      return TopicModel()
        ..id = documentSnapshot.data()['id'] as String
        ..text = documentSnapshot.data()['text'] as String
        ..imageUrl = documentSnapshot.data()['image_url'] as String
        ..answeredTime = documentSnapshot.data()['answered_time'] as int
        ..createdAt =
            (documentSnapshot.data()['created_at'] as Timestamp).toDate()
        ..createdUser = documentSnapshot.data()['created_user'] as String;
    }).toList();
  }
}

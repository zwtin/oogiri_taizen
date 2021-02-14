import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';

import 'package:oogiritaizen/model/model/topic_model.dart';
import 'package:oogiritaizen/model/model/user_model.dart';
import 'package:oogiritaizen/model/repository/topic_repository.dart';

final topicRepositoryProvider = Provider<TopicRepository>(
  (ref) {
    return TopicRepositoryImpl();
  },
);

class TopicRepositoryImpl implements TopicRepository {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<TopicModel> getTopic({
    @required String topicId,
  }) {
    assert(topicId != null);
    assert(topicId.isNotEmpty);

    return _firestore.collection('topics').doc(topicId).get().then(
      (DocumentSnapshot snapshot) {
        return TopicModel()
          ..id = snapshot.data()['id'] as String
          ..text = snapshot.data()['text'] as String
          ..imageUrl = snapshot.data()['image_url'] as String
          ..answeredTime = snapshot.data()['answered_time'] as int
          ..createdAt = (snapshot.data()['created_at'] as Timestamp).toDate()
          ..createdUser = snapshot.data()['created_user'] as String;
      },
    );
  }

  @override
  Future<void> postTopic({
    @required UserModel user,
    @required TopicModel topic,
  }) async {
    assert(user != null);
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
          'created_user': user.id,
        };
        transaction.set(
          topicRef,
          topicMap,
        );
        final userCreateTopicRef = _firestore
            .collection('users')
            .doc(user.id)
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

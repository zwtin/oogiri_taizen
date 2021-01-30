import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oogiritaizen/data/model/entity/topic.dart';
import 'package:oogiritaizen/data/model/entity/user.dart';
import 'package:oogiritaizen/data/model/parameters/get_new_topic_list_parameter.dart';
import 'package:oogiritaizen/data/model/responses/get_new_topic_list_response.dart';

class FirestoreTopicRepository {
  final _firestore = FirebaseFirestore.instance;

//  @override
//  Stream<List<TopicEntity>> getTopicListStream() {
//    return _firestore.collection('topics').snapshots().map(
//      (QuerySnapshot snapshot) {
//        return snapshot.documents.map(
//          (DocumentSnapshot docs) {
//            return TopicEntity(
//              id: docs.data['id'] as String,
//              text: docs.data['text'] as String,
//              imageUrl: docs.data['image_url'] as String,
//              createdAt: docs.data['created_at'].toDate() as DateTime,
//              createdUser: docs.data['created_user'] as String,
//            );
//          },
//        ).toList();
//      },
//    );
//  }

//  @override
//  Future<List<TopicEntity>> getTopicList() async {
//    final list = await _firestore.collection('topics').getDocuments().then(
//      (QuerySnapshot querySnapshot) {
//        return querySnapshot.documents.map(
//          (DocumentSnapshot docs) {
//            return TopicEntity(
//              id: docs.data['id'] as String,
//              text: docs.data['text'] as String,
//              imageUrl: docs.data['image_url'] as String,
//              createdAt: docs.data['created_at'].toDate() as DateTime,
//              createdUser: docs.data['created_user'] as String,
//            );
//          },
//        ).toList();
//      },
//    );
//    return list;
//  }

//  @override
//  Stream<TopicEntity> getTopicStream({@required String id}) {
//    return _firestore.collection('topics').document(id).snapshots().map(
//      (DocumentSnapshot snapshot) {
//        return TopicEntity(
//          id: snapshot.data['id'] as String,
//          text: snapshot.data['text'] as String,
//          imageUrl: snapshot.data['image_url'] as String,
//          createdAt: snapshot.data['created_at'].toDate() as DateTime,
//          createdUser: snapshot.data['created_user'] as String,
//        );
//      },
//    );
//  }

//  @override
//  Future<TopicEntity> getTopic({@required String id}) {
//    return _firestore.collection('topics').document(id).get().then(
//      (DocumentSnapshot snapshot) {
//        return TopicEntity(
//          id: snapshot.data['id'] as String,
//          text: snapshot.data['text'] as String,
//          imageUrl: snapshot.data['image_url'] as String,
//          createdAt: snapshot.data['created_at'].toDate() as DateTime,
//          createdUser: snapshot.data['created_user'] as String,
//        );
//      },
//    );
//  }

  Future<void> postTopic({@required User user, @required Topic topic}) async {
    await _firestore.runTransaction<void>(
      (transaction) {
        final topicRef = _firestore.collection('topics').doc();
        final topicMap = {
          'id': topicRef.id,
          'text': topic.text,
          'image_url': topic.imageUrl ?? '',
          'created_at': FieldValue.serverTimestamp(),
          'created_user': user.id,
        };
        transaction.set(
          topicRef,
          topicMap,
        );
        final userTopicRef = _firestore
            .collection('users')
            .doc(user.id)
            .collection('create_topics')
            .doc(topicRef.id);
        final userMap = {
          'id': topicRef.id,
          'create_at': FieldValue.serverTimestamp(),
        };
        transaction.set(
          userTopicRef,
          userMap,
        );
        return null;
      },
    );
  }

  // createdAtより古い回答を10個返す
  Future<GetNewTopicListResponse> getNewTopicList(
      {@required GetNewTopicListParameter parameter}) async {
    QuerySnapshot querySnapshot;
    if (parameter?.topic?.createdAt != null) {
      querySnapshot = await _firestore
          .collection('topics')
          .where(
            'created_at',
            isLessThan: parameter.topic.createdAt.add(
              const Duration(
                milliseconds: -1,
              ),
            ),
          )
          .orderBy('created_at', descending: true)
          .limit(11)
          .get();
    } else {
      querySnapshot = await _firestore
          .collection('topics')
          .orderBy('created_at', descending: true)
          .limit(11)
          .get();
    }
    var list = querySnapshot.docs.map((DocumentSnapshot documentSnapshot) {
      return Topic()
        ..id = documentSnapshot.data()['id'] as String
        ..text = documentSnapshot.data()['text'] as String
        ..imageUrl = documentSnapshot.data()['image_url'] as String
        ..createdAt =
            (documentSnapshot.data()['created_at'] as Timestamp).toDate()
        ..createdUser = documentSnapshot.data()['created_user'] as String;
    }).toList();

    final hasNext = list.length > 10;

    if (hasNext) {
      // 11個取得できた時は、最後の要素を削除
      list.removeLast();
    }
    return GetNewTopicListResponse()
      ..topics = list
      ..hasNext = hasNext;
  }
}

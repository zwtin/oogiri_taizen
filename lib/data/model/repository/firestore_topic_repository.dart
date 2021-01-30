import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oogiritaizen/data/model/entity/topic.dart';
import 'package:oogiritaizen/data/model/entity/user.dart';

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
}

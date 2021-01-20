import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oogiritaizen/data/model/entity/user.dart';

class FirestoreUserRepository {
  final _firestore = FirebaseFirestore.instance;

  Stream<User> getUserStream({@required String userId}) {
    return _firestore.collection('users').doc(userId).snapshots().map(
      (DocumentSnapshot snapshot) {
        return User()
          ..id = snapshot.data()['id'] as String
          ..name = snapshot.data()['name'] as String
          ..imageUrl = snapshot.data()['image_url'] as String
          ..introduction = snapshot.data()['introduction'] as String;
      },
    );
  }

  Future<User> getUser({@required String userId}) async {
    return _firestore.collection('users').doc(userId).get().then(
      (DocumentSnapshot snapshot) {
        return User()
          ..id = snapshot.data()['id'] as String
          ..name = snapshot.data()['name'] as String
          ..imageUrl = snapshot.data()['image_url'] as String
          ..introduction = snapshot.data()['introduction'] as String;
      },
    );
  }

//
//  @override
//  Future<bool> isExistUser({@required String userId}) async {
//    final data = await _firestore.collection('users').document(userId).get();
//    return data.exists;
//  }
//
//  @override
//  Future<void> createUser({@required String userId}) async {
//    await _firestore.collection('users').document(userId).setData(
//      <String, dynamic>{
//        'id': userId,
//        'introduction': 'よろしくお願いします。',
//        'image_url': '',
//        'name': '名無し',
//      },
//    );
//  }
//
  Future<void> updateUser(
      {@required String userId, @required User user}) async {
    final data = <String, dynamic>{};
    if (user.name != null) {
      data['name'] = user.name;
    }
    if (user.introduction != null) {
      data['introduction'] = user.introduction;
    }
    if (user.imageUrl != null) {
      data['image_url'] = user.imageUrl;
    }
    await _firestore.collection('users').doc(userId).update(data);
  }
//
//  @override
//  Stream<List<CreateAnswerEntity>> getCreateAnswersStream(
//      {@required String userId}) {
//    return _firestore
//        .collection('users')
//        .document(userId)
//        .collection('create_answers')
//        .snapshots()
//        .map(
//      (QuerySnapshot querySnapshot) {
//        return querySnapshot.documents.map(
//          (DocumentSnapshot documentSnapshot) {
//            return CreateAnswerEntity(
//              id: documentSnapshot.data['id'] as String,
//              createdAt:
//                  documentSnapshot.data['created_at']?.toDate() as DateTime,
//            );
//          },
//        ).toList();
//      },
//    );
//  }
//
//  @override
//  Stream<List<FavoriteAnswerEntity>> getFavoriteAnswersStream(
//      {@required String userId}) {
//    return _firestore
//        .collection('users')
//        .document(userId)
//        .collection('favorite_answers')
//        .snapshots()
//        .map(
//      (QuerySnapshot querySnapshot) {
//        return querySnapshot.documents.map(
//          (DocumentSnapshot documentSnapshot) {
//            return FavoriteAnswerEntity(
//              id: documentSnapshot.data['id'] as String,
//              favoredAt:
//                  documentSnapshot.data['favor_at']?.toDate() as DateTime,
//            );
//          },
//        ).toList();
//      },
//    );
//  }
}

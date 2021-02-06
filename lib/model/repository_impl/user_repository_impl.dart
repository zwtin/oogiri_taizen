import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import 'package:oogiritaizen/model/model/user_model.dart';
import 'package:oogiritaizen/model/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final _firestore = FirebaseFirestore.instance;

  @override
  Stream<UserModel> getUserStream({
    @required String userId,
  }) {
    return _firestore.collection('users').doc(userId).snapshots().map(
      (DocumentSnapshot snapshot) {
        return UserModel()
          ..id = snapshot.data()['id'] as String
          ..name = snapshot.data()['name'] as String
          ..imageUrl = snapshot.data()['image_url'] as String
          ..introduction = snapshot.data()['introduction'] as String;
      },
    );
  }

  @override
  Future<UserModel> getUser({
    @required String userId,
  }) async {
    return _firestore.collection('users').doc(userId).get().then(
      (DocumentSnapshot snapshot) {
        return UserModel()
          ..id = snapshot.data()['id'] as String
          ..name = snapshot.data()['name'] as String
          ..imageUrl = snapshot.data()['image_url'] as String
          ..introduction = snapshot.data()['introduction'] as String;
      },
    );
  }

  @override
  Future<void> updateUser({
    @required String userId,
    @required UserModel user,
  }) async {
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

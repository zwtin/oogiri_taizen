import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meta/meta.dart';

import 'package:oogiritaizen/model/model/user_model.dart';
import 'package:oogiritaizen/model/repository/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>(
  (ref) {
    return UserRepositoryImpl();
  },
);

class UserRepositoryImpl implements UserRepository {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createUser({
    @required String userId,
  }) async {
    assert(userId != null);

    final data = <String, dynamic>{};
    data['id'] = userId;
    data['name'] = '名無し';
    data['introduction'] = 'よろしくお願いします。';
    data['image_url'] = '';

    try {
      await _firestore.collection('users').doc(userId).set(data);
    } on Exception catch (error) {}
  }

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
    @required UserModel user,
  }) async {
    assert(user.id != null);

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
    try {
      await _firestore.collection('users').doc(user.id).update(data);
    } on Exception catch (error) {}
  }

  @override
  Future<List<String>> getCreateAnswers({
    @required String userId,
    @required DateTime beforeTime,
    @required int count,
  }) async {
    assert(count != null && count > 0);

    try {
      QuerySnapshot querySnapshot;
      if (beforeTime != null) {
        querySnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('create_answers')
            .where(
              'create_at',
              isLessThan: beforeTime.add(
                const Duration(
                  milliseconds: -1,
                ),
              ),
            )
            .orderBy('create_at', descending: true)
            .limit(count)
            .get();
      } else {
        querySnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('create_answers')
            .orderBy('create_at', descending: true)
            .limit(count)
            .get();
      }

      return querySnapshot.docs.map((DocumentSnapshot documentSnapshot) {
        return documentSnapshot.data()['id'] as String;
      }).toList();
    } on Exception catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getFavorAnswers({
    @required String userId,
    @required DateTime beforeTime,
    @required int count,
  }) async {
    assert(count != null && count > 0);

    try {
      QuerySnapshot querySnapshot;
      if (beforeTime != null) {
        querySnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('favor_answers')
            .where(
              'favor_at',
              isLessThan: beforeTime.add(
                const Duration(
                  milliseconds: -1,
                ),
              ),
            )
            .orderBy('favor_at', descending: true)
            .limit(count)
            .get();
      } else {
        querySnapshot = await _firestore
            .collection('users')
            .doc(userId)
            .collection('favor_answers')
            .orderBy('favor_at', descending: true)
            .limit(count)
            .get();
      }

      return querySnapshot.docs.map((DocumentSnapshot documentSnapshot) {
        return documentSnapshot.data()['id'] as String;
      }).toList();
    } on Exception catch (error) {
      rethrow;
    }
  }
}

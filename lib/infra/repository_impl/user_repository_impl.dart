import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';

import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';

final userRepositoryProvider = Provider.autoDispose<UserRepository>(
  (ref) {
    final userRepository = UserRepositoryImpl();
    ref.onDispose(userRepository.disposed);
    return userRepository;
  },
);

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<User>> getUser({
    required String id,
  }) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      final data = doc.data();
      if (data == null) {
        throw OTException();
      }
      final user = User(
        id: data['id'] as String,
        name: data['name'] as String,
        imageUrl: data['image_url'] as String,
        introduction: data['introduction'] as String,
      );
      return Result.success(user);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Stream<User?> getUserStream({
    required String id,
  }) {
    return _firestore.collection('users').doc(id).snapshots().map(
      (snapshot) {
        final data = snapshot.data();
        if (data == null) {
          return null;
        }
        return User(
          id: data['id'] as String,
          name: data['name'] as String,
          imageUrl: data['image_url'] as String,
          introduction: data['introduction'] as String,
        );
      },
    );
  }

  @override
  Future<Result<void>> createUser({
    required String id,
  }) async {
    try {
      await _firestore.runTransaction<void>(
        (Transaction transaction) async {
          final userRef = _firestore.collection('users').doc(id);
          final userMap = {
            'id': id,
            'image_url': '',
            'introduction': 'よろしくお願いします',
            'name': '名無し',
          };
          transaction.set(
            userRef,
            userMap,
          );
        },
      );
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<void>> updateUser({
    required String id,
    required String? name,
    required String? imageUrl,
    required String? introduction,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) {
        data['name'] = name;
      }
      if (imageUrl != null) {
        data['image_url'] = imageUrl;
      }
      if (introduction != null) {
        data['introduction'] = introduction;
      }
      await _firestore.runTransaction<void>(
        (Transaction transaction) async {
          final ref = _firestore.collection('users').doc(id);
          transaction.update(
            ref,
            data,
          );
        },
      );
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  Future<void> disposed() async {
    debugPrint('UserRepositoryImpl disposed');
  }
}

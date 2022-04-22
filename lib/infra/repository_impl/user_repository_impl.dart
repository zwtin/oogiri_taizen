import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/infra/mapper/user_mapper.dart';

final userRepositoryProvider = Provider.autoDispose<UserRepository>(
  (ref) {
    final userRepository = UserRepositoryImpl();
    ref.onDispose(userRepository.dispose);
    return userRepository;
  },
);

class UserRepositoryImpl implements UserRepository {
  final _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<User>> getUser({
    required String id,
  }) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      final data = doc.data();
      if (data == null) {
        throw OTException(title: 'エラー', text: 'ユーザーの取得に失敗しました');
      }
      final user = mappingForUser(userData: data);
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
        final user = mappingForUser(userData: data);
        return user;
      },
    );
  }

  @override
  Future<Result<void>> createUser({
    required String id,
  }) async {
    try {
      final ref = _firestore.collection('users').doc(id);
      final data = {
        'id': id,
        'introduction': 'よろしくお願いします',
        'name': '名無し',
      };
      await _firestore.runTransaction<void>(
        (Transaction transaction) async {
          transaction.set(
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

  @override
  Future<Result<void>> updateUser({
    required String id,
    required String? name,
    required String? imageUrl,
    required String? introduction,
  }) async {
    try {
      final ref = _firestore.collection('users').doc(id);
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

  void dispose() {
    _logger.d('UserRepositoryImpl dispose');
  }
}

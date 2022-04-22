import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/favor_repository.dart';

final favorRepositoryProvider = Provider.autoDispose<FavorRepository>(
  (ref) {
    final favorRepository = FavorRepositoryImpl();
    ref.onDispose(favorRepository.dispose);
    return favorRepository;
  },
);

class FavorRepositoryImpl implements FavorRepository {
  final _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<void>> favor({
    required String userId,
    required String answerId,
  }) async {
    try {
      await _firestore.runTransaction<void>(
        (Transaction transaction) async {
          final answerRef = _firestore.collection('answers').doc(answerId);
          final answerDoc = await transaction.get(answerRef);
          final answerData = answerDoc.data();
          if (answerData == null) {
            throw OTException(text: 'エラー', title: 'ボケの取得に失敗しました');
          }

          final answerFavoredUserRef = _firestore
              .collection('answers')
              .doc(answerId)
              .collection('favored_users')
              .doc(userId);
          final answerFavoredUserDoc =
              await transaction.get(answerFavoredUserRef);

          final userFavorAnswerRef = _firestore
              .collection('users')
              .doc(userId)
              .collection('favor_answers')
              .doc(answerId);
          final userFavorAnswerDoc = await transaction.get(userFavorAnswerRef);

          if (answerFavoredUserDoc.exists && userFavorAnswerDoc.exists) {
            final favoredTime = answerData['favored_time'] as int;
            final favorUpdateMap = {
              'favored_time': favoredTime - 1,
            };
            transaction.update(answerRef, favorUpdateMap)
              ..delete(answerFavoredUserRef)
              ..delete(userFavorAnswerRef);
          } else if (!answerFavoredUserDoc.exists &&
              !userFavorAnswerDoc.exists) {
            final favoredTime = answerData['favored_time'] as int;
            final favorUpdateMap = {
              'favored_time': favoredTime + 1,
            };
            transaction.update(answerRef, favorUpdateMap);

            final answerFavoredUserMap = {
              'id': userId,
              'favored_at': FieldValue.serverTimestamp(),
            };
            transaction.set(
              answerFavoredUserRef,
              answerFavoredUserMap,
            );

            final userMap = {
              'id': answerId,
              'favor_at': FieldValue.serverTimestamp(),
            };
            transaction.set(
              userFavorAnswerRef,
              userMap,
            );
          }
        },
      );
      return const Result.success(null);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<bool>> getFavor({
    required String userId,
    required String answerId,
  }) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favor_answers')
          .doc(answerId)
          .get();
      return Result.success(doc.exists);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Stream<bool> getFavorStream({
    required String userId,
    required String answerId,
  }) {
    final favorStream = _firestore
        .collection('users')
        .doc(userId)
        .collection('favor_answers')
        .doc(answerId)
        .snapshots()
        .map((snapshot) {
      return snapshot.exists;
    });
    return favorStream;
  }

  @override
  Future<Result<DateTime>> getFavoredTime({
    required String userId,
    required String answerId,
  }) async {
    try {
      final favorDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favor_answers')
          .doc(answerId)
          .get();
      final favorData = favorDoc.data();
      if (favorData == null) {
        throw OTException(title: 'エラー', text: 'お気に入り情報の取得に失敗しました');
      }
      final favorDate = (favorData['favor_at'] as Timestamp).toDate();
      return Result.success(favorDate);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  void dispose() {
    _logger.d('FavorRepositoryImpl dispose');
  }
}

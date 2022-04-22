import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/repository/answer_repository.dart';
import 'package:oogiri_taizen/infra/mapper/answer_mapper.dart';

final answerRepositoryProvider = Provider.autoDispose<AnswerRepository>(
  (ref) {
    final answerRepository = AnswerRepositoryImpl();
    ref.onDispose(answerRepository.dispose);
    return answerRepository;
  },
);

class AnswerRepositoryImpl implements AnswerRepository {
  final _logger = Logger();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<Answer>> getAnswer({
    required String id,
  }) async {
    try {
      final answerDoc = await _firestore.collection('answers').doc(id).get();
      final answerData = answerDoc.data();
      if (answerData == null) {
        throw OTException(title: 'エラー', text: 'ボケの取得に失敗しました');
      }
      final answer = mappingForAnswer(answerData: answerData);
      return Result.success(answer);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<Answers>> getNewAnswerIds({
    required DateTime? offset,
    required int limit,
  }) async {
    try {
      final QuerySnapshot query;
      if (offset != null) {
        query = await _firestore
            .collection('answers')
            .where(
              'created_at',
              isLessThan: offset.add(
                const Duration(
                  milliseconds: -1,
                ),
              ),
            )
            .orderBy('created_at', descending: true)
            .limit(limit)
            .get();
      } else {
        query = await _firestore
            .collection('answers')
            .orderBy('created_at', descending: true)
            .limit(limit)
            .get();
      }
      final list = query.docs
          .map(
            (doc) {
              final data = doc.data() as Map<String, dynamic>?;
              if (data == null) {
                return null;
              }
              return mappingForAnswer(answerData: data);
            },
          )
          .whereType<Answer>()
          .toList();
      final answers = Answers(list: list);
      return Result.success(answers);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<Answers>> getCreatedAnswerIds({
    required String userId,
    required DateTime? offset,
    required int limit,
  }) async {
    try {
      final QuerySnapshot query;
      if (offset != null) {
        query = await _firestore
            .collection('users')
            .doc(userId)
            .collection('create_answers')
            .where(
              'create_at',
              isLessThan: offset.add(
                const Duration(
                  milliseconds: -1,
                ),
              ),
            )
            .orderBy('create_at', descending: true)
            .limit(limit)
            .get();
      } else {
        query = await _firestore
            .collection('users')
            .doc(userId)
            .collection('create_answers')
            .orderBy('create_at', descending: true)
            .limit(limit)
            .get();
      }
      final list = query.docs
          .map(
            (doc) {
              final data = doc.data() as Map<String, dynamic>?;
              if (data == null) {
                return null;
              }
              return mappingForAnswer(answerData: data);
            },
          )
          .whereType<Answer>()
          .toList();
      final answers = Answers(list: list);
      return Result.success(answers);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  @override
  Future<Result<Answers>> getFavorAnswerIds({
    required String userId,
    required DateTime? offset,
    required int limit,
  }) async {
    try {
      final QuerySnapshot query;
      if (offset != null) {
        query = await _firestore
            .collection('users')
            .doc(userId)
            .collection('favor_answers')
            .where(
              'favor_at',
              isLessThan: offset.add(
                const Duration(
                  milliseconds: -1,
                ),
              ),
            )
            .orderBy('favor_at', descending: true)
            .limit(limit)
            .get();
      } else {
        query = await _firestore
            .collection('users')
            .doc(userId)
            .collection('favor_answers')
            .orderBy('favor_at', descending: true)
            .limit(limit)
            .get();
      }
      final list = query.docs
          .map(
            (doc) {
              final data = doc.data() as Map<String, dynamic>?;
              if (data == null) {
                return null;
              }
              return mappingForAnswer(answerData: data);
            },
          )
          .whereType<Answer>()
          .toList();
      final answers = Answers(list: list);
      return Result.success(answers);
    } on Exception catch (exception) {
      return Result.failure(exception);
    }
  }

  void dispose() {
    _logger.d('AnswerRepositoryImpl dispose');
  }
}

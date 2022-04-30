import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class FavorRepository {
  Future<Result<void>> favor({
    required String userId,
    required String answerId,
  });

  Future<Result<void>> unfavor({
    required String userId,
    required String answerId,
  });

  Future<Result<bool>> getFavor({
    required String userId,
    required String answerId,
  });

  Stream<bool> getFavorStream({
    required String userId,
    required String answerId,
  });

  Future<Result<DateTime>> getFavoredTime({
    required String userId,
    required String answerId,
  });
}

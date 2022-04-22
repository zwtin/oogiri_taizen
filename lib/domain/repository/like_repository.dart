import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class LikeRepository {
  Future<Result<void>> like({
    required String userId,
    required String answerId,
  });

  Future<Result<bool>> getLike({
    required String userId,
    required String answerId,
  });

  Stream<bool> getLikeStream({
    required String userId,
    required String answerId,
  });
}

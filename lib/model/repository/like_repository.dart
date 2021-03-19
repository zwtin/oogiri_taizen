import 'package:meta/meta.dart';

abstract class LikeRepository {
  Future<bool> getLike({
    @required String userId,
    @required String answerId,
  });

  Future<void> like({
    @required String userId,
    @required String answerId,
  });

  Future<void> unlike({
    @required String userId,
    @required String answerId,
  });
}

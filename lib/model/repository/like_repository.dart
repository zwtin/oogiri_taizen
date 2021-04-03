import 'package:meta/meta.dart';
import 'package:oogiritaizen/model/model/is_like_model.dart';

abstract class LikeRepository {
  Future<IsLikeModel> getLike({
    @required String userId,
    @required String answerId,
  });

  Stream<IsLikeModel> getLikeStream({
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

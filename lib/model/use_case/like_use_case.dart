import 'package:meta/meta.dart';
import 'package:oogiritaizen/model/entity/is_like_entity.dart';

abstract class LikeUseCase {
  Stream<IsLikeEntity> getLikeStream({
    @required String answerId,
  });

  Future<void> like({
    @required String answerId,
  });

  Future<void> unlike({
    @required String answerId,
  });
}

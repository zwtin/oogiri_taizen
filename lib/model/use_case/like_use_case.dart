import 'package:meta/meta.dart';

abstract class LikeUseCase {
  Stream<bool> getLikeStream({
    @required String answerId,
  });

  Future<void> like({
    @required String answerId,
  });

  Future<void> unlike({
    @required String answerId,
  });
}

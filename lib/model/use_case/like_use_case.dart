import 'package:meta/meta.dart';

abstract class LikeUseCase {
  Future<bool> getLike({
    @required String answerId,
  });

  Future<void> like({
    @required String answerId,
  });

  Future<void> unlike({
    @required String answerId,
  });
}

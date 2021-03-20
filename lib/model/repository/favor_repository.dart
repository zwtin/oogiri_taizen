import 'package:meta/meta.dart';

abstract class FavorRepository {
  Future<bool> getFavor({
    @required String userId,
    @required String answerId,
  });

  Stream<bool> getFavorStream({
    @required String userId,
    @required String answerId,
  });

  Future<void> favor({
    @required String userId,
    @required String answerId,
  });

  Future<void> unfavor({
    @required String userId,
    @required String answerId,
  });
}

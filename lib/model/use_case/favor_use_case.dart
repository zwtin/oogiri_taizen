import 'package:meta/meta.dart';

abstract class FavorUseCase {
  Stream<bool> getFavorStream({
    @required String answerId,
  });

  Future<void> favor({
    @required String answerId,
  });

  Future<void> unfavor({
    @required String answerId,
  });
}

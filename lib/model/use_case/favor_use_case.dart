import 'package:meta/meta.dart';
import 'package:oogiritaizen/model/entity/is_favor_entity.dart';

abstract class FavorUseCase {
  Stream<IsFavorEntity> getFavorStream({
    @required String answerId,
  });

  Future<void> favor({
    @required String answerId,
  });

  Future<void> unfavor({
    @required String answerId,
  });
}

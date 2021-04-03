import 'package:meta/meta.dart';
import 'package:oogiritaizen/model/model/is_favor_model.dart';

abstract class FavorRepository {
  Future<IsFavorModel> getFavor({
    @required String userId,
    @required String answerId,
  });

  Stream<IsFavorModel> getFavorStream({
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

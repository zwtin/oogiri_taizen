import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class FavorUseCase {
  Future<Result<void>> favor({required Answer answer});
}

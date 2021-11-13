import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';

abstract class LikeUseCase {
  Future<Result<void>> like({required Answer answer});
}

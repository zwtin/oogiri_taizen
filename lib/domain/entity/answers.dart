import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';
part 'answers.freezed.dart';

@freezed
class Answers with _$Answers {
  const factory Answers({
    required List<Answer> list,
    required bool hasNext,
  }) = _Answers;
}

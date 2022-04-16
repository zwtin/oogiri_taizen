import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';

part 'answers.freezed.dart';

@freezed
abstract class Answers implements _$Answers {
  const factory Answers({
    required List<Answer> list,
  }) = _Answers;
  const Answers._();

  int length() {
    return list.length;
  }
}

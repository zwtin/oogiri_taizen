import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
part 'topics.freezed.dart';

@freezed
class Topics with _$Topics {
  const factory Topics({
    required List<Topic> list,
    required bool hasNext,
  }) = _Topics;
}

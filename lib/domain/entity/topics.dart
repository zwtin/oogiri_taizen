import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';

part 'topics.freezed.dart';

@freezed
abstract class Topics implements _$Topics {
  const factory Topics({
    required List<Topic> list,
  }) = _Topics;
  const Topics._();

  int length() {
    return list.length;
  }
}

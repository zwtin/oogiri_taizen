import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';

part 'topics.freezed.dart';

@freezed
abstract class Topics implements _$Topics {
  const factory Topics({
    required List<Topic> list,
  }) = _Topics;
  const Topics._();

  int get length => list.length;
  bool get isEmpty => list.isEmpty;
  Topic? get firstOrNull => list.firstOrNull;
  Topic? get lastOrNull => list.lastOrNull;

  void removeLast() {
    list.removeLast();
  }

  Topic get(int index) {
    return list[index];
  }
}

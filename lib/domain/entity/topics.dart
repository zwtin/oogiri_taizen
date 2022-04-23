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

  Topics added(Topic topic) {
    final newList = List.of(list)..add(topic);
    return Topics(list: newList);
  }

  Topics removedLast() {
    final newList = List.of(list)..removeLast();
    return Topics(list: newList);
  }

  Topic? getByIndex(int index) {
    if (index < list.length) {
      return list[index];
    } else {
      return null;
    }
  }

  Topic? getById(String id) {
    if (list.any((element) => element.id == id)) {
      return list.firstWhere((element) => element.id == id);
    } else {
      return null;
    }
  }
}

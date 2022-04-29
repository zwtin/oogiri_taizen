import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';

part 'answers.freezed.dart';

@freezed
abstract class Answers implements _$Answers {
  const factory Answers({
    required List<Answer> list,
  }) = _Answers;
  const Answers._();

  int get length => list.length;
  bool get isEmpty => list.isEmpty;
  Answer? get firstOrNull => list.firstOrNull;
  Answer? get lastOrNull => list.lastOrNull;

  Answers added(Answer answer) {
    final newList = List.of(list)..add(answer);
    return Answers(list: newList);
  }

  Answers removed(Answer answer) {
    final newList = List.of(list)
      ..removeWhere((element) => element.id == answer.id);
    return Answers(list: newList);
  }

  Answers removedLast() {
    final newList = List.of(list)..removeLast();
    return Answers(list: newList);
  }

  Answer? getByIndex(int index) {
    if (index < list.length) {
      return list[index];
    } else {
      return null;
    }
  }

  Answer? getById(String id) {
    if (list.any((element) => element.id == id)) {
      return list.firstWhere((element) => element.id == id);
    } else {
      return null;
    }
  }

  Answers update(Answer answer) {
    if (list.any((element) => element.id == answer.id)) {
      final index = list.indexWhere((element) => element.id == answer.id);
      final newList = List.of(list)
        ..replaceRange(
          index,
          index + 1,
          [answer],
        );
      return Answers(list: newList);
    } else {
      return Answers(list: list);
    }
  }

  Answers filteredBlock({
    required List<String> blockAnswerIds,
    required List<String> blockTopicIds,
    required List<String> blockUserIds,
  }) {
    final filteredList = List<Answer>.from(list.where((answer) {
      return !(blockAnswerIds.contains(answer.id) ||
          (blockTopicIds.contains(answer.topic?.id)) ||
          (blockUserIds.contains(answer.createdUser?.id)) ||
          (blockUserIds.contains(answer.topic?.createdUser?.id)));
    }));
    return Answers(list: filteredList);
  }
}

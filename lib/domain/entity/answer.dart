import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
part 'answer.freezed.dart';

@freezed
class Answer with _$Answer {
  const factory Answer({
    required String id,
    required String text,
    required int viewedTime,
    required bool isLike,
    required int likedTime,
    required bool isFavor,
    required int favoredTime,
    required int point,
    required DateTime createdAt,
    required Topic topic,
    required User createdUser,
    required bool isOwn,
  }) = _Answer;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';

part 'answer.freezed.dart';

@freezed
abstract class Answer implements _$Answer {
  const factory Answer({
    required String id,
    required String text,
    required int viewedCount,
    required int likedCount,
    required int favoredCount,
    required int popularPoint,
    required Topic topic,
    required User createdUser,
    required DateTime createdAt,
  }) = _Answer;
  const Answer._();
}

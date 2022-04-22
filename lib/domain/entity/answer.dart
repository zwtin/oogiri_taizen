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
    required bool isLike,
    required int likedCount,
    required bool isFavor,
    required int favoredCount,
    required int popularPoint,
    required String topicId,
    Topic? topic,
    required String createdUserId,
    User? createdUser,
    required DateTime createdAt,
  }) = _Answer;
  const Answer._();
}

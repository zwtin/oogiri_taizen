import 'package:freezed_annotation/freezed_annotation.dart';

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
    required String topicId,
    required String userId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<AnswerLikedUser> likedUsers,
    required List<AnswerFavoredUser> favoredUsers,
  }) = _Answer;
  const Answer._();
}

@freezed
abstract class AnswerLikedUser implements _$AnswerLikedUser {
  const factory AnswerLikedUser({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AnswerLikedUser;
  const AnswerLikedUser._();
}

@freezed
abstract class AnswerFavoredUser implements _$AnswerFavoredUser {
  const factory AnswerFavoredUser({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AnswerFavoredUser;
  const AnswerFavoredUser._();
}

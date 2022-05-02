import 'package:freezed_annotation/freezed_annotation.dart';

part 'answer_list_card_view_data.freezed.dart';

@freezed
class AnswerListCardViewData with _$AnswerListCardViewData {
  const factory AnswerListCardViewData({
    required String answerId,
    required String userId,
    String? userImageUrl,
    required DateTime createdTime,
    required String userName,
    required String text,
    String? imageUrl,
    String? imageTag,
    required bool isLike,
    required int likedCount,
    required bool isFavor,
    required int favoredCount,
  }) = _AnswerListCardViewData;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'answer_detail_answer_card_view_data.freezed.dart';

@freezed
class AnswerDetailAnswerCardViewData with _$AnswerDetailAnswerCardViewData {
  const factory AnswerDetailAnswerCardViewData({
    String? userImageUrl,
    required DateTime createdTime,
    required String userName,
    required String text,
    required bool isLike,
    required int likedCount,
    required bool isFavor,
    required int favoredCount,
  }) = _AnswerDetailAnswerCardViewData;
}

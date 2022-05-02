import 'package:freezed_annotation/freezed_annotation.dart';

part 'answer_detail_topic_card_view_data.freezed.dart';

@freezed
class AnswerDetailTopicCardViewData with _$AnswerDetailTopicCardViewData {
  const factory AnswerDetailTopicCardViewData({
    required String topicId,
    required String userId,
    String? userImageUrl,
    required DateTime createdTime,
    required String userName,
    required String text,
    String? imageUrl,
    String? imageTag,
  }) = _AnswerDetailTopicCardViewData;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'block_topic_list_card_view_data.freezed.dart';

@freezed
class BlockTopicListCardViewData with _$BlockTopicListCardViewData {
  const factory BlockTopicListCardViewData({
    required String id,
    String? userImageUrl,
    required DateTime createdTime,
    required String userName,
    required String text,
    String? imageUrl,
    String? imageTag,
  }) = _BlockTopicListCardViewData;
}

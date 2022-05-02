import 'package:freezed_annotation/freezed_annotation.dart';

part 'block_answer_list_card_view_data.freezed.dart';

@freezed
class BlockAnswerListCardViewData with _$BlockAnswerListCardViewData {
  const factory BlockAnswerListCardViewData({
    required String id,
    String? userImageUrl,
    required DateTime createdTime,
    required String userName,
    required String text,
  }) = _BlockAnswerListCardViewData;
}

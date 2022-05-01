import 'package:freezed_annotation/freezed_annotation.dart';

part 'block_user_list_card_view_data.freezed.dart';

@freezed
class BlockUserListCardViewData with _$BlockUserListCardViewData {
  const factory BlockUserListCardViewData({
    String? userImageUrl,
    required String userName,
  }) = _BlockUserListCardViewData;
}

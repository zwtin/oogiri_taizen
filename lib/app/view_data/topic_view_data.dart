import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oogiri_taizen/app/view_data/user_view_data.dart';
part 'topic_view_data.freezed.dart';

@freezed
class TopicViewData with _$TopicViewData {
  const factory TopicViewData({
    required String id,
    required String text,
    required String? imageUrl,
    required String? imageTag,
    required int answeredTime,
    required DateTime createdAt,
    required UserViewData createdUser,
    required bool isOwn,
  }) = _TopicViewData;
}

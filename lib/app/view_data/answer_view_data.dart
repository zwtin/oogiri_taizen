import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oogiri_taizen/app/view_data/topic_view_data.dart';
import 'package:oogiri_taizen/app/view_data/user_view_data.dart';
part 'answer_view_data.freezed.dart';

@freezed
class AnswerViewData with _$AnswerViewData {
  const factory AnswerViewData({
    required String id,
    required String text,
    required int viewedTime,
    required int likedTime,
    required bool isLike,
    required int favoredTime,
    required bool isFavor,
    required int point,
    required DateTime createdAt,
    required TopicViewData topic,
    required UserViewData createdUser,
    required bool isOwn,
  }) = _AnswerViewData;
}

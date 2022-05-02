import 'package:oogiri_taizen/app/view_data/answer_detail_answer_card_view_data.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';

AnswerDetailAnswerCardViewData? mappingForAnswerDetailAnswerCardViewData({
  required Answer answer,
}) {
  if (answer.createdUser == null ||
      answer.topic == null ||
      answer.topic!.createdUser == null) {
    return null;
  }
  return AnswerDetailAnswerCardViewData(
    answerId: answer.id,
    userId: answer.createdUser!.id,
    userImageUrl: answer.createdUser!.imageUrl,
    createdTime: answer.createdAt,
    userName: answer.createdUser!.name,
    text: answer.text,
    isLike: answer.isLike,
    likedCount: answer.likedCount,
    isFavor: answer.isFavor,
    favoredCount: answer.favoredCount,
  );
}

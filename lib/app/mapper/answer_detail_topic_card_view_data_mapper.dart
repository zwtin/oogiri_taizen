import 'package:oogiri_taizen/app/view_data/answer_detail_topic_card_view_data.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/extension/string_extension.dart';

AnswerDetailTopicCardViewData? mappingForAnswerDetailTopicCardViewData({
  required Answer answer,
}) {
  if (answer.createdUser == null ||
      answer.topic == null ||
      answer.topic!.createdUser == null) {
    return null;
  }
  return AnswerDetailTopicCardViewData(
    topicId: answer.topic!.id,
    userId: answer.topic!.createdUser!.id,
    userImageUrl: answer.topic!.createdUser!.imageUrl,
    createdTime: answer.topic!.createdAt,
    userName: answer.topic!.createdUser!.name,
    text: answer.topic!.text,
    imageUrl: answer.topic!.imageUrl,
    imageTag: StringExtension.randomString(8),
  );
}

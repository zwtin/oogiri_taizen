import 'package:oogiri_taizen/app/view_data/answer_list_card_view_data.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';
import 'package:oogiri_taizen/extension/string_extension.dart';

List<AnswerListCardViewData> mappingForAnswerListCardViewData({
  required Answers answers,
}) {
  final list = <AnswerListCardViewData>[];
  for (var i = 0; i < answers.length; i++) {
    final answer = answers.getByIndex(i);
    if (answer == null ||
        answer.createdUser == null ||
        answer.topic == null ||
        answer.topic!.createdUser == null) {
      continue;
    }
    list.add(
      AnswerListCardViewData(
        answerId: answer.id,
        userId: answer.createdUser!.id,
        userImageUrl: answer.createdUser!.imageUrl,
        createdTime: answer.createdAt,
        userName: answer.createdUser!.name,
        text: answer.topic!.text,
        imageUrl: answer.topic!.imageUrl,
        imageTag: StringExtension.randomString(8),
        isLike: answer.isLike,
        likedCount: answer.likedCount,
        isFavor: answer.isFavor,
        favoredCount: answer.favoredCount,
      ),
    );
  }
  return list;
}

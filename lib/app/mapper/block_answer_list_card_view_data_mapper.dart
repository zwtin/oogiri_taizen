import 'package:oogiri_taizen/app/view_data/block_answer_list_card_view_data.dart';
import 'package:oogiri_taizen/domain/entity/answers.dart';

List<BlockAnswerListCardViewData> mappingForBlockAnswerListCardViewData({
  required Answers answers,
}) {
  final list = <BlockAnswerListCardViewData>[];
  for (var i = 0; i < answers.length; i++) {
    final answer = answers.getByIndex(i);
    if (answer == null ||
        answer.createdUser == null ||
        answer.topic == null ||
        answer.topic!.createdUser == null) {
      continue;
    }
    list.add(
      BlockAnswerListCardViewData(
        id: answer.id,
        userImageUrl: answer.createdUser!.imageUrl,
        createdTime: answer.createdAt,
        userName: answer.createdUser!.name,
        text: answer.text,
      ),
    );
  }
  return list;
}

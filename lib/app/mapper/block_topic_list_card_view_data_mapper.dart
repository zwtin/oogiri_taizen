import 'package:oogiri_taizen/app/view_data/block_topic_list_card_view_data.dart';
import 'package:oogiri_taizen/domain/entity/topics.dart';

List<BlockTopicListCardViewData> mappingForBlockTopicListCardViewData({
  required Topics topics,
}) {
  final list = <BlockTopicListCardViewData>[];
  for (var i = 0; i < topics.length; i++) {
    final topic = topics.getByIndex(i);
    if (topic == null || topic.createdUser == null) {
      continue;
    }
    list.add(
      BlockTopicListCardViewData(
        userImageUrl: topic.createdUser!.imageUrl,
        createdTime: topic.createdAt,
        userName: topic.createdUser!.name,
        text: topic.text,
      ),
    );
  }
  return list;
}

import 'package:oogiri_taizen/app/view_data/block_topic_list_card_view_data.dart';
import 'package:oogiri_taizen/domain/entity/topics.dart';
import 'package:oogiri_taizen/extension/string_extension.dart';

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
        id: topic.id,
        userImageUrl: topic.createdUser!.imageUrl,
        createdTime: topic.createdAt,
        userName: topic.createdUser!.name,
        text: topic.text,
        imageUrl: topic.imageUrl,
        imageTag: StringExtension.randomString(8),
      ),
    );
  }
  return list;
}

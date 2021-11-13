import 'package:oogiri_taizen/app/mapper/user_view_data_mapper.dart';
import 'package:oogiri_taizen/app/view_data/topic_view_data.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/extension/string_extension.dart';

class TopicViewDataMapper {
  static TopicViewData convertToViewData({required Topic topic}) {
    final userViewData = UserViewDataMapper.convertToViewData(
      user: topic.createdUser,
    );
    final topicViewData = TopicViewData(
      id: topic.id,
      text: topic.text,
      imageUrl: topic.imageUrl,
      imageTag: StringExtension.randomString(8),
      answeredTime: topic.answeredTime,
      createdAt: topic.createdAt,
      createdUser: userViewData,
      isOwn: topic.isOwn,
    );
    return topicViewData;
  }

  static Topic convertToEntity({required TopicViewData topicViewData}) {
    final user = UserViewDataMapper.convertToEntity(
      userViewData: topicViewData.createdUser,
    );
    final topic = Topic(
      id: topicViewData.id,
      text: topicViewData.text,
      imageUrl: topicViewData.imageUrl,
      answeredTime: topicViewData.answeredTime,
      createdAt: topicViewData.createdAt,
      createdUser: user,
      isOwn: topicViewData.isOwn,
    );
    return topic;
  }
}

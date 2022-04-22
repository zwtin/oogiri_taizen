import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';

Topic mappingForTopic({
  required Map<String, dynamic> topicData,
}) {
  return Topic(
    id: topicData['id'] as String,
    text: topicData['text'] as String,
    imageUrl: topicData['image_url'] as String,
    answeredCount: topicData['answered_time'] as int,
    createdUserId: topicData['created_user'] as String,
    createdAt: (topicData['created_at'] as Timestamp).toDate(),
  );
}

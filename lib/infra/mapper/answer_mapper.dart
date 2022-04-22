import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';

Answer mappingForAnswer({
  required Map<String, dynamic> answerData,
}) {
  return Answer(
    id: answerData['id'] as String,
    text: answerData['text'] as String,
    viewedCount: answerData['viewed_time'] as int,
    isLike: false,
    likedCount: answerData['liked_time'] as int,
    isFavor: false,
    favoredCount: answerData['favored_time'] as int,
    popularPoint: answerData['point'] as int,
    topicId: answerData['topic'] as String,
    createdUserId: answerData['created_user'] as String,
    createdAt: (answerData['created_at'] as Timestamp).toDate(),
  );
}

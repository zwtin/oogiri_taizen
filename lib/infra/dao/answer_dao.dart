import 'package:cloud_firestore/cloud_firestore.dart';

class AnswerDAO {
  AnswerDAO({
    required this.id,
    required this.text,
    required this.viewedCount,
    required this.likedCount,
    required this.favoredCount,
    required this.popularPoint,
    required this.topicId,
    required this.createdUserId,
    required this.createdAt,
  });

  factory AnswerDAO.fromMap(Map<String, dynamic> map) {
    return AnswerDAO(
      id: map['id'] as String,
      text: map['text'] as String,
      viewedCount: map['viewed_count'] as int,
      likedCount: map['liked_count'] as int,
      favoredCount: map['favored_count'] as int,
      popularPoint: map['popular_point'] as int,
      topicId: map['topic_id'] as String,
      createdUserId: map['created_user_id'] as String,
      createdAt: (map['created_at'] as Timestamp).toDate(),
    );
  }

  String id;
  String text;
  int viewedCount;
  int likedCount;
  int favoredCount;
  int popularPoint;
  String topicId;
  String createdUserId;
  DateTime createdAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'viewed_count': viewedCount,
      'liked_count': likedCount,
      'favored_count': favoredCount,
      'popular_point': popularPoint,
      'topic_id': topicId,
      'created_user_id': createdUserId,
      'updated_at': Timestamp.fromDate(createdAt),
    };
  }
}

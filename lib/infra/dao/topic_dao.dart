import 'package:cloud_firestore/cloud_firestore.dart';

class TopicDAO {
  TopicDAO({
    required this.id,
    required this.text,
    this.imageUrl,
    required this.answeredCount,
    required this.createdUserId,
    required this.createdAt,
  });

  factory TopicDAO.fromMap(Map<String, dynamic> map) {
    return TopicDAO(
      id: map['id'] as String,
      text: map['text'] as String,
      imageUrl: map['image_url'] as String,
      answeredCount: map['answered_count'] as int,
      createdUserId: map['created_user_id'] as String,
      createdAt: (map['created_at'] as Timestamp).toDate(),
    );
  }

  String id;
  String text;
  String? imageUrl;
  int answeredCount;
  String createdUserId;
  DateTime createdAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'image_url': imageUrl,
      'answered_count': answeredCount,
      'created_user_id': createdUserId,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }
}

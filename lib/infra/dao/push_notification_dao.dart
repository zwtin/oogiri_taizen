import 'package:cloud_firestore/cloud_firestore.dart';

class PushNotificationDAO {
  PushNotificationDAO({
    required this.id,
    required this.whenLiked,
    required this.whenFavored,
    required this.updatedAt,
  });

  factory PushNotificationDAO.fromMap(Map<String, dynamic> map) {
    return PushNotificationDAO(
      id: map['id'] as String,
      whenLiked: map['when_liked'] as bool,
      whenFavored: map['when_favored'] as bool,
      updatedAt: (map['updated_at'] as Timestamp).toDate(),
    );
  }

  String id;
  bool whenLiked;
  bool whenFavored;
  DateTime updatedAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'when_liked': whenLiked,
      'when_favored': whenFavored,
      'updated_at': Timestamp.fromDate(updatedAt),
    };
  }
}

import 'package:oogiritaizen/model/entity/topic_entity.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';

class AnswerEntity {
  String id;
  String text;
  int viewedTime;
  bool isLike;
  int likedTime;
  bool isFavor;
  int favoredTime;
  int point;
  DateTime createdAt;
  TopicEntity topic;
  UserEntity createdUser;
}

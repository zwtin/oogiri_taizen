import 'dart:async';

import 'package:oogiritaizen/model/entity/is_favor_entity.dart';
import 'package:oogiritaizen/model/entity/is_like_entity.dart';
import 'package:oogiritaizen/model/entity/topic_entity.dart';
import 'package:oogiritaizen/model/entity/user_entity.dart';

class AnswerEntity {
  String id;
  String text;
  int viewedTime;
  StreamSubscription<IsLikeEntity> likeSubscription;
  IsLikeEntity isLike;
  int likedTime;
  StreamSubscription<IsFavorEntity> favorSubscription;
  IsFavorEntity isFavor;
  int favoredTime;
  int point;
  DateTime createdAt;
  TopicEntity topic;
  UserEntity createdUser;
}

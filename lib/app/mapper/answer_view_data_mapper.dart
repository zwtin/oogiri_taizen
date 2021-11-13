import 'package:oogiri_taizen/app/mapper/topic_view_data_mapper.dart';
import 'package:oogiri_taizen/app/mapper/user_view_data_mapper.dart';
import 'package:oogiri_taizen/app/view_data/answer_view_data.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';

class AnswerViewDataMapper {
  static AnswerViewData convertToViewData({required Answer answer}) {
    final topicViewData =
        TopicViewDataMapper.convertToViewData(topic: answer.topic);
    final userViewData =
        UserViewDataMapper.convertToViewData(user: answer.createdUser);
    final answerViewData = AnswerViewData(
      id: answer.id,
      text: answer.text,
      viewedTime: answer.viewedTime,
      likedTime: answer.likedTime,
      isLike: answer.isLike,
      favoredTime: answer.favoredTime,
      isFavor: answer.isFavor,
      point: answer.point,
      createdAt: answer.createdAt,
      topic: topicViewData,
      createdUser: userViewData,
      isOwn: answer.isOwn,
    );
    return answerViewData;
  }

  static Answer convertToEntity({required AnswerViewData answerViewData}) {
    final topic = TopicViewDataMapper.convertToEntity(
      topicViewData: answerViewData.topic,
    );
    final user = UserViewDataMapper.convertToEntity(
      userViewData: answerViewData.createdUser,
    );
    final answer = Answer(
      id: answerViewData.id,
      text: answerViewData.text,
      viewedTime: answerViewData.viewedTime,
      isLike: answerViewData.isLike,
      likedTime: answerViewData.likedTime,
      isFavor: answerViewData.isFavor,
      favoredTime: answerViewData.favoredTime,
      point: answerViewData.point,
      createdAt: answerViewData.createdAt,
      topic: topic,
      createdUser: user,
      isOwn: answerViewData.isOwn,
    );
    return answer;
  }
}

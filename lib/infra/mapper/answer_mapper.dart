import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/topic.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/infra/dao/answer_dao.dart';

class AnswerMapper {
  AnswerMapper._() {
    throw AssertionError('private Constructor');
  }

  static Answer mappingFromDAO({
    required AnswerDAO answerDAO,
    required User createdUser,
    required Topic topic,
    required bool isLike,
    required bool isFavor,
  }) {
    return Answer(
      id: answerDAO.id,
      text: answerDAO.text,
      viewedCount: answerDAO.viewedCount,
      isLike: isLike,
      likedCount: answerDAO.likedCount,
      isFavor: isFavor,
      favoredCount: answerDAO.favoredCount,
      popularPoint: answerDAO.popularPoint,
      topic: topic,
      createdUser: createdUser,
      createdAt: answerDAO.createdAt,
    );
  }

  static AnswerDAO mappingToDAO({
    required Answer answer,
  }) {
    return AnswerDAO(
      id: answer.id,
      text: answer.text,
      viewedCount: answer.viewedCount,
      likedCount: answer.likedCount,
      favoredCount: answer.favoredCount,
      popularPoint: answer.popularPoint,
      topicId: answer.topic.id,
      createdUserId: answer.createdUser.id,
      createdAt: answer.createdAt,
    );
  }
}

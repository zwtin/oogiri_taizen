import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';

part 'user.freezed.dart';

@freezed
abstract class User implements _$User {
  const factory User({
    required String id,
    required String name,
    required String? imageUrl,
    required String introduction,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<UserCreateTopic> createTopics,
    required List<UserCreateAnswer> createAnswers,
    required List<UserLikeAnswer> likeAnswers,
    required List<UserFavorAnswer> favorAnswers,
  }) = _User;
  const User._();

  Result<void> like({required Answer answer}) {
    if (answer.userId == id) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: '自分のボケはイイね！できません',
        ),
      );
    }

    if (likeAnswers.map((e) => e.id).contains(answer.id)) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'イイね！に失敗しました',
        ),
      );
    }

    final likeAnswer = UserLikeAnswer(
      id: answer.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    likeAnswers.add(likeAnswer);

    if (!answer.likedUsers.map((e) => e.id).contains(id)) {
      final likedUser = AnswerLikedUser(
        id: id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      answer.likedUsers.add(likedUser);
    }

    return const Result.success(null);
  }

  Result<void> unlike({required Answer answer}) {
    if (!likeAnswers.map((e) => e.id).contains(answer.id)) {
      return Result.failure(
        OTException(
          title: 'エラー',
          text: 'イイね！の解除に失敗しました',
        ),
      );
    }
    likeAnswers.removeWhere((element) => element.id == answer.id);

    if (answer.likedUsers.map((e) => e.id).contains(id)) {
      answer.likedUsers.removeWhere((element) => element.id == id);
    }

    return const Result.success(null);
  }
}

@freezed
abstract class UserCreateTopic implements _$UserCreateTopic {
  const factory UserCreateTopic({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserCreateTopic;
  const UserCreateTopic._();
}

@freezed
abstract class UserCreateAnswer implements _$UserCreateAnswer {
  const factory UserCreateAnswer({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserCreateAnswer;
  const UserCreateAnswer._();
}

@freezed
abstract class UserLikeAnswer implements _$UserLikeAnswer {
  const factory UserLikeAnswer({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserLikeAnswer;
  const UserLikeAnswer._();
}

@freezed
abstract class UserFavorAnswer implements _$UserFavorAnswer {
  const factory UserFavorAnswer({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserFavorAnswer;
  const UserFavorAnswer._();
}

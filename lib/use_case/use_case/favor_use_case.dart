import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/entity/answer.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
import 'package:oogiri_taizen/domain/entity/user.dart';
import 'package:oogiri_taizen/domain/repository/answer_repository.dart';
import 'package:oogiri_taizen/domain/repository/authentication_repository.dart';
import 'package:oogiri_taizen/domain/repository/user_repository.dart';
import 'package:oogiri_taizen/infra/repository_impl/answer_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/authentication_repository_impl.dart';
import 'package:oogiri_taizen/infra/repository_impl/user_repository_impl.dart';

final favorUseCaseProvider = Provider.autoDispose<FavorUseCase>(
  (ref) {
    final favorUseCase = FavorUseCase(
      ref.watch(authenticationRepositoryProvider),
      ref.watch(answerRepositoryProvider),
      ref.watch(userRepositoryProvider),
    );
    ref.onDispose(favorUseCase.dispose);
    return favorUseCase;
  },
);

class FavorUseCase {
  FavorUseCase(
    this._authenticationRepository,
    this._answerRepository,
    this._userRepository,
  );

  final AuthenticationRepository _authenticationRepository;
  final AnswerRepository _answerRepository;
  final UserRepository _userRepository;

  final _logger = Logger();

  Future<Result<void>> favor({required String answerId}) async {
    final getLoginUserIdResult =
        await _authenticationRepository.getLoginUserId();
    if (getLoginUserIdResult is Failure) {
      return Result<void>.failure(
        OTException(
          title: 'エラー',
          text: 'ログイン情報の取得に失敗しました',
        ),
      );
    }
    final loginUserId = (getLoginUserIdResult as Success<String?>).value;
    if (loginUserId == null) {
      return Result<void>.failure(
        OTException(
          title: 'エラー',
          text: 'ログインが必要です',
        ),
      );
    }
    final getUserResult = await _userRepository.get(id: loginUserId);
    if (getUserResult is Failure) {
      return Result<void>.failure(
        OTException(
          title: 'エラー',
          text: 'ログイン情報の取得に失敗しました',
        ),
      );
    }
    final user = (getUserResult as Success<User>).value;

    final getAnswerResult = await _answerRepository.get(id: answerId);
    if (getAnswerResult is Failure) {
      return Result<void>.failure(
        OTException(
          title: 'エラー',
          text: 'ボケ情報の取得に失敗しました',
        ),
      );
    }
    final answer = (getAnswerResult as Success<Answer>).value;

    final result = user.favor(answer: answer);
    if (result is Failure) {
      return Result<void>.failure(result.exception);
    }

    final userUpdateResult = await _userRepository.update(user: user);
    if (userUpdateResult is Failure) {
      return Result<void>.failure(
        OTException(
          title: 'エラー',
          text: 'ユーザー情報の更新に失敗しました',
        ),
      );
    }

    final answerUpdateResult = await _answerRepository.update(answer: answer);
    if (answerUpdateResult is Failure) {
      return Result<void>.failure(
        OTException(
          title: 'エラー',
          text: 'ボケ情報の更新に失敗しました',
        ),
      );
    }

    return const Result.success(null);
  }

  Future<Result<void>> unfavor({required String answerId}) async {
    final getLoginUserIdResult =
        await _authenticationRepository.getLoginUserId();
    if (getLoginUserIdResult is Failure) {
      return Result<void>.failure(
        OTException(
          title: 'エラー',
          text: 'ログイン情報の取得に失敗しました',
        ),
      );
    }
    final loginUserId = (getLoginUserIdResult as Success<String?>).value;
    if (loginUserId == null) {
      return Result<void>.failure(
        OTException(
          title: 'エラー',
          text: 'ログインが必要です',
        ),
      );
    }
    final getUserResult = await _userRepository.get(id: loginUserId);
    if (getUserResult is Failure) {
      return Result<void>.failure(
        OTException(
          title: 'エラー',
          text: 'ログイン情報の取得に失敗しました',
        ),
      );
    }
    final user = (getUserResult as Success<User>).value;

    final getAnswerResult = await _answerRepository.get(id: answerId);
    if (getAnswerResult is Failure) {
      return Result<void>.failure(
        OTException(
          title: 'エラー',
          text: 'ボケ情報の取得に失敗しました',
        ),
      );
    }
    final answer = (getAnswerResult as Success<Answer>).value;

    final result = user.unfavor(answer: answer);
    if (result is Failure) {
      return Result<void>.failure(result.exception);
    }

    final userUpdateResult = await _userRepository.update(user: user);
    if (userUpdateResult is Failure) {
      return Result<void>.failure(
        OTException(
          title: 'エラー',
          text: 'ユーザー情報の更新に失敗しました',
        ),
      );
    }

    final answerUpdateResult = await _answerRepository.update(answer: answer);
    if (answerUpdateResult is Failure) {
      return Result<void>.failure(
        OTException(
          title: 'エラー',
          text: 'ボケ情報の更新に失敗しました',
        ),
      );
    }

    return const Result.success(null);
  }

  void dispose() {
    _logger.d('FavorUseCase dispose');
  }
}

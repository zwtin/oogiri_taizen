import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/mapper/answer_list_card_view_data_mapper.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view/answer_detail_view.dart';
import 'package:oogiri_taizen/app/view_data/answer_list_card_view_data.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/block_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/favor_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/like_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/popular_answer_list_use_case.dart';

final popularAnswerListViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<PopularAnswerListViewModel, UniqueKey>(
  (ref, key) {
    return PopularAnswerListViewModel(
      key,
      ref.read,
      ref.watch(popularAnswerListUseCaseProvider(key)),
      ref.watch(blockUseCaseProvider(key)),
      ref.watch(favorUseCaseProvider(key)),
      ref.watch(likeUseCaseProvider(key)),
    );
  },
);

class PopularAnswerListViewModel extends ChangeNotifier {
  PopularAnswerListViewModel(
    this._key,
    this._reader,
    this._popularAnswerListUseCase,
    this._blockUseCase,
    this._favorUseCase,
    this._likeUseCase,
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  final PopularAnswerListUseCase _popularAnswerListUseCase;
  final BlockUseCase _blockUseCase;
  final FavorUseCase _favorUseCase;
  final LikeUseCase _likeUseCase;

  List<AnswerListCardViewData> get answerViewData {
    return mappingForAnswerListCardViewData(
      answers: _popularAnswerListUseCase.showingAnswers,
    );
  }

  bool get hasNext {
    return _popularAnswerListUseCase.hasNext;
  }

  String? get loginUserId {
    return _popularAnswerListUseCase.loginUserId;
  }

  Future<void> resetAnswers() async {
    final result = await _popularAnswerListUseCase.resetAnswers();
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          }
        }
      },
    );
  }

  Future<void> fetchAnswers() async {
    final result = await _popularAnswerListUseCase.fetchAnswers();
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          }
        }
      },
    );
  }

  Future<void> addBlockAnswer({required String answerId}) async {
    final answer = _popularAnswerListUseCase.showingAnswers.getById(answerId);
    if (answer == null) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: 'ボケが見つかりませんでした',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
            },
            cancelButtonAction: null,
          );
      return;
    }
    final result = await _blockUseCase.addAnswer(answer: answer);
    result.when(
      success: (_) {
        _reader.call(alertNotiferProvider).show(
              title: '完了',
              message: 'ボケをブロックしました',
              okButtonTitle: 'OK',
              cancelButtonTitle: null,
              okButtonAction: () {
                _reader.call(alertNotiferProvider).dismiss();
              },
              cancelButtonAction: null,
            );
      },
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          }
        }
      },
    );
  }

  Future<void> addBlockUser({required String answerId}) async {
    final answer = _popularAnswerListUseCase.showingAnswers.getById(answerId);
    final user = answer?.createdUser;
    if (user == null) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: 'ユーザーが見つかりませんでした',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
            },
            cancelButtonAction: null,
          );
      return;
    }
    final result = await _blockUseCase.addUser(user: user);
    result.when(
      success: (_) {
        _reader.call(alertNotiferProvider).show(
              title: '完了',
              message: 'ユーザーをブロックしました',
              okButtonTitle: 'OK',
              cancelButtonTitle: null,
              okButtonAction: () {
                _reader.call(alertNotiferProvider).dismiss();
              },
              cancelButtonAction: null,
            );
      },
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          }
        }
      },
    );
  }

  Future<void> likeAnswer({required String answerId}) async {
    final answer = _popularAnswerListUseCase.showingAnswers.getById(answerId);
    if (answer == null) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: 'ボケが見つかりませんでした',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
            },
            cancelButtonAction: null,
          );
      return;
    }
    final result = await _likeUseCase.like(answer: answer);
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          }
        }
      },
    );
  }

  Future<void> favorAnswer({required String answerId}) async {
    final answer = _popularAnswerListUseCase.showingAnswers.getById(answerId);
    if (answer == null) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: 'ボケが見つかりませんでした',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () {
              _reader.call(alertNotiferProvider).dismiss();
            },
            cancelButtonAction: null,
          );
      return;
    }
    final result = await _favorUseCase.favor(answer: answer);
    result.when(
      success: (_) {},
      failure: (exception) {
        if (exception is OTException) {
          final alertTitle = exception.title;
          final alertText = exception.text;
          if (alertTitle.isNotEmpty && alertText.isNotEmpty) {
            _reader.call(alertNotiferProvider).show(
                  title: alertTitle,
                  message: alertText,
                  okButtonTitle: 'OK',
                  cancelButtonTitle: null,
                  okButtonAction: () {
                    _reader.call(alertNotiferProvider).dismiss();
                  },
                  cancelButtonAction: null,
                );
          }
        }
      },
    );
  }

  Future<void> transitionToAnswerDetail({required String answerId}) async {
    await _reader.call(routerNotiferProvider(_key)).push(
          nextScreen: AnswerDetailView(
            answerId: answerId,
          ),
        );
  }

  Future<void> transitionToImageDetail({
    required String imageUrl,
    required String imageTag,
  }) async {
    if (imageUrl.isEmpty) {
      return;
    }
    await _reader.call(routerNotiferProvider(_key)).presentImage(
          imageUrl: imageUrl,
          imageTag: imageTag,
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('PopularAnswerListViewModel dispose $_key');
  }
}

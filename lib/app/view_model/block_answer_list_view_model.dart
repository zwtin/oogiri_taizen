import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/mapper/block_answer_list_card_view_data_mapper.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/view_data/block_answer_list_card_view_data.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/block_answer_list_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/block_use_case.dart';

final blockAnswerListViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<BlockAnswerListViewModel, UniqueKey>(
  (ref, key) {
    return BlockAnswerListViewModel(
      key,
      ref.read,
      ref.watch(blockAnswerListUseCaseProvider(key)),
      ref.watch(blockUseCaseProvider(key)),
    );
  },
);

class BlockAnswerListViewModel extends ChangeNotifier {
  BlockAnswerListViewModel(
    this._key,
    this._reader,
    this._blockAnswerListUseCase,
    this._blockUseCase,
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  final BlockAnswerListUseCase _blockAnswerListUseCase;
  final BlockUseCase _blockUseCase;

  List<BlockAnswerListCardViewData> get answerViewData {
    return mappingForBlockAnswerListCardViewData(
      answers: _blockAnswerListUseCase.loadedAnswers,
    );
  }

  bool get hasNext {
    return _blockAnswerListUseCase.hasNext;
  }

  Future<void> resetAnswers() async {
    final result = await _blockAnswerListUseCase.resetBlockAnswers();
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
    final result = await _blockAnswerListUseCase.fetchBlockAnswers();
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

  Future<void> removeBlockAnswer({required String answerId}) async {
    final answer = _blockAnswerListUseCase.loadedAnswers.getById(answerId);
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
    final result = await _blockUseCase.removeAnswer(answer: answer);
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

  @override
  void dispose() {
    super.dispose();
    _logger.d('BlockAnswerListViewModel dispose $_key');
  }
}

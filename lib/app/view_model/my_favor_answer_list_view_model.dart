import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/mapper/answer_list_card_view_data_mapper.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/view_data/answer_list_card_view_data.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/my_favor_answer_list_use_case.dart';

final myFavorAnswerListViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<MyFavorAnswerListViewModel, UniqueKey>(
  (ref, key) {
    return MyFavorAnswerListViewModel(
      key,
      ref.read,
      ref.watch(myFavorAnswerListUseCaseProvider(key)),
    );
  },
);

class MyFavorAnswerListViewModel extends ChangeNotifier {
  MyFavorAnswerListViewModel(
    this._key,
    this._reader,
    this._myFavorAnswerListUseCase,
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  final MyFavorAnswerListUseCase _myFavorAnswerListUseCase;

  List<AnswerListCardViewData> get answerViewData {
    return mappingForAnswerListCardViewData(
      answers: _myFavorAnswerListUseCase.showingAnswers,
    );
  }

  bool get hasNext {
    return _myFavorAnswerListUseCase.hasNext;
  }

  Future<void> resetAnswers() async {
    final result = await _myFavorAnswerListUseCase.resetAnswers();
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
    final result = await _myFavorAnswerListUseCase.fetchAnswers();
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
    _logger.d('MyFavorAnswerListViewModel dispose $_key');
  }
}

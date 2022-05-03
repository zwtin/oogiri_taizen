import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/mapper/answer_list_card_view_data_mapper.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/view_data/answer_list_card_view_data.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/user_favor_answer_list_use_case.dart';
import 'package:tuple/tuple.dart';

final userFavorAnswerListViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<UserFavorAnswerListViewModel, Tuple2<UniqueKey, String>>(
  (ref, tuple) {
    return UserFavorAnswerListViewModel(
      tuple.item1,
      tuple.item2,
      ref.read,
      ref.watch(userFavorAnswerListUseCaseProvider(tuple)),
    );
  },
);

class UserFavorAnswerListViewModel extends ChangeNotifier {
  UserFavorAnswerListViewModel(
    this._key,
    this._userId,
    this._reader,
    this._userFavorAnswerListUseCase,
  );

  final UniqueKey _key;
  final String _userId;
  final Reader _reader;
  final _logger = Logger();

  final UserFavorAnswerListUseCase _userFavorAnswerListUseCase;

  List<AnswerListCardViewData> get answerViewData {
    return mappingForAnswerListCardViewData(
      answers: _userFavorAnswerListUseCase.showingAnswers,
    );
  }

  bool get hasNext {
    return _userFavorAnswerListUseCase.hasNext;
  }

  Future<void> resetAnswers() async {
    final result = await _userFavorAnswerListUseCase.resetAnswers();
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
    final result = await _userFavorAnswerListUseCase.fetchAnswers();
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
    _logger.d('UserFavorAnswerListViewModel dispose $_key');
  }
}

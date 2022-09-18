import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/mapper/answer_list_card_view_data_mapper.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view_data/answer_list_card_view_data.dart';
import 'package:oogiri_taizen/domain/entity/ot_exception.dart';
import 'package:oogiri_taizen/domain/use_case/my_create_answer_list_use_case.dart';

final myCreateAnswerListViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<MyCreateAnswerListViewModel, UniqueKey>(
  (ref, key) {
    return MyCreateAnswerListViewModel(
      key,
      ref.read,
      ref.watch(myCreateAnswerListUseCaseProvider(key)),
    );
  },
);

class MyCreateAnswerListViewModel extends ChangeNotifier {
  MyCreateAnswerListViewModel(
    this._key,
    this._reader,
    this._myCreateAnswerListUseCase,
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  final MyCreateAnswerListUseCase _myCreateAnswerListUseCase;

  List<AnswerListCardViewData> get answerViewData {
    return mappingForAnswerListCardViewData(
      answers: _myCreateAnswerListUseCase.showingAnswers,
    );
  }

  bool get hasNext {
    return _myCreateAnswerListUseCase.hasNext;
  }

  Future<void> resetAnswers() async {
    final result = await _myCreateAnswerListUseCase.resetAnswers();
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
    final result = await _myCreateAnswerListUseCase.fetchAnswers();
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
    _logger.d('MyCreateAnswerListViewModel dispose $_key');
  }
}

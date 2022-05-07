import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final answerListViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<AnswerListViewModel, UniqueKey>(
  (ref, key) {
    return AnswerListViewModel(
      key,
      ref.read,
    );
  },
);

class AnswerListViewModel extends ChangeNotifier {
  AnswerListViewModel(
    this._key,
    this._reader,
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  @override
  void dispose() {
    super.dispose();
    _logger.d('AnswerListViewModel dispose $_key');
  }
}

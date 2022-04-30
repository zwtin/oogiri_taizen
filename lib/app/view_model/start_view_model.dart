import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/use_case/start_use_case.dart';

final startViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<StartViewModel, UniqueKey>(
  (ref, key) {
    return StartViewModel(
      key,
      ref.read,
      ref.watch(startUseCaseProvider(key)),
    );
  },
);

class StartViewModel extends ChangeNotifier {
  StartViewModel(
    this._key,
    this._reader,
    this._startUseCase,
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  final StartUseCase _startUseCase;

  @override
  void dispose() {
    super.dispose();
    _logger.d('StartViewModel dispose $_key');
  }
}

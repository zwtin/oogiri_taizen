import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final startViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<StartViewModel, UniqueKey>(
  (ref, key) {
    final startViewModel = StartViewModel(
      key,
      ref.read,
    );
    ref.onDispose(startViewModel.disposed);
    return startViewModel;
  },
);

class StartViewModel extends ChangeNotifier {
  StartViewModel(
    this._key,
    this._reader,
  );

  final UniqueKey _key;
  final Reader _reader;

  Future<void> disposed() async {
    debugPrint('StartViewModel disposed $_key');
  }
}

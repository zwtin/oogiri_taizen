import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

final blockListViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<BlockListViewModel, UniqueKey>(
  (ref, key) {
    return BlockListViewModel(
      key,
      ref.read,
    );
  },
);

class BlockListViewModel extends ChangeNotifier {
  BlockListViewModel(
    this._key,
    this._reader,
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  @override
  void dispose() {
    super.dispose();
    _logger.d('BlockListViewModel dispose $_key');
  }
}

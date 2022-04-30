import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';

final temporaryRegisterCompleteViewModelProvider = ChangeNotifierProvider
    .autoDispose
    .family<TemporaryRegisterCompleteViewModel, UniqueKey>(
  (ref, key) {
    return TemporaryRegisterCompleteViewModel(
      key,
      ref.read,
    );
  },
);

class TemporaryRegisterCompleteViewModel extends ChangeNotifier {
  TemporaryRegisterCompleteViewModel(
    this._key,
    this._reader,
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  void popToRoot() {
    _reader.call(routerNotiferProvider(_key)).popToRoot();
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('TemporaryRegisterCompleteViewModel dispose $_key');
  }
}

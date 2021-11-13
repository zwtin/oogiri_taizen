import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiri_taizen/app/notifer/router_notifer.dart';

final temporaryRegisterCompleteViewModelProvider = ChangeNotifierProvider
    .autoDispose
    .family<TemporaryRegisterCompleteViewModel, UniqueKey>(
  (ref, key) {
    final temporaryRegisterCompleteViewModel =
        TemporaryRegisterCompleteViewModel(
      key,
      ref.read,
    );
    ref.onDispose(temporaryRegisterCompleteViewModel.disposed);
    return temporaryRegisterCompleteViewModel;
  },
);

class TemporaryRegisterCompleteViewModel extends ChangeNotifier {
  TemporaryRegisterCompleteViewModel(
    this._key,
    this._reader,
  );

  final UniqueKey _key;
  final Reader _reader;

  void popToRoot() {
    _reader.call(routerNotiferProvider(_key)).popToRoot();
  }

  Future<void> disposed() async {
    debugPrint('TemporaryRegisterCompleteViewModel disposed $_key');
  }
}

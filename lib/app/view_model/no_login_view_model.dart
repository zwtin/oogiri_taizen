import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view/setting_view.dart';
import 'package:oogiri_taizen/app/view/sign_in_view.dart';
import 'package:oogiri_taizen/app/view/sign_up_view.dart';

final noLoginViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<NoLoginViewModel, UniqueKey>(
  (ref, key) {
    return NoLoginViewModel(
      key,
      ref.read,
    );
  },
);

class NoLoginViewModel extends ChangeNotifier {
  NoLoginViewModel(
    this._key,
    this._reader,
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  Future<void> transitionToSetting() async {
    await _reader.call(routerNotiferProvider(_key)).present(
          nextScreen: SettingView(),
        );
  }

  Future<void> transitionToSignIn() async {
    await _reader.call(routerNotiferProvider(_key)).present(
          nextScreen: SignInView(),
        );
  }

  Future<void> transitionToSignUp() async {
    await _reader.call(routerNotiferProvider(_key)).present(
          nextScreen: SignUpView(),
        );
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('NoLoginViewModel dispose $_key');
  }
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/domain/use_case/my_page_use_case.dart';

final myPageViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<MyPageViewModel, UniqueKey>(
  (ref, key) {
    return MyPageViewModel(
      key,
      ref.read,
      ref.watch(myPageUseCaseProvider(key)),
    );
  },
);

class MyPageViewModel extends ChangeNotifier {
  MyPageViewModel(
    this._key,
    this._reader,
    this._myPageUseCase,
  );

  final UniqueKey _key;
  final Reader _reader;
  final _logger = Logger();

  final MyPageUseCase _myPageUseCase;

  bool get isLogin {
    return _myPageUseCase.isLogin;
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('MyPageViewModel dispose $_key');
  }
}

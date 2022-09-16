import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view/bottom_tab_view.dart';
import 'package:oogiri_taizen/domain/entity/result.dart';
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

  Future<void> checkNeedUpdate() async {
    final needUpdateResult = await _startUseCase.getNeedUpdate();
    if (needUpdateResult is Failure) {
      _reader.call(alertNotiferProvider).show(
            title: 'エラー',
            message: 'アプリバージョンの取得に失敗しました',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () async {
              _reader.call(alertNotiferProvider).dismiss();
              await checkNeedUpdate();
            },
            cancelButtonAction: null,
          );
    }
    final needUpdate = (needUpdateResult as Success<bool>).value;
    if (needUpdate) {
      _reader.call(alertNotiferProvider).show(
            title: 'バージョンエラー',
            message: '最新バージョンのアプリをお使いください',
            okButtonTitle: 'OK',
            cancelButtonTitle: null,
            okButtonAction: () async {
              await SystemNavigator.pop();
            },
            cancelButtonAction: null,
          );
    } else {
      await _reader
          .call(routerNotiferProvider(_key))
          .pushReplacement(nextScreen: BottomTabView());
    }
  }

  @override
  void dispose() {
    super.dispose();
    _logger.d('StartViewModel dispose $_key');
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/notifer/alert_notifer.dart';
import 'package:oogiri_taizen/app/view/bottom_tab_view.dart';
import 'package:oogiri_taizen/app/view/start_view.dart';
import 'package:oogiri_taizen/domain/use_case/force_update_use_case.dart';
import 'package:oogiri_taizen/domain/use_case/force_update_use_case_impl.dart';

final appViewModelProvider = ChangeNotifierProvider.autoDispose<AppViewModel>(
  (ref) {
    final appViewModel = AppViewModel(
      ref.read,
      ref.watch(forceUpdateUseCaseProvider),
    );
    ref.onDispose(appViewModel.disposed);
    return appViewModel;
  },
);

class AppViewModel extends ChangeNotifier {
  AppViewModel(
    this._reader,
    this._forceUpdateUseCase,
  ) {
    final needUpdate = _forceUpdateUseCase.getNeedUpdate();
    if (needUpdate) {
      Future<void>.delayed(const Duration(milliseconds: 100))
          .then((_) => _reader.call(alertNotiferProvider).show(
                title: 'バージョンエラー',
                message: '最新バージョンのアプリをお使いください',
                okButtonTitle: 'OK',
                cancelButtonTitle: null,
                okButtonAction: () async {
                  await SystemNavigator.pop();
                },
                cancelButtonAction: null,
              ));
    } else {
      homeView = useMemoized(() => BottomTabView());
      notifyListeners();
    }
  }

  final Reader _reader;
  final ForceUpdateUseCase _forceUpdateUseCase;

  Widget homeView = useMemoized(() => StartView());

  Future<void> disposed() async {
    debugPrint('AppViewModel disposed');
  }
}

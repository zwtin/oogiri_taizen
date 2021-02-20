import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/model/use_case/dynamic_links_use_case.dart';
import 'package:oogiritaizen/model/use_case_impl/dynamic_links_use_case_impl.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';

final bottomTabViewModelProvider =
    ChangeNotifierProvider.autoDispose<BottomTabViewModel>(
  (ref) {
    final bottomTabViewModel = BottomTabViewModel(
      ref,
      ref.watch(dynamicLinksUseCaseProvider('bottomTab')),
    );
    ref.onDispose(bottomTabViewModel.disposed);
    return bottomTabViewModel;
  },
);

class BottomTabViewModel extends ChangeNotifier {
  BottomTabViewModel(
    this.providerReference,
    this.dynamicLinksUseCase,
  ) {
    setup();
  }

  final ProviderReference providerReference;
  final DynamicLinksUseCase dynamicLinksUseCase;

  int selected = 0;

  Future<void> setup() async {
    await dynamicLinksUseCase.setupDynamicLinks();
    dynamicLinksUseCase.getDynamicLinksStream().listen((Uri uri) {
      final apiKey = uri.queryParameters['apiKey'];
      final mode = uri.queryParameters['mode'];
      final oobCode = uri.queryParameters['oobCode'];
      final continueUrl = uri.queryParameters['continueUrl'];
      final lang = uri.queryParameters['lang'];

      debugPrint('apiKey = $apiKey');
      debugPrint('mode = $mode');
      debugPrint('oobCode = $oobCode');
      debugPrint('continueUrl = $continueUrl');
      debugPrint('lang = $lang');
    });
    notifyListeners();
  }

  void tapped(int index) {
    if (selected == index) {
      switch (index) {
        case 0:
          providerReference
              .read(navigatorViewModelProvider('Tab0'))
              .popToRoot();
          break;
        case 1:
          providerReference
              .read(navigatorViewModelProvider('Tab0'))
              .popToRoot();
          break;
      }
    } else {
      selected = index;
      notifyListeners();
    }
  }

  void pop() {
    switch (selected) {
      case 0:
        providerReference.read(navigatorViewModelProvider('Tab0')).pop();
        break;
      case 1:
        providerReference.read(navigatorViewModelProvider('Tab1')).pop();
        break;
    }
  }

  Future<void> disposed() async {
    debugPrint('bottomTab');
  }
}

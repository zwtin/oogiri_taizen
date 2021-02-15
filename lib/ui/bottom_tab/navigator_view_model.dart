import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final navigatorViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<NavigatorViewModel, String>(
  (ref, id) {
    final navigatorViewModel = NavigatorViewModel(id);
    ref.onDispose(navigatorViewModel.disposed);
    return navigatorViewModel;
  },
);

class NavigatorViewModel extends ChangeNotifier {
  NavigatorViewModel(this.id);

  String id;

  Widget nextWidget;
  bool fullScreen;
  bool toRoot;

  void push(Widget nextWidget) {
    this.nextWidget = nextWidget;
    fullScreen = false;
    toRoot = false;
    notifyListeners();
  }

  void present(Widget nextWidget) {
    this.nextWidget = nextWidget;
    fullScreen = true;
    toRoot = false;
    notifyListeners();
  }

  void pop() {
    nextWidget = null;
    fullScreen = false;
    toRoot = false;
    notifyListeners();
  }

  void popToRoot() {
    nextWidget = null;
    fullScreen = false;
    toRoot = true;
    notifyListeners();
  }

  Future<void> disposed() async {
    debugPrint(id);
  }
}

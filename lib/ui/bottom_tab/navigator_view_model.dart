import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/ui/image_detail/image_detail_view.dart';

final navigatorViewModelProvider =
    ChangeNotifierProvider.autoDispose.family<NavigatorViewModel, String>(
  (ref, id) {
    final navigatorViewModel = NavigatorViewModel(id);
    ref.onDispose(navigatorViewModel.disposed);
    return navigatorViewModel;
  },
);

enum TransitionType {
  push,
  present,
  image,
  pop,
  popToRoot,
}

class NavigatorViewModel extends ChangeNotifier {
  NavigatorViewModel(this.id);

  String id;

  TransitionType transitionType;
  Widget nextWidget;

  void push(Widget nextWidget) {
    transitionType = TransitionType.push;
    this.nextWidget = nextWidget;
    notifyListeners();
  }

  void present(Widget nextWidget) {
    transitionType = TransitionType.present;
    this.nextWidget = nextWidget;
    notifyListeners();
  }

  void presentImage({
    @required String imageUrl,
    @required String imageTag,
  }) {
    transitionType = TransitionType.image;
    nextWidget = ImageDetailView(
      imageUrl: imageUrl,
      imageTag: imageTag,
    );
    notifyListeners();
  }

  void pop() {
    transitionType = TransitionType.pop;
    nextWidget = null;
    notifyListeners();
  }

  void popToRoot() {
    transitionType = TransitionType.popToRoot;
    nextWidget = null;
    notifyListeners();
  }

  Future<void> disposed() async {
    debugPrint(id);
  }
}

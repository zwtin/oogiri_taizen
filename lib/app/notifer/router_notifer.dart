import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiri_taizen/app/view/image_detail_view.dart';

final routerNotiferProvider =
    ChangeNotifierProvider.autoDispose.family<RouterNotifer, UniqueKey>(
  (ref, key) {
    return RouterNotifer(key);
  },
);

enum TransitionType {
  push,
  pushReplacement,
  present,
  image,
  pop,
  popToRoot,
}

class RouterNotifer extends ChangeNotifier {
  RouterNotifer(this._key);

  final UniqueKey _key;

  Widget? nextScreen;
  TransitionType transitionType = TransitionType.pop;

  Future<void> push({required Widget nextScreen}) async {
    transitionType = TransitionType.push;
    this.nextScreen = nextScreen;
    notifyListeners();
  }

  Future<void> pushReplacement({required Widget nextScreen}) async {
    transitionType = TransitionType.pushReplacement;
    this.nextScreen = nextScreen;
    notifyListeners();
  }

  Future<void> present({required Widget nextScreen}) async {
    transitionType = TransitionType.present;
    this.nextScreen = nextScreen;
    notifyListeners();
  }

  Future<void> presentImage({
    required String imageUrl,
    required String imageTag,
  }) async {
    transitionType = TransitionType.image;
    nextScreen = ImageDetailView(
      imageUrl: imageUrl,
      imageTag: imageTag,
    );
    notifyListeners();
  }

  void pop() {
    transitionType = TransitionType.pop;
    nextScreen = null;
    notifyListeners();
  }

  void popToRoot() {
    transitionType = TransitionType.popToRoot;
    nextScreen = null;
    notifyListeners();
  }
}

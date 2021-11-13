import 'package:flutter/material.dart';

import 'package:oogiri_taizen/app/view/image_detail_view.dart';

class FadeInRoute extends PageRouteBuilder<ImageDetailView> {
  FadeInRoute({
    required this.widget,
    this.opaque = true,
    required this.onTransitionCompleted,
    required this.onTransitionDismissed,
  }) : super(
          opaque: opaque,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            animation.addStatusListener((status) {
              if (status == AnimationStatus.completed &&
                  onTransitionCompleted != null) {
                onTransitionCompleted();
              } else if (status == AnimationStatus.dismissed &&
                  onTransitionDismissed != null) {
                onTransitionDismissed();
              }
            });

            return widget;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );

  final Widget widget;
  final bool opaque;
  final Function? onTransitionCompleted;
  final Function? onTransitionDismissed;
}

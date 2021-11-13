import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view_model/bottom_tab_view_model.dart';
import 'package:oogiri_taizen/app/widget/fade_in_route.dart';

class RouterWidget extends HookWidget {
  const RouterWidget({
    required this.child,
    required this.key,
  });

  final Widget child;
  final UniqueKey key;

  @override
  Widget build(BuildContext context) {
    useProvider(bottomTabViewModelProvider).currentKey = key;

    return ProviderListener(
      onChange: (BuildContext context, RouterNotifer routerNotifer) async {
        switch (routerNotifer.transitionType) {
          case TransitionType.push:
            await Navigator.of(context).push(
              MaterialPageRoute<Widget>(
                builder: (BuildContext context) {
                  if (routerNotifer.nextScreen == null) {
                    return Container();
                  } else {
                    return routerNotifer.nextScreen!;
                  }
                },
              ),
            );
            break;
          case TransitionType.pushReplacement:
            await Navigator.of(context).pushReplacement(
              MaterialPageRoute<Widget>(
                builder: (BuildContext context) {
                  if (routerNotifer.nextScreen == null) {
                    return Container();
                  } else {
                    return routerNotifer.nextScreen!;
                  }
                },
              ),
            );
            break;
          case TransitionType.present:
            await Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute<Widget>(
                builder: (BuildContext context) {
                  if (routerNotifer.nextScreen == null) {
                    return Container();
                  } else {
                    return routerNotifer.nextScreen!;
                  }
                },
                fullscreenDialog: true,
              ),
            );
            break;
          case TransitionType.image:
            await Navigator.of(context, rootNavigator: true).push(
              FadeInRoute(
                widget: routerNotifer.nextScreen!,
                opaque: false,
                onTransitionCompleted: null,
                onTransitionDismissed: null,
              ),
            );
            break;
          case TransitionType.pop:
            Navigator.of(context).pop();
            break;
          case TransitionType.popToRoot:
            Navigator.of(context).popUntil((route) => route.isFirst);
            break;
        }
      },
      provider: routerNotiferProvider(key),
      child: child,
    );
  }
}

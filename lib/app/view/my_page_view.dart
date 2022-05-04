import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view/my_profile_view.dart';
import 'package:oogiri_taizen/app/view/no_login_view.dart';
import 'package:oogiri_taizen/app/view_model/bottom_tab_view_model.dart';
import 'package:oogiri_taizen/app/view_model/my_page_view_model.dart';
import 'package:oogiri_taizen/app/widget/fade_in_route.dart';

class MyPageView extends HookWidget {
  final _key = UniqueKey();
  final _logger = Logger();

  @override
  Widget build(BuildContext context) {
    _logger.d('MyPageView = $_key');

    // bottomTabにGlobalKeyをセット
    useProvider(bottomTabViewModelProvider).setUniqueKey(index: 1, key: _key);
    final viewModel = useProvider(myPageViewModelProvider(_key));

    // 戻るボタンのアクションを変えたいので、RouterWidgetを使わない
    return ProviderListener(
      onChange: (BuildContext context, RouterNotifer routerNotifer) {
        switch (routerNotifer.transitionType) {
          case TransitionType.push:
            Navigator.of(context).push(
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
            Navigator.of(context).pushReplacement(
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
            Navigator.of(context, rootNavigator: true).push(
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
            Navigator.of(context, rootNavigator: true).push(
              FadeInRoute(
                widget: routerNotifer.nextScreen!,
                opaque: false,
                onTransitionCompleted: null,
                onTransitionDismissed: null,
              ),
            );
            break;
          case TransitionType.pop:
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.read(bottomTabViewModelProvider).tapped(0);
            }
            break;
          case TransitionType.popToRoot:
            Navigator.of(context).popUntil((route) => route.isFirst);
            break;
        }
      },
      provider: routerNotiferProvider(_key),
      child: viewModel.isLogin ? MyProfileView() : NoLoginView(),
    );
  }
}

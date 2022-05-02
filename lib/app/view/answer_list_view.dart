import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/view/new_answer_list_view.dart';
import 'package:oogiri_taizen/app/view/popular_answer_list_view.dart';
import 'package:oogiri_taizen/app/view_model/answer_list_view_model.dart';
import 'package:oogiri_taizen/app/view_model/bottom_tab_view_model.dart';
import 'package:oogiri_taizen/app/widget/fade_in_route.dart';
import 'package:oogiri_taizen/app/widget/floating_action_button_widget.dart';

class AnswerListView extends HookWidget {
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    debugPrint('AnswerListView = $_key');

    // bottomTabにGlobalKeyをセット
    useProvider(bottomTabViewModelProvider).setUniqueKey(index: 0, key: _key);
    final viewModel = useProvider(answerListViewModelProvider(_key));

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
              SystemNavigator.pop();
            }
            break;
          case TransitionType.popToRoot:
            Navigator.of(context).popUntil((route) => route.isFirst);
            break;
        }
      },
      provider: routerNotiferProvider(_key),
      child: FloatingActionButtonWidget(
        action1: () {},
        action2: () {},
        // action3: () {},
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'ホーム',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color(0xFFFFCC00),
              elevation: 0, // 影をなくす
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    text: '新着順',
                  ),
                  Tab(
                    text: '人気順',
                  )
                ],
              ),
            ),
            body: Stack(
              children: [
                Container(
                  color: const Color(0xFFFFCC00),
                ),
                TabBarView(
                  children: [
                    NewAnswerListView(),
                    PopularAnswerListView(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

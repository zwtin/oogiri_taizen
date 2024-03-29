import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/view/answer_list_view.dart';
import 'package:oogiri_taizen/app/view/my_page_view.dart';
import 'package:oogiri_taizen/app/view_model/bottom_tab_view_model.dart';
import 'package:oogiri_taizen/app/widget/alert_widget.dart';
import 'package:oogiri_taizen/app/widget/dynamic_links_widget.dart';

class BottomTabView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(bottomTabViewModelProvider);
    final tab0 = useMemoized(
      () {
        return Navigator(
          onGenerateRoute: (settings) {
            return PageRouteBuilder<Widget>(
              pageBuilder: (
                context,
                animation1,
                animation2,
              ) {
                return AnswerListView();
              },
            );
          },
        );
      },
    );
    final tab1 = useMemoized(
      () {
        return Navigator(
          onGenerateRoute: (settings) {
            return PageRouteBuilder<Widget>(
              pageBuilder: (
                context,
                animation1,
                animation2,
              ) {
                return MyPageView();
              },
            );
          },
        );
      },
    );

    final controller = useTabController(initialLength: 2)
      ..index = viewModel.selected;

    return AlertWidget(
      child: DynamicLinksWidget(
        onCalled: viewModel.openWithDynamicLinks,
        child: WillPopScope(
          onWillPop: () async {
            context.read(bottomTabViewModelProvider).pop();
            return false;
          },
          child: Scaffold(
            bottomNavigationBar: ConvexAppBar(
              backgroundColor: Colors.black87,
              activeColor: const Color(0xFFFFCC00),
              controller: controller,
              initialActiveIndex: viewModel.selected,
              onTap: context.read(bottomTabViewModelProvider).tapped,
              items: const [
                TabItem<IconData>(
                  icon: Icons.home,
                  title: 'ホーム',
                ),
                TabItem<IconData>(
                  icon: Icons.person,
                  title: 'マイページ',
                ),
              ],
            ),
            body: IndexedStack(
              index: viewModel.selected,
              children: <Widget>[
                tab0,
                tab1,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

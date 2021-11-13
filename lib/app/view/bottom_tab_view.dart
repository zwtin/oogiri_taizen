import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/widget/alert_widget.dart';

import 'package:oogiri_taizen/app/view/answer_list_view.dart';
import 'package:oogiri_taizen/app/view/my_profile_view.dart';
import 'package:oogiri_taizen/app/view_model/bottom_tab_view_model.dart';
import 'package:oogiri_taizen/app/widget/dynamic_links_widget.dart';

class BottomTabView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // ViewModel取得
    final answerListView = useMemoized(() => AnswerListView());
    final myProfileView = useMemoized(() => MyProfileView());
    final viewModel = useProvider(bottomTabViewModelProvider);

    final controller = useTabController(initialLength: 2)
      ..index = viewModel.selected;

    return DynamicLinksWidget(
      onCalled: viewModel.openWithDynamicLinks,
      child: AlertWidget(
        child: WillPopScope(
          // 戻るボタン押下時
          onWillPop: () async {
            // 戻るアクション
            context.read(bottomTabViewModelProvider).pop();
            // 標準の戻るアクションは発火させない
            return false;
          },

          child: Scaffold(
            // 下タブ設定
            bottomNavigationBar: ConvexAppBar(
              // 下タブのテーマ設定（色や影など）
              backgroundColor: Colors.black87,
              activeColor: const Color(0xFFFFCC00),

              // インデックスが変わったときに追従するため
              controller: controller,

              // 選択されたタブのインデックス
              initialActiveIndex: viewModel.selected,

              // タブ押下時
              onTap: (int index) {
                context.read(bottomTabViewModelProvider).tapped(index);
              },

              // タブの表示アイコン
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

            // 表示画面
            body: IndexedStack(
              // 表示画面のインデックス
              index: viewModel.selected,

              // 表示画面の配列
              children: <Widget>[
                Navigator(
                  // ルート画面生成
                  onGenerateRoute: (RouteSettings settings) {
                    return PageRouteBuilder<Widget>(
                      pageBuilder: (
                        BuildContext context,
                        Animation<double> animation1,
                        Animation<double> animation2,
                      ) {
                        // 中身
                        return answerListView;
                      },
                    );
                  },
                ),
                Navigator(
                  // ルート画面生成
                  onGenerateRoute: (RouteSettings settings) {
                    return PageRouteBuilder<Widget>(
                      pageBuilder: (
                        BuildContext context,
                        Animation<double> animation1,
                        Animation<double> animation2,
                      ) {
                        // 中身
                        return myProfileView;
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

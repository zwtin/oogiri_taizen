import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/ui/answer_list/answer_list_view.dart';
import 'package:oogiritaizen/ui/bottom_tab/bottom_tab_view_model.dart';
import 'package:oogiritaizen/ui/my_profile/my_profile_view.dart';

class BottomTabView extends HookWidget {
  final tab0 = Navigator(
    // ルート画面生成
    onGenerateRoute: (RouteSettings settings) {
      return PageRouteBuilder<Widget>(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
        ) {
          // 中身
          return AnswerListView();
        },
      );
    },
  );

  final tab1 = Navigator(
    // ルート画面生成
    onGenerateRoute: (RouteSettings settings) {
      return PageRouteBuilder<Widget>(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
        ) {
          // 中身
          return MyProfileView();
        },
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    // ViewModel取得
    final viewModel = useProvider(bottomTabViewModelProvider);

    return WillPopScope(
      // 戻るボタン押下時
      onWillPop: () {
        // 戻るアクション
        context.read(bottomTabViewModelProvider).pop();
        // 標準の戻るアクションは発火させない
        return Future.value(false);
      },

      child: Scaffold(
        // 下タブ設定
        bottomNavigationBar: FFNavigationBar(
          // 下タブのテーマ設定（色や影など）
          theme: FFNavigationBarTheme(
            barBackgroundColor: Colors.black87,
            selectedItemBackgroundColor: const Color(0xFFFFCC00),
            selectedItemLabelColor: Colors.white,
            selectedItemBorderColor: Colors.yellow,
            unselectedItemIconColor: Colors.grey,
            showSelectedItemShadow: false,
          ),

          // 選択されたタブのインデックス
          selectedIndex: viewModel.selected,

          // タブ押下時
          onSelectTab: (int index) {
            context.read(bottomTabViewModelProvider).tapped(index);
          },

          // タブの表示アイコン
          items: [
            FFNavigationBarItem(
              iconData: Icons.home,
              label: 'ホーム',
            ),
            FFNavigationBarItem(
              iconData: Icons.person,
              label: 'マイページ',
            ),
          ],
        ),

        // 表示画面
        body: IndexedStack(
          // 表示画面のインデックス
          index: viewModel.selected,

          // 表示画面の配列
          children: <Widget>[
            tab0,
            tab1,
          ],
        ),
      ),
    );
  }
}

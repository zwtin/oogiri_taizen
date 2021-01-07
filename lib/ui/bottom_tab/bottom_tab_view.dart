import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/provider/alert.dart';
import 'package:oogiritaizen/ui/answer_list/answer_list_view.dart';
import 'package:oogiritaizen/ui/bottom_tab/bottom_tab_view_model.dart';
import 'package:sweetalert/sweetalert.dart';

class BottomTabView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // blocを取得
    final bottomTabViewModel = useProvider(bottomTabViewModelProvider);

    return ProviderListener(
      onChange: (context, Alert alert) {
        SweetAlert.show(
          context,
          title: alert.title,
          subtitle: alert.subtitle,
          showCancelButton: alert.showCancelButton,
          onPress: alert.onPress,
          style: alert.style,
        );
      },
      provider: alertProvider,
      child: WillPopScope(
        // 戻るボタン押下時
        onWillPop: () {
          // 戻るアクション
//    tabViewModel.popAction();
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
            selectedIndex: bottomTabViewModel.selected,

            // タブ押下時
            onSelectTab: (int index) {
              bottomTabViewModel.tapped(index);
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
            index: bottomTabViewModel.selected,

            // 表示画面の配列
            children: <Widget>[
              AnswerListView(),
              Container(
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

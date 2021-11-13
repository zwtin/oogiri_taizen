import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/view_model/bottom_tab_view_model.dart';
import 'package:oogiri_taizen/app/view_model/setting_view_model.dart';
import 'package:oogiri_taizen/app/widget/router_widget.dart';

class SettingView extends HookWidget {
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    debugPrint('SettingView = $_key');
    final viewModel = useProvider(settingViewModelProvider(_key));

    return RouterWidget(
      key: _key,
      child: Scaffold(
        // ナビゲーションバー
        appBar: AppBar(
          title: const Text(
            '設定',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFFFFCC00),
          elevation: 0, // 影をなくす
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.white24,
              height: 1,
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              color: const Color(0xFFFFCC00),
            ),
            SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        height: 16,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: viewModel.loginUser == null
                              ? [
                                  ListTile(
                                    title: const Text(
                                      'ブロック済み一覧',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                    onTap: () async {
                                      await context
                                          .read(settingViewModelProvider(_key))
                                          .transitionToBlockList();
                                    },
                                  ),
                                ]
                              : [
                                  const ListTile(
                                    title: Text(
                                      'プッシュ通知',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                  const ListTile(
                                    title: Text(
                                      '外部アカウント連携',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                  ListTile(
                                    title: const Text(
                                      'ブロック済み一覧',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    trailing: const Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                    onTap: () async {
                                      await context
                                          .read(settingViewModelProvider(_key))
                                          .transitionToBlockList();
                                    },
                                  ),
                                ],
                        ),
                      ),
                      Container(
                        height: 32,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text(
                                '利用規約',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                              onTap: () async {
                                await context
                                    .read(settingViewModelProvider(_key))
                                    .transitionToTermsOfService();
                              },
                            ),
                            Container(
                              color: Colors.white,
                              height: 1,
                            ),
                            const ListTile(
                              title: Text(
                                'プライバシーポリシー',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              height: 1,
                            ),
                            const ListTile(
                              title: Text(
                                'ライセンス',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 32,
                      ),
                      viewModel.loginUser == null
                          ? Container()
                          : Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                children: [
                                  const ListTile(
                                    title: Text(
                                      'メールアドレス変更',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                  const ListTile(
                                    title: Text(
                                      'パスワード変更',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                  const ListTile(
                                    title: Text(
                                      'アカウント削除',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

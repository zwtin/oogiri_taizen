import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/provider/alert.dart';
import 'package:oogiritaizen/data/provider/tab_1_navigator.dart';
import 'package:oogiritaizen/ui/bottom_tab/bottom_tab_view_model.dart';
import 'package:oogiritaizen/ui/my_profile/my_profile_view_model.dart';
import 'package:oogiritaizen/ui/sign_in/sign_in_view.dart';
import 'package:oogiritaizen/ui/sign_up/sign_up_view.dart';
import 'package:sweetalert/sweetalert.dart';

class MyProfileView extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(myProfileViewModelProvider);
    return ProviderListener(
      onChange: (BuildContext context, Alert alert) {
        if (alert.viewName == 'MyProfileView') {
          SweetAlert.show(
            context,
            title: alert.title,
            subtitle: alert.subtitle,
            showCancelButton: alert.showCancelButton,
            onPress: alert.onPress,
            style: alert.style,
          );
        }
      },
      provider: alertProvider,
      child: ProviderListener(
        onChange: (BuildContext context, Tab1Navigator navigator) {
          if (navigator.n == 0) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.read(bottomTabViewModelProvider).tapped(0);
            }
          }
        },
        provider: tab1NavigatorProvider,
        child: Builder(
          builder: (BuildContext context) {
            if (viewModel.userId == null) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'マイページ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: const Color(0xFFFFCC00),
                  elevation: 0,
                  bottom: PreferredSize(
                    child: Container(
                      color: Colors.white24,
                      height: 1,
                    ),
                    preferredSize: const Size.fromHeight(1),
                  ),
                ),
                body: Stack(
                  children: [
                    Container(
                      color: const Color(0xFFFFCC00),
                    ),
                    Column(
                      children: [
                        const Spacer(),
                        Row(
                          children: [
                            // ボタン0
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 40),
                                child: RaisedButton(
                                  child: const SizedBox(
                                    child: Center(
                                      child: Text(
                                        'ログイン',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    height: 50,
                                  ),
                                  color: const Color(0xFFFFCC00),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    // ボタン押下時
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      MaterialPageRoute<SignInView>(
                                        builder: (BuildContext context) {
                                          // 複数のProviderを提供
                                          return SignInView();
                                        },
                                        // 全画面で表示
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            // ボタン1
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 40),
                                child: RaisedButton(
                                  child: const SizedBox(
                                    child: Center(
                                      child: Text(
                                        '新規登録',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    height: 50,
                                  ),
                                  color: const Color(0xFFFFCC00),
                                  textColor: Colors.white,
                                  onPressed: () {
                                    // ボタン押下時
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      MaterialPageRoute<SignUpView>(
                                        builder: (BuildContext context) {
                                          // 複数のProviderを提供
                                          return SignUpView();
                                        },
                                        // 全画面で表示
                                        fullscreenDialog: true,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              );
            }
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'マイページ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: const Color(0xFFFFCC00),
                elevation: 0,
                bottom: PreferredSize(
                  child: Container(
                    color: Colors.white24,
                    height: 1,
                  ),
                  preferredSize: const Size.fromHeight(1),
                ),
              ),
              body: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverToBoxAdapter(
                        child: Container(
                          height: 200,
                        ),
                      ),
                      const SliverAppBar(
                        pinned: true,
                        toolbarHeight: 0,
                        collapsedHeight: 0.01,
                        bottom: TabBar(
                          tabs: [
                            Tab(
                              text: '投稿したボケ',
                            ),
                            Tab(
                              text: 'お気に入りのボケ',
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      RefreshIndicator(
                        onRefresh: () {},
                        child: ListView.builder(
                          key: const PageStorageKey<String>('posted'),
                          itemBuilder: (BuildContext context, int index) {
//                            if (index == viewModel.items.length - 5) {
//                              viewModel.addAnswer();
//                            }
                            return SizedBox(
                              child: Center(
                                child: Text(index.toString()),
                              ),
                              height: 50,
                            );
                          },
//                          itemCount: viewModel.items.length,
                        ),
                      ),
                      RefreshIndicator(
                        onRefresh: () {},
                        child: ListView.builder(
                          key: const PageStorageKey<String>('favorite'),
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              child: Center(
                                child: Text(index.toString()),
                              ),
                              height: 50,
                            );
                          },
//                          itemCount: viewModel.items.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

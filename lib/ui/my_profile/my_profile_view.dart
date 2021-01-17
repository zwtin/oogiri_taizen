import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/provider/alert_notifier.dart';
import 'package:oogiritaizen/data/provider/tab_1_navigator_notifier.dart';
import 'package:oogiritaizen/ui/bottom_tab/bottom_tab_view_model.dart';
import 'package:oogiritaizen/ui/edit_profile/edit_profile_view.dart';
import 'package:oogiritaizen/ui/image_detail/fade_in_route.dart';
import 'package:oogiritaizen/ui/image_detail/image_detail_view.dart';
import 'package:oogiritaizen/ui/my_profile/my_profile_view_model.dart';
import 'package:oogiritaizen/ui/sign_in/sign_in_view.dart';
import 'package:oogiritaizen/ui/sign_up/sign_up_view.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:oogiritaizen/data/model/extension/string_extension.dart';

class MyProfileView extends HookWidget {
  final id = StringExtension.randomString(8);

  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(myProfileViewModelProvider(id));
    if (viewModel.user == null) {
      return ProviderListener(
        onChange: (BuildContext context, AlertNotifier alertNotifier) {
          SweetAlert.show(
            context,
            title: alertNotifier.title,
            subtitle: alertNotifier.subtitle,
            showCancelButton: alertNotifier.showCancelButton,
            onPress: alertNotifier.onPress,
            style: alertNotifier.style,
          );
        },
        provider: alertNotifierProvider(id),
        child: ProviderListener(
          onChange: (BuildContext context, Tab1NavigatorNotifier navigator) {
            if (navigator.nextWidget != null) {
              Navigator.of(context).push(
                MaterialPageRoute<Widget>(
                  builder: (BuildContext context) {
                    return navigator.nextWidget;
                  },
                  fullscreenDialog: navigator.fullScreen,
                ),
              );
            } else if (navigator.toRoot) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.read(bottomTabViewModelProvider).tapped(0);
              }
            }
          },
          provider: tab1NavigatorNotifierProvider,
          child: Scaffold(
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
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
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
                                Navigator.of(context, rootNavigator: true).push(
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
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
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
                                Navigator.of(context, rootNavigator: true).push(
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
          ),
        ),
      );
    }
    return ProviderListener(
      onChange: (BuildContext context, AlertNotifier alertNotifier) {
        SweetAlert.show(
          context,
          title: alertNotifier.title,
          subtitle: alertNotifier.subtitle,
          showCancelButton: alertNotifier.showCancelButton,
          onPress: alertNotifier.onPress,
          style: alertNotifier.style,
        );
      },
      provider: alertNotifierProvider(id),
      child: ProviderListener(
        onChange: (BuildContext context, Tab1NavigatorNotifier navigator) {
          if (navigator.nextWidget != null) {
            Navigator.of(context).push(
              MaterialPageRoute<Widget>(
                builder: (BuildContext context) {
                  return navigator.nextWidget;
                },
                fullscreenDialog: navigator.fullScreen,
              ),
            );
          } else if (navigator.toRoot) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.read(bottomTabViewModelProvider).tapped(0);
            }
          }
        },
        provider: tab1NavigatorNotifierProvider,
        child: Scaffold(
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
            // ナビゲーションバーの右上のボタン
            actions: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.menu,
                ),
                onPressed: () {
                  showModalBottomSheet<int>(
                    context: context,
                    builder: (BuildContext _context) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.edit),
                              title: const Text('プロフィール編集'),
                              onTap: () {
                                Navigator.of(_context).pop();
                                Navigator.of(context).push(
                                  MaterialPageRoute<EditProfileView>(
                                    builder: (BuildContext context) {
                                      return EditProfileView();
                                    },
                                  ),
                                );
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.settings),
                              title: const Text('設定'),
                              onTap: () {},
                            ),
                            ListTile(
                              leading: const Icon(Icons.logout),
                              title: const Text('ログアウト'),
                              onTap: () {
                                Navigator.of(_context).pop();
                                viewModel.signOut();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
          body: DefaultTabController(
            length: 2,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverToBoxAdapter(
                    child: Container(
                      color: const Color(0xFFFFCC00),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).push(
                                  FadeInRoute(
                                    widget: ImageDetailView(
                                      imageUrl: viewModel.user.imageUrl,
                                      imageTag: 'imageHero',
                                    ),
                                    opaque: false,
                                  ),
                                );
                              },
                              child: Hero(
                                tag: 'imageHero',
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      imageUrl: viewModel.user.imageUrl,
                                      errorWidget:
                                          (context, url, dynamic error) =>
                                              Image.asset(
                                        'assets/icon/no_user.jpg',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 16,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  viewModel.user.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'ID:',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      width: 150,
                                      child: Text(
                                        viewModel.user.id,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 16,
                                ),
                                Text(
                                  viewModel.user.introduction,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SliverAppBar(
                    pinned: true,
                    toolbarHeight: 0,
                    collapsedHeight: 0.01,
                    backgroundColor: Color(0xFFFFCC00),
                    bottom: TabBar(
                      indicatorColor: Colors.blue,
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
                    onRefresh: viewModel.refresh,
                    child: ListView.builder(
                      key: const PageStorageKey<String>('posted'),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == viewModel.items.length - 5) {
                          viewModel.addAnswer();
                        }
                        return SizedBox(
                          child: Center(
                            child: Text(index.toString()),
                          ),
                          height: 50,
                        );
                      },
                      itemCount: viewModel.items.length,
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: viewModel.refresh,
                    child: ListView.builder(
                      key: const PageStorageKey<String>('favorite'),
                      itemBuilder: (BuildContext context, int index) {
                        if (index == viewModel.items.length - 5) {
                          viewModel.addAnswer();
                        }
                        return SizedBox(
                          child: Center(
                            child: Text(index.toString()),
                          ),
                          height: 50,
                        );
                      },
                      itemCount: viewModel.items.length,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

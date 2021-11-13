import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiri_taizen/app/view_model/bottom_tab_view_model.dart';
import 'package:oogiri_taizen/app/view_model/my_profile_view_model.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/widget/answer_card_widget.dart';
import 'package:oogiri_taizen/app/widget/fade_in_route.dart';
import 'package:oogiri_taizen/extension/string_extension.dart';

class MyProfileView extends HookWidget {
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    debugPrint('MyProfileView = $_key');

    // bottomTabにGlobalKeyをセット
    useProvider(bottomTabViewModelProvider).setUniqueKey(index: 1, key: _key);
    final viewModel = useProvider(myProfileViewModelProvider(_key));

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
      child: Builder(
        builder: (context) {
          if (viewModel.loginUser == null) {
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
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    color: Colors.white24,
                    height: 1,
                  ),
                ),
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
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.settings),
                                  title: const Text('設定'),
                                  onTap: () async {
                                    Navigator.of(_context).pop();
                                    await context
                                        .read(myProfileViewModelProvider(_key))
                                        .transitionToSetting();
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
              body: Stack(
                children: [
                  Container(
                    color: const Color(0xFFFFCC00),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        const Spacer(),
                        Row(
                          children: [
                            // ボタン0
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 40),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFFFFCC00), //ボタンの背景色
                                  ),
                                  onPressed: () {
                                    context
                                        .read(myProfileViewModelProvider(_key))
                                        .transitionToSignIn();
                                  },
                                  child: const SizedBox(
                                    height: 50,
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
                                  ),
                                ),
                              ),
                            ),

                            // ボタン1
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 40),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xFFFFCC00), //ボタンの背景色
                                  ),
                                  onPressed: () {
                                    context
                                        .read(myProfileViewModelProvider(_key))
                                        .transitionToSignUp();
                                  },
                                  child: const SizedBox(
                                    height: 50,
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
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  color: Colors.white24,
                  height: 1,
                ),
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
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.edit),
                                title: const Text('プロフィール編集'),
                                onTap: () async {
                                  Navigator.of(_context).pop();
                                  await context
                                      .read(myProfileViewModelProvider(_key))
                                      .transitionToEditProfile();
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.settings),
                                title: const Text('設定'),
                                onTap: () async {
                                  Navigator.of(_context).pop();
                                  await context
                                      .read(myProfileViewModelProvider(_key))
                                      .transitionToSetting();
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.logout),
                                title: const Text('ログアウト'),
                                onTap: () async {
                                  Navigator.of(_context).pop();
                                  await context
                                      .read(myProfileViewModelProvider(_key))
                                      .logout();
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
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Builder(
                                  builder: (BuildContext context) {
                                    if ((viewModel.loginUser?.imageUrl ?? '')
                                        .isEmpty) {
                                      return SizedBox(
                                        width: 100,
                                        height: 100,
                                        child: ClipOval(
                                          child: Image.asset(
                                            'assets/images/no_user.jpg',
                                          ),
                                        ),
                                      );
                                    }

                                    final imageTag =
                                        StringExtension.randomString(8);
                                    return GestureDetector(
                                      onTap: () {
                                        viewModel.transitionToImageDetail(
                                          imageUrl:
                                              viewModel.loginUser?.imageUrl ??
                                                  '',
                                          imageTag: imageTag,
                                        );
                                      },
                                      child: Hero(
                                        tag: imageTag,
                                        child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            imageUrl:
                                                viewModel.loginUser?.imageUrl ??
                                                    '',
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, dynamic error) =>
                                                    ClipOval(
                                              child: Image.asset(
                                                'assets/images/no_user.jpg',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Container(
                                  width: 16,
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      viewModel.loginUser?.name ?? '',
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
                                        ),
                                        Flexible(
                                          child: Text(
                                            viewModel.loginUser?.id ?? '',
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
                                    viewModel.loginUser?.emailVerified ?? false
                                        ? Container()
                                        : const Text(
                                            '※ メールアドレス未認証',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                    Container(
                                      height: 16,
                                    ),
                                    Text(
                                      viewModel.loginUser?.introduction ?? '',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SliverAppBar(
                      pinned: true,
                      toolbarHeight: 0,
                      collapsedHeight: 0.01,
                      backgroundColor: Color(0xFFFFCC00),
                      elevation: 0,
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
                body: Stack(
                  children: [
                    Container(
                      color: const Color(0xFFFFCC00),
                    ),
                    TabBarView(
                      children: [
                        RefreshIndicator(
                          color: const Color(0xFFFFCC00),
                          onRefresh: () {
                            return context
                                .read(myProfileViewModelProvider(_key))
                                .resetCreatedAnswers();
                          },
                          child: SafeArea(
                            child: ListView.builder(
                              key: PageStorageKey<String>('created_$_key'),
                              itemBuilder: (context, index) {
                                if (viewModel.hasNextInCreate &&
                                    index ==
                                        viewModel.createAnswers.length - 3) {
                                  context
                                      .read(myProfileViewModelProvider(_key))
                                      .fetchCreatedAnswers();
                                }
                                if (index == viewModel.createAnswers.length) {
                                  if (viewModel.hasNextInCreate) {
                                    return const SizedBox(
                                      height: 62,
                                      child: Center(
                                        child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: Text(
                                          '表示できるボケがありません',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                                return AnswerCardWidget(
                                  userImageUrl: viewModel.createAnswers
                                      .elementAt(index)
                                      .createdUser
                                      .imageUrl,
                                  createdTime: viewModel.createAnswers
                                      .elementAt(index)
                                      .createdAt,
                                  userName: viewModel.createAnswers
                                      .elementAt(index)
                                      .createdUser
                                      .name,
                                  menuList: [
                                    ListTile(
                                      leading: const Icon(Icons.block),
                                      title: const Text('このボケを削除する'),
                                      onTap: () {},
                                    ),
                                  ],
                                  text: viewModel.createAnswers
                                      .elementAt(index)
                                      .topic
                                      .text,
                                  imageUrl: viewModel.createAnswers
                                      .elementAt(index)
                                      .topic
                                      .imageUrl,
                                  imageTag: viewModel.createAnswers
                                      .elementAt(index)
                                      .topic
                                      .imageTag,
                                  onTapImage: () {
                                    final viewModel = context.read(
                                      myProfileViewModelProvider(_key),
                                    );
                                    viewModel.transitionToImageDetail(
                                        imageUrl: viewModel.createAnswers
                                                .elementAt(index)
                                                .topic
                                                .imageUrl ??
                                            '',
                                        imageTag: viewModel.createAnswers
                                                .elementAt(index)
                                                .topic
                                                .imageTag ??
                                            '');
                                  },
                                  isLike: viewModel.createAnswers
                                      .elementAt(index)
                                      .isLike,
                                  onTapLikeButton: () async {
                                    final viewModel = context.read(
                                      myProfileViewModelProvider(_key),
                                    );
                                    await viewModel.likeAnswer(
                                      viewModel.createAnswers.elementAt(index),
                                    );
                                  },
                                  likedTime: viewModel.createAnswers
                                      .elementAt(index)
                                      .likedTime,
                                  isFavor: viewModel.createAnswers
                                      .elementAt(index)
                                      .isFavor,
                                  onTapFavorButton: () async {
                                    final viewModel = context.read(
                                      myProfileViewModelProvider(_key),
                                    );
                                    await viewModel.favorAnswer(
                                      viewModel.createAnswers.elementAt(index),
                                    );
                                  },
                                  favoredTime: viewModel.createAnswers
                                      .elementAt(index)
                                      .favoredTime,
                                  onTap: () async {
                                    final viewModel = context.read(
                                      myProfileViewModelProvider(_key),
                                    );
                                    await viewModel.transitionToAnswerDetail(
                                      id: viewModel.createAnswers
                                          .elementAt(index)
                                          .id,
                                    );
                                  },
                                );
                              },
                              itemCount: (viewModel.createAnswers.isEmpty ||
                                      viewModel.hasNextInCreate)
                                  ? viewModel.createAnswers.length + 1
                                  : viewModel.createAnswers.length,
                            ),
                          ),
                        ),
                        RefreshIndicator(
                          color: const Color(0xFFFFCC00),
                          onRefresh: () {
                            return context
                                .read(myProfileViewModelProvider(_key))
                                .resetFavorAnswers();
                          },
                          child: SafeArea(
                            child: ListView.builder(
                              key: PageStorageKey<String>('favor_$_key'),
                              itemBuilder: (context, index) {
                                if (viewModel.hasNextInFavor &&
                                    index ==
                                        viewModel.favorAnswers.length - 3) {
                                  context
                                      .read(myProfileViewModelProvider(_key))
                                      .fetchFavorAnswers();
                                }
                                if (index == viewModel.favorAnswers.length) {
                                  if (viewModel.hasNextInFavor) {
                                    return const SizedBox(
                                      height: 62,
                                      child: Center(
                                        child: SizedBox(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: Text(
                                          '表示できるボケがありません',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                }
                                return AnswerCardWidget(
                                  userImageUrl: viewModel.favorAnswers
                                      .elementAt(index)
                                      .createdUser
                                      .imageUrl,
                                  createdTime: viewModel.favorAnswers
                                      .elementAt(index)
                                      .createdAt,
                                  userName: viewModel.favorAnswers
                                      .elementAt(index)
                                      .createdUser
                                      .name,
                                  menuList: viewModel.favorAnswers
                                          .elementAt(index)
                                          .isOwn
                                      ? [
                                          ListTile(
                                            leading: const Icon(Icons.block),
                                            title: const Text('このボケを削除する'),
                                            onTap: () {},
                                          ),
                                        ]
                                      : [
                                          ListTile(
                                            leading: const Icon(Icons.block),
                                            title: const Text('このボケをブロックする'),
                                            onTap: () {
                                              final viewModel = context.read(
                                                myProfileViewModelProvider(
                                                    _key),
                                              );
                                              viewModel.addBlockAnswer(
                                                viewModel.favorAnswers
                                                    .elementAt(index),
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.block),
                                            title: const Text('このユーザーをブロックする'),
                                            onTap: () {
                                              final viewModel = context.read(
                                                myProfileViewModelProvider(
                                                    _key),
                                              );
                                              viewModel.addBlockUser(
                                                viewModel.favorAnswers
                                                    .elementAt(index)
                                                    .createdUser,
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.report),
                                            title: const Text('このユーザーを通報する'),
                                            onTap: () {},
                                          ),
                                        ],
                                  text: viewModel.favorAnswers
                                      .elementAt(index)
                                      .topic
                                      .text,
                                  imageUrl: viewModel.favorAnswers
                                      .elementAt(index)
                                      .topic
                                      .imageUrl,
                                  imageTag: viewModel.favorAnswers
                                      .elementAt(index)
                                      .topic
                                      .imageTag,
                                  onTapImage: () {
                                    final viewModel = context.read(
                                      myProfileViewModelProvider(_key),
                                    );
                                    viewModel.transitionToImageDetail(
                                        imageUrl: viewModel.favorAnswers
                                                .elementAt(index)
                                                .topic
                                                .imageUrl ??
                                            '',
                                        imageTag: viewModel.favorAnswers
                                                .elementAt(index)
                                                .topic
                                                .imageTag ??
                                            '');
                                  },
                                  isLike: viewModel.favorAnswers
                                      .elementAt(index)
                                      .isLike,
                                  onTapLikeButton: () async {
                                    final viewModel = context.read(
                                      myProfileViewModelProvider(_key),
                                    );
                                    await viewModel.likeAnswer(
                                      viewModel.favorAnswers.elementAt(index),
                                    );
                                  },
                                  likedTime: viewModel.favorAnswers
                                      .elementAt(index)
                                      .likedTime,
                                  isFavor: viewModel.favorAnswers
                                      .elementAt(index)
                                      .isFavor,
                                  onTapFavorButton: () async {
                                    final viewModel = context.read(
                                      myProfileViewModelProvider(_key),
                                    );
                                    await viewModel.favorAnswer(
                                      viewModel.favorAnswers.elementAt(index),
                                    );
                                  },
                                  favoredTime: viewModel.favorAnswers
                                      .elementAt(index)
                                      .favoredTime,
                                  onTap: () async {
                                    final viewModel = context.read(
                                      myProfileViewModelProvider(_key),
                                    );
                                    await viewModel.transitionToAnswerDetail(
                                      id: viewModel.favorAnswers
                                          .elementAt(index)
                                          .id,
                                    );
                                  },
                                );
                              },
                              itemCount: (viewModel.favorAnswers.isEmpty ||
                                      viewModel.hasNextInFavor)
                                  ? viewModel.favorAnswers.length + 1
                                  : viewModel.favorAnswers.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

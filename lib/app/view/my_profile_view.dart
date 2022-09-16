import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/view/my_create_answer_list_view.dart';
import 'package:oogiri_taizen/app/view/my_favor_answer_list_view.dart';
import 'package:oogiri_taizen/app/view_model/my_profile_view_model.dart';
import 'package:oogiri_taizen/app/widget/router_widget.dart';
import 'package:oogiri_taizen/extension/string_extension.dart';

class MyProfileView extends HookWidget {
  final _key = UniqueKey();
  final _logger = Logger();

  @override
  Widget build(BuildContext context) {
    _logger.d('MyProfileView = $_key');
    final viewModel = useProvider(myProfileViewModelProvider(_key));
    final myCreateAnswerListView = useMemoized(() => MyCreateAnswerListView());
    final myFavorAnswerListView = useMemoized(() => MyFavorAnswerListView());
    final tabController = useTabController(initialLength: 2);

    return RouterWidget(
      key: _key,
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
                  builder: (_context) {
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
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
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
                            builder: (context) {
                              if ((viewModel.viewData?.imageUrl ?? '')
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

                              final imageTag = StringExtension.randomString(8);
                              return GestureDetector(
                                onTap: () {
                                  viewModel.transitionToImageDetail(
                                    imageUrl:
                                        viewModel.viewData?.imageUrl ?? '',
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
                                        child: CircularProgressIndicator(),
                                      ),
                                      imageUrl:
                                          viewModel.viewData?.imageUrl ?? '',
                                      imageBuilder: (context, imageProvider) =>
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
                                viewModel.viewData?.name ?? '',
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
                                      viewModel.viewData?.id ?? '',
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
                              viewModel.viewData?.emailVerified ?? false
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
                                viewModel.viewData?.introduction ?? '',
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
              SliverAppBar(
                pinned: true,
                toolbarHeight: 0,
                collapsedHeight: 0.01,
                backgroundColor: const Color(0xFFFFCC00),
                elevation: 0,
                bottom: TabBar(
                  indicatorColor: Colors.blue,
                  controller: tabController,
                  tabs: const [
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
                controller: tabController,
                children: [
                  myCreateAnswerListView,
                  myFavorAnswerListView,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

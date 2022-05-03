import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/view_model/user_profile_view_model.dart';
import 'package:oogiri_taizen/app/widget/answer_card_widget.dart';
import 'package:oogiri_taizen/app/widget/router_widget.dart';
import 'package:oogiri_taizen/extension/string_extension.dart';
import 'package:tuple/tuple.dart';

class ProfileView extends HookWidget {
  ProfileView({required this.userId});

  final _key = UniqueKey();
  final String userId;

  @override
  Widget build(BuildContext context) {
    debugPrint('ProfileView = $_key');

    final viewModel = useProvider(
      profileViewModelProvider(
        Tuple2(_key, userId),
      ),
    );

    return RouterWidget(
      key: _key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ユーザーページ',
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
                                if ((viewModel.user?.imageUrl ?? '').isEmpty) {
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
                                      imageUrl: viewModel.user?.imageUrl ?? '',
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
                                            viewModel.user?.imageUrl ?? '',
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
                                  viewModel.user?.name ?? '',
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
                                        viewModel.user?.id ?? '',
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
                                  viewModel.user?.introduction ?? '',
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
                            .read(
                              profileViewModelProvider(
                                Tuple2<UniqueKey, String>(_key, userId),
                              ),
                            )
                            .resetCreatedAnswers();
                      },
                      child: SafeArea(
                        child: ListView.builder(
                          key: PageStorageKey<String>('created_$_key'),
                          itemBuilder: (context, index) {
                            if (viewModel.hasNextInCreate &&
                                index == viewModel.createAnswers.length - 3) {
                              context
                                  .read(
                                    profileViewModelProvider(
                                      Tuple2<UniqueKey, String>(_key, userId),
                                    ),
                                  )
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
                              menuList:
                                  viewModel.createAnswers.elementAt(index).isOwn
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
                                                profileViewModelProvider(
                                                  Tuple2<UniqueKey, String>(
                                                      _key, userId),
                                                ),
                                              );
                                              viewModel.addBlockAnswer(
                                                viewModel.createAnswers
                                                    .elementAt(index),
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.block),
                                            title: const Text('このユーザーをブロックする'),
                                            onTap: () {
                                              final viewModel = context.read(
                                                profileViewModelProvider(
                                                  Tuple2<UniqueKey, String>(
                                                      _key, userId),
                                                ),
                                              );
                                              viewModel.addBlockUser(
                                                viewModel.createAnswers
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
                                  profileViewModelProvider(
                                    Tuple2<UniqueKey, String>(_key, userId),
                                  ),
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
                                  profileViewModelProvider(
                                    Tuple2<UniqueKey, String>(_key, userId),
                                  ),
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
                                  profileViewModelProvider(
                                    Tuple2<UniqueKey, String>(_key, userId),
                                  ),
                                );
                                await viewModel.favorAnswer(
                                  viewModel.createAnswers.elementAt(index),
                                );
                              },
                              favoredTime: viewModel.createAnswers
                                  .elementAt(index)
                                  .favoredTime,
                              onTap: () {
                                final viewModel = context.read(
                                  profileViewModelProvider(
                                    Tuple2<UniqueKey, String>(_key, userId),
                                  ),
                                );
                                viewModel.transitionToAnswerDetail(
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
                            .read(
                              profileViewModelProvider(
                                Tuple2<UniqueKey, String>(_key, userId),
                              ),
                            )
                            .resetFavorAnswers();
                      },
                      child: SafeArea(
                        child: ListView.builder(
                          key: PageStorageKey<String>('favor_$_key'),
                          itemBuilder: (context, index) {
                            if (viewModel.hasNextInFavor &&
                                index == viewModel.favorAnswers.length - 3) {
                              context
                                  .read(
                                    profileViewModelProvider(
                                      Tuple2<UniqueKey, String>(_key, userId),
                                    ),
                                  )
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
                              menuList:
                                  viewModel.favorAnswers.elementAt(index).isOwn
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
                                                profileViewModelProvider(
                                                  Tuple2<UniqueKey, String>(
                                                      _key, userId),
                                                ),
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
                                                profileViewModelProvider(
                                                  Tuple2<UniqueKey, String>(
                                                      _key, userId),
                                                ),
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
                                  profileViewModelProvider(
                                    Tuple2<UniqueKey, String>(_key, userId),
                                  ),
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
                                  profileViewModelProvider(
                                    Tuple2<UniqueKey, String>(_key, userId),
                                  ),
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
                                  profileViewModelProvider(
                                    Tuple2<UniqueKey, String>(_key, userId),
                                  ),
                                );
                                await viewModel.favorAnswer(
                                  viewModel.favorAnswers.elementAt(index),
                                );
                              },
                              favoredTime: viewModel.favorAnswers
                                  .elementAt(index)
                                  .favoredTime,
                              onTap: () {
                                final viewModel = context.read(
                                  profileViewModelProvider(
                                    Tuple2<UniqueKey, String>(_key, userId),
                                  ),
                                );
                                viewModel.transitionToAnswerDetail(
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
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/bottom_tab_view_model.dart';
import 'package:oogiritaizen/ui/edit_profile/edit_profile_view.dart';
import 'package:oogiritaizen/ui/image_detail/fade_in_route.dart';
import 'package:oogiritaizen/ui/image_detail/image_detail_view.dart';
import 'package:oogiritaizen/ui/my_profile/my_profile_view_model.dart';
import 'package:oogiritaizen/ui/sign_in/sign_in_view.dart';
import 'package:oogiritaizen/ui/sign_up/sign_up_view.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:oogiritaizen/model/extension/string_extension.dart';

class MyProfileView extends HookWidget {
  const MyProfileView(this.parameter);

  final MyProfileViewModelParameter parameter;

  @override
  Widget build(BuildContext context) {
    // ViewModel取得
    final viewModel = useProvider(myProfileViewModelProvider(parameter));

    return ProviderListener(
      onChange: (BuildContext context, AlertViewModel alertViewModel) {
        SweetAlert.show(
          context,
          title: alertViewModel.alertEntity.title,
          subtitle: alertViewModel.alertEntity.subtitle,
          showCancelButton: alertViewModel.alertEntity.showCancelButton,
          onPress: alertViewModel.alertEntity.onPress,
          style: alertViewModel.alertEntity.style,
        );
      },
      provider: alertViewModelProvider(parameter.screenId),
      child: ProviderListener(
        onChange:
            (BuildContext context, NavigatorViewModel navigatorViewModel) {
          if (navigatorViewModel.nextWidget != null) {
            Navigator.of(context, rootNavigator: navigatorViewModel.fullScreen)
                .push(
              MaterialPageRoute<Widget>(
                builder: (BuildContext context) {
                  return navigatorViewModel.nextWidget;
                },
                fullscreenDialog: navigatorViewModel.fullScreen,
              ),
            );
          } else if (navigatorViewModel.toRoot) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.read(bottomTabViewModelProvider).tapped(0);
            }
          }
        },
        provider: navigatorViewModelProvider('Tab1'),
        child: Builder(
          builder: (BuildContext context) {
            // 未ログイン時
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
                                    context
                                        .read(myProfileViewModelProvider(
                                            parameter))
                                        .transitionToSignIn();
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
                                    context
                                        .read(myProfileViewModelProvider(
                                            parameter))
                                        .transitionToSignUp();
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
                                    context
                                        .read(myProfileViewModelProvider(
                                            parameter))
                                        .transitionToEditProfile();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.settings),
                                  title: const Text('設定'),
                                  onTap: () {
                                    Navigator.of(_context).pop();
                                    context
                                        .read(myProfileViewModelProvider(
                                            parameter))
                                        .transitionToSetting();
                                  },
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
                                    Navigator.of(context, rootNavigator: true)
                                        .push(
                                      FadeInRoute(
                                        widget: ImageDetailView(
                                          imageUrl:
                                              viewModel.loginUser.imageUrl,
                                          imageTag: 'imageHero',
                                        ),
                                        opaque: false,
                                      ),
                                    );
                                  },
                                  child: Hero(
                                    tag: 'imageHero',
                                    child: SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        imageUrl: viewModel.loginUser.imageUrl,
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
                                                Image.asset(
                                          'assets/icon/no_user.jpg',
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
                                      viewModel.loginUser.name,
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
                                            viewModel.loginUser.id,
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
                                      viewModel.loginUser.introduction,
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
                                  .read(myProfileViewModelProvider(parameter))
                                  .refreshCreateAnswerList();
                            },
                            child: ListView.builder(
                              key: const PageStorageKey<String>('created'),
                              itemBuilder: (BuildContext context, int index) {
                                if (index ==
                                    viewModel.createAnswers.length - 3) {
                                  viewModel.getCreateAnswerList();
                                }
                                if (index == viewModel.createAnswers.length) {
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
                                }
                                return GestureDetector(
                                  onTap: () {
                                    context
                                        .read(myProfileViewModelProvider(
                                            parameter))
                                        .transitionToAnswerDetail(
                                          answerId: viewModel.createAnswers
                                              .elementAt(index)
                                              .id,
                                        );
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 44,
                                                height: 44,
                                                child: CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  imageUrl: viewModel
                                                      .createAnswers
                                                      .elementAt(index)
                                                      .topic
                                                      .createdUser
                                                      .imageUrl,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                          dynamic error) =>
                                                      Image.asset(
                                                    'assets/icon/no_user.jpg',
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      StringExtension
                                                          .getJPStringFromDateTime(
                                                        viewModel.createAnswers
                                                            .elementAt(index)
                                                            .topic
                                                            .createdAt,
                                                      ),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: Container(
                                                            child: Text(
                                                              viewModel
                                                                  .createAnswers
                                                                  .elementAt(
                                                                      index)
                                                                  .topic
                                                                  .createdUser
                                                                  .name,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: const Text(
                                                            ' のお題：',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 16,
                                          ),
                                          Text(
                                            viewModel.createAnswers
                                                .elementAt(index)
                                                .topic
                                                .text,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                            ),
                                          ),
                                          (viewModel.createAnswers
                                                          .elementAt(index)
                                                          .topic
                                                          .imageUrl !=
                                                      null &&
                                                  viewModel.createAnswers
                                                      .elementAt(index)
                                                      .topic
                                                      .imageUrl
                                                      .isNotEmpty)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 16, 0, 0),
                                                  child: CachedNetworkImage(
                                                    placeholder:
                                                        (context, url) =>
                                                            const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    imageUrl: viewModel
                                                        .createAnswers
                                                        .elementAt(index)
                                                        .topic
                                                        .imageUrl,
                                                    errorWidget: (context, url,
                                                            dynamic error) =>
                                                        Image.asset(
                                                      'assets/icon/no_image.jpg',
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: viewModel.hasNextInCreate &&
                                      viewModel.createAnswers.isNotEmpty
                                  ? viewModel.createAnswers.length + 1
                                  : viewModel.createAnswers.length,
                            ),
                          ),
                          RefreshIndicator(
                            color: const Color(0xFFFFCC00),
                            onRefresh: () {
                              return context
                                  .read(myProfileViewModelProvider(parameter))
                                  .refreshFavorAnswerList();
                            },
                            child: ListView.builder(
                              key: const PageStorageKey<String>('favorite'),
                              itemBuilder: (BuildContext context, int index) {
                                if (index ==
                                    viewModel.favorAnswers.length - 3) {
                                  viewModel.getCreateAnswerList();
                                }
                                if (index == viewModel.favorAnswers.length) {
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
                                }
                                return GestureDetector(
                                  onTap: () {
                                    context
                                        .read(myProfileViewModelProvider(
                                            parameter))
                                        .transitionToAnswerDetail(
                                          answerId: viewModel.favorAnswers
                                              .elementAt(index)
                                              .id,
                                        );
                                  },
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 44,
                                                height: 44,
                                                child: CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  imageUrl: viewModel
                                                      .favorAnswers
                                                      .elementAt(index)
                                                      .topic
                                                      .createdUser
                                                      .imageUrl,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  errorWidget: (context, url,
                                                          dynamic error) =>
                                                      Image.asset(
                                                    'assets/icon/no_user.jpg',
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 16,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      StringExtension
                                                          .getJPStringFromDateTime(
                                                        viewModel.favorAnswers
                                                            .elementAt(index)
                                                            .topic
                                                            .createdAt,
                                                      ),
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Flexible(
                                                          child: Container(
                                                            child: Text(
                                                              viewModel
                                                                  .favorAnswers
                                                                  .elementAt(
                                                                      index)
                                                                  .topic
                                                                  .createdUser
                                                                  .name,
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: const Text(
                                                            ' のお題：',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 16,
                                          ),
                                          Text(
                                            viewModel.favorAnswers
                                                .elementAt(index)
                                                .topic
                                                .text,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                            ),
                                          ),
                                          (viewModel.favorAnswers
                                                          .elementAt(index)
                                                          .topic
                                                          .imageUrl !=
                                                      null &&
                                                  viewModel.favorAnswers
                                                      .elementAt(index)
                                                      .topic
                                                      .imageUrl
                                                      .isNotEmpty)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 16, 0, 0),
                                                  child: CachedNetworkImage(
                                                    placeholder:
                                                        (context, url) =>
                                                            const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    imageUrl: viewModel
                                                        .favorAnswers
                                                        .elementAt(index)
                                                        .topic
                                                        .imageUrl,
                                                    errorWidget: (context, url,
                                                            dynamic error) =>
                                                        Image.asset(
                                                      'assets/icon/no_image.jpg',
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: viewModel.hasNextInFavor &&
                                      viewModel.favorAnswers.isNotEmpty
                                  ? viewModel.favorAnswers.length + 1
                                  : viewModel.favorAnswers.length,
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
      ),
    );
  }
}

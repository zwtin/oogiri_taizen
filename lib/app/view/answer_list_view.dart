import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:oogiri_taizen/app/view_model/answer_list_view_model.dart';
import 'package:oogiri_taizen/app/view_model/bottom_tab_view_model.dart';
import 'package:oogiri_taizen/app/notifer/router_notifer.dart';
import 'package:oogiri_taizen/app/widget/answer_card_widget.dart';
import 'package:oogiri_taizen/app/widget/fade_in_route.dart';
import 'package:oogiri_taizen/app/widget/floating_action_button_widget.dart';

class AnswerListView extends HookWidget {
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    debugPrint('AnswerListView = $_key');

    // bottomTabにGlobalKeyをセット
    useProvider(bottomTabViewModelProvider).setUniqueKey(index: 0, key: _key);
    final viewModel = useProvider(answerListViewModelProvider(_key));

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
              SystemNavigator.pop();
            }
            break;
          case TransitionType.popToRoot:
            Navigator.of(context).popUntil((route) => route.isFirst);
            break;
        }
      },
      provider: routerNotiferProvider(_key),
      child: FloatingActionButtonWidget(
        action1: () {},
        action2: () {},
        // action3: () {},
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'ホーム',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color(0xFFFFCC00),
              elevation: 0, // 影をなくす
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    text: '新着順',
                  ),
                  Tab(
                    text: '人気順',
                  )
                ],
              ),
            ),
            body: Stack(
              children: [
                Container(
                  color: const Color(0xFFFFCC00),
                ),
                TabBarView(
                  children: [
                    RefreshIndicator(
                      color: const Color(0xFFFFCC00),
                      onRefresh: () async {
                        return context
                            .read(answerListViewModelProvider(_key))
                            .resetNewAnswers();
                      },
                      child: SafeArea(
                        child: ListView.builder(
                          key: const PageStorageKey<String>('new'),
                          itemBuilder: (BuildContext context, int index) {
                            if (viewModel.hasNextInNew &&
                                index == viewModel.newAnswers.length - 3) {
                              context
                                  .read(answerListViewModelProvider(_key))
                                  .fetchNewAnswers();
                            }
                            if (index == viewModel.newAnswers.length) {
                              if (viewModel.hasNextInNew) {
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
                              userImageUrl: viewModel.newAnswers
                                  .elementAt(index)
                                  .createdUser
                                  .imageUrl,
                              onTapUserImage: () {
                                final viewModel = context.read(
                                  answerListViewModelProvider(_key),
                                );
                                viewModel.transitionToProfile(
                                  id: viewModel.newAnswers
                                      .elementAt(index)
                                      .createdUser
                                      .id,
                                );
                              },
                              createdTime: viewModel.newAnswers
                                  .elementAt(index)
                                  .createdAt,
                              userName: viewModel.newAnswers
                                  .elementAt(index)
                                  .createdUser
                                  .name,
                              menuList: viewModel.newAnswers
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
                                            answerListViewModelProvider(_key),
                                          );
                                          viewModel.addBlockAnswer(
                                            viewModel.newAnswers
                                                .elementAt(index),
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.block),
                                        title: const Text('このユーザーをブロックする'),
                                        onTap: () {
                                          final viewModel = context.read(
                                            answerListViewModelProvider(_key),
                                          );
                                          viewModel.addBlockUser(
                                            viewModel.newAnswers
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
                              text: viewModel.newAnswers
                                  .elementAt(index)
                                  .topic
                                  .text,
                              imageUrl: viewModel.newAnswers
                                  .elementAt(index)
                                  .topic
                                  .imageUrl,
                              imageTag: viewModel.newAnswers
                                  .elementAt(index)
                                  .topic
                                  .imageTag,
                              onTapImage: () {
                                final viewModel = context.read(
                                  answerListViewModelProvider(_key),
                                );
                                viewModel.transitionToImageDetail(
                                    imageUrl: viewModel.newAnswers
                                            .elementAt(index)
                                            .topic
                                            .imageUrl ??
                                        '',
                                    imageTag: viewModel.newAnswers
                                            .elementAt(index)
                                            .topic
                                            .imageTag ??
                                        '');
                              },
                              isLike:
                                  viewModel.newAnswers.elementAt(index).isLike,
                              onTapLikeButton: () async {
                                final viewModel = context.read(
                                  answerListViewModelProvider(_key),
                                );
                                await viewModel.likeAnswer(
                                  viewModel.newAnswers.elementAt(index),
                                );
                              },
                              likedTime: viewModel.newAnswers
                                  .elementAt(index)
                                  .likedTime,
                              isFavor:
                                  viewModel.newAnswers.elementAt(index).isFavor,
                              onTapFavorButton: () async {
                                final viewModel = context.read(
                                  answerListViewModelProvider(_key),
                                );
                                await viewModel.favorAnswer(
                                  viewModel.newAnswers.elementAt(index),
                                );
                              },
                              favoredTime: viewModel.newAnswers
                                  .elementAt(index)
                                  .favoredTime,
                              onTap: () async {
                                final viewModel = context.read(
                                  answerListViewModelProvider(_key),
                                );
                                await viewModel.transitionToAnswerDetail(
                                  id: viewModel.newAnswers.elementAt(index).id,
                                );
                              },
                            );
                          },
                          itemCount: viewModel.newAnswers.isEmpty ||
                                  viewModel.hasNextInNew
                              ? viewModel.newAnswers.length + 1
                              : viewModel.newAnswers.length,
                        ),
                      ),
                    ),
                    Container(
                      color: const Color(0xFFFFCC00),
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

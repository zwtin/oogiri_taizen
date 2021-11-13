import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/widget/answer_card_widget.dart';
import 'package:oogiri_taizen/app/widget/topic_card_widget.dart';
import 'package:tuple/tuple.dart';

import 'package:oogiri_taizen/app/view_model/bottom_tab_view_model.dart';

import 'package:oogiri_taizen/app/view_model/answer_detail_view_model.dart';

import 'package:oogiri_taizen/app/widget/router_widget.dart';

class AnswerDetailView extends HookWidget {
  AnswerDetailView({required this.answerId});

  final _key = UniqueKey();
  final String answerId;

  @override
  Widget build(BuildContext context) {
    debugPrint('AnswerDetailView = $_key');

    final viewModel = useProvider(
      answerDetailViewModelProvider(
        Tuple2<UniqueKey, String>(_key, answerId),
      ),
    );

    return RouterWidget(
      key: _key,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'ボケ詳細',
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
              child: viewModel.answer == null
                  ? Container()
                  : SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TopicCardWidget(
                            userImageUrl:
                                viewModel.answer!.topic.createdUser.imageUrl,
                            onTapUserImage: () {
                              final viewModel = context.read(
                                answerDetailViewModelProvider(
                                  Tuple2<UniqueKey, String>(_key, answerId),
                                ),
                              );
                              viewModel.transitionToProfile(
                                id: viewModel.answer!.topic.createdUser.id,
                              );
                            },
                            createdTime: viewModel.answer!.topic.createdAt,
                            userName: viewModel.answer!.topic.createdUser.name,
                            menuList: viewModel.answer!.topic.isOwn
                                ? []
                                : [
                                    ListTile(
                                      leading: const Icon(Icons.block),
                                      title: const Text('このお題をブロックする'),
                                      onTap: () {
                                        final viewModel = context.read(
                                          answerDetailViewModelProvider(
                                            Tuple2<UniqueKey, String>(
                                                _key, answerId),
                                          ),
                                        );
                                        viewModel.addBlockTopic(
                                          viewModel.answer!.topic,
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.block),
                                      title: const Text('このユーザーをブロックする'),
                                      onTap: () {
                                        final viewModel = context.read(
                                          answerDetailViewModelProvider(
                                            Tuple2<UniqueKey, String>(
                                                _key, answerId),
                                          ),
                                        );
                                        viewModel.addBlockUser(
                                          viewModel.answer!.topic.createdUser,
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.report),
                                      title: const Text('このユーザーを通報する'),
                                      onTap: () {},
                                    ),
                                  ],
                            text: viewModel.answer!.topic.text,
                            imageUrl: viewModel.answer!.topic.imageUrl,
                            imageTag: viewModel.answer!.topic.imageTag,
                            onTapImage: () {
                              final viewModel = context.read(
                                answerDetailViewModelProvider(
                                  Tuple2<UniqueKey, String>(_key, answerId),
                                ),
                              );
                              viewModel.transitionToImageDetail(
                                imageUrl:
                                    viewModel.answer!.topic.imageUrl ?? '',
                                imageTag:
                                    viewModel.answer!.topic.imageTag ?? '',
                              );
                            },
                            onTap: () {
                              // context
                              //     .read(answerListViewModelProvider(_key))
                              //     .transitionToAnswerDetail(
                              //   id: context
                              //       .read(answerListViewModelProvider(_key))
                              //       .newAnswers
                              //       .elementAt(index)
                              //       .id,
                              // );
                            },
                          ),
                          AnswerCardWidget(
                            userImageUrl:
                                viewModel.answer!.createdUser.imageUrl,
                            onTapUserImage: () {
                              final viewModel = context.read(
                                answerDetailViewModelProvider(
                                  Tuple2<UniqueKey, String>(_key, answerId),
                                ),
                              );
                              viewModel.transitionToProfile(
                                id: viewModel.answer!.createdUser.id,
                              );
                            },
                            createdTime: viewModel.answer!.createdAt,
                            userName: viewModel.answer!.createdUser.name,
                            menuList: viewModel.answer!.isOwn
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
                                          answerDetailViewModelProvider(
                                            Tuple2<UniqueKey, String>(
                                                _key, answerId),
                                          ),
                                        );
                                        viewModel.addBlockAnswer(
                                          viewModel.answer!,
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.block),
                                      title: const Text('このユーザーをブロックする'),
                                      onTap: () {
                                        final viewModel = context.read(
                                          answerDetailViewModelProvider(
                                            Tuple2<UniqueKey, String>(
                                                _key, answerId),
                                          ),
                                        );
                                        viewModel.addBlockUser(
                                          viewModel.answer!.createdUser,
                                        );
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.report),
                                      title: const Text('このユーザーを通報する'),
                                      onTap: () {},
                                    ),
                                  ],
                            text: viewModel.answer!.text,
                            isLike: viewModel.answer!.isLike,
                            onTapLikeButton: () async {
                              final viewModel = context.read(
                                answerDetailViewModelProvider(
                                  Tuple2<UniqueKey, String>(_key, answerId),
                                ),
                              );
                              await viewModel.likeAnswer();
                            },
                            likedTime: viewModel.answer!.likedTime,
                            isFavor: viewModel.answer!.isFavor,
                            onTapFavorButton: () async {
                              final viewModel = context.read(
                                answerDetailViewModelProvider(
                                  Tuple2<UniqueKey, String>(_key, answerId),
                                ),
                              );
                              await viewModel.favorAnswer();
                            },
                            favoredTime: viewModel.answer!.favoredTime,
                            onTap: () {
                              // context
                              //     .read(answerListViewModelProvider(_key))
                              //     .transitionToAnswerDetail(
                              //   id: context
                              //       .read(answerListViewModelProvider(_key))
                              //       .newAnswers
                              //       .elementAt(index)
                              //       .id,
                              // );
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

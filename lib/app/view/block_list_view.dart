import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/view_model/block_list_view_model.dart';
import 'package:oogiri_taizen/app/widget/answer_card_widget.dart';
import 'package:oogiri_taizen/app/widget/router_widget.dart';
import 'package:oogiri_taizen/app/widget/topic_card_widget.dart';
import 'package:oogiri_taizen/app/widget/user_card_widget.dart';

class BlockListView extends HookWidget {
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    debugPrint('BlockListView = $_key');
    final viewModel = useProvider(blockListViewModelProvider(_key));

    return RouterWidget(
      key: _key,
      child: DefaultTabController(
        initialIndex: 0,
        length: 3,
        child: Scaffold(
          // ナビゲーションバー
          appBar: AppBar(
            title: const Text(
              'ブロック一覧',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: const Color(0xFFFFCC00),
            elevation: 0, // 影をなくす
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'ボケ',
                ),
                Tab(
                  text: 'お題',
                ),
                Tab(
                  text: 'ユーザー',
                ),
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
                          .read(blockListViewModelProvider(_key))
                          .resetBlockAnswers();
                    },
                    child: SafeArea(
                      child: ListView.builder(
                        key: PageStorageKey<String>('blockAnswer_$_key'),
                        itemBuilder: (BuildContext context, int index) {
                          if (viewModel.hasNextInAnswer &&
                              index == viewModel.blockAnswers.length - 3) {
                            context
                                .read(blockListViewModelProvider(_key))
                                .fetchBlockAnswers();
                          }
                          if (index == viewModel.blockAnswers.length) {
                            if (viewModel.hasNextInAnswer) {
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
                            userImageUrl: viewModel.blockAnswers
                                .elementAt(index)
                                .createdUser
                                .imageUrl,
                            createdTime: viewModel.blockAnswers
                                .elementAt(index)
                                .createdAt,
                            userName: viewModel.blockAnswers
                                .elementAt(index)
                                .createdUser
                                .name,
                            text: viewModel.blockAnswers.elementAt(index).text,
                            onTap: () async {
                              final viewModel = context.read(
                                blockListViewModelProvider(_key),
                              );
                              await viewModel.removeBlockAnswer(
                                viewModel.blockAnswers.elementAt(index),
                              );
                            },
                          );
                        },
                        itemCount: viewModel.blockAnswers.isEmpty ||
                                viewModel.hasNextInAnswer
                            ? viewModel.blockAnswers.length + 1
                            : viewModel.blockAnswers.length,
                      ),
                    ),
                  ),
                  RefreshIndicator(
                    color: const Color(0xFFFFCC00),
                    onRefresh: () async {
                      return context
                          .read(blockListViewModelProvider(_key))
                          .resetBlockTopics();
                    },
                    child: SafeArea(
                      child: ListView.builder(
                        key: PageStorageKey<String>('blockTopic_$_key'),
                        itemBuilder: (BuildContext context, int index) {
                          if (viewModel.hasNextInTopic &&
                              index == viewModel.blockTopics.length - 3) {
                            context
                                .read(blockListViewModelProvider(_key))
                                .fetchBlockTopics();
                          }
                          if (index == viewModel.blockTopics.length) {
                            if (viewModel.hasNextInTopic) {
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
                                    '表示できるお題がありません',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                          return TopicCardWidget(
                            userImageUrl: viewModel.blockTopics
                                .elementAt(index)
                                .createdUser
                                .imageUrl,
                            createdTime: viewModel.blockTopics
                                .elementAt(index)
                                .createdAt,
                            userName: viewModel.blockTopics
                                .elementAt(index)
                                .createdUser
                                .name,
                            text: viewModel.blockTopics.elementAt(index).text,
                            onTap: () async {
                              final viewModel = context.read(
                                blockListViewModelProvider(_key),
                              );
                              await viewModel.removeBlockTopic(
                                viewModel.blockTopics.elementAt(index),
                              );
                            },
                          );
                        },
                        itemCount: viewModel.blockTopics.isEmpty ||
                                viewModel.hasNextInTopic
                            ? viewModel.blockTopics.length + 1
                            : viewModel.blockTopics.length,
                      ),
                    ),
                  ),
                  RefreshIndicator(
                    color: const Color(0xFFFFCC00),
                    onRefresh: () async {
                      return context
                          .read(blockListViewModelProvider(_key))
                          .resetBlockUsers();
                    },
                    child: SafeArea(
                      child: ListView.builder(
                        key: PageStorageKey<String>('blockUser_$_key'),
                        itemBuilder: (BuildContext context, int index) {
                          if (viewModel.hasNextInUser &&
                              index == viewModel.blockUsers.length - 3) {
                            context
                                .read(blockListViewModelProvider(_key))
                                .fetchBlockUsers();
                          }
                          if (index == viewModel.blockUsers.length) {
                            if (viewModel.hasNextInUser) {
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
                                    '表示できるユーザーがありません',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                          return UserCardWidget(
                            userImageUrl:
                                viewModel.blockUsers.elementAt(index).imageUrl,
                            userName: viewModel.blockAnswers
                                .elementAt(index)
                                .createdUser
                                .name,
                            onTap: () async {
                              final viewModel = context.read(
                                blockListViewModelProvider(_key),
                              );
                              await viewModel.removeBlockUser(
                                viewModel.blockUsers.elementAt(index),
                              );
                            },
                          );
                        },
                        itemCount: viewModel.blockUsers.isEmpty ||
                                viewModel.hasNextInUser
                            ? viewModel.blockUsers.length + 1
                            : viewModel.blockUsers.length,
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
  }
}

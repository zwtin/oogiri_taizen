import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/view_model/answer_detail_view_model.dart';
import 'package:oogiri_taizen/app/widget/answer_detail_answer_card_widget.dart';
import 'package:oogiri_taizen/app/widget/answer_detail_topic_card_widget.dart';
import 'package:oogiri_taizen/app/widget/router_widget.dart';
import 'package:tuple/tuple.dart';

class AnswerDetailView extends HookWidget {
  AnswerDetailView({required this.answerId});

  final _key = UniqueKey();
  final _logger = Logger();
  final String answerId;

  @override
  Widget build(BuildContext context) {
    _logger.d('AnswerDetailView = $_key');

    final viewModel = useProvider(
      answerDetailViewModelProvider(
        Tuple2<UniqueKey, String>(_key, answerId),
      ),
    );

    useEffect(
      () {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          context
              .read(answerDetailViewModelProvider(
                Tuple2<UniqueKey, String>(_key, answerId),
              ))
              .fetchAnswerDetail();
        });
      },
      const [],
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
              child: SafeArea(
                child: Column(
                  children: [
                    if (viewModel.topicViewData != null) ...{
                      AnswerDetailTopicCardWidget(
                        viewData: viewModel.topicViewData!,
                        menuList: viewModel.topicViewData!.userId ==
                                viewModel.loginUserId
                            ? []
                            : [
                                ListTile(
                                  leading: const Icon(Icons.block),
                                  title: const Text('このお題をブロックする'),
                                  onTap: () async {
                                    await context
                                        .read(answerDetailViewModelProvider(
                                          Tuple2<UniqueKey, String>(
                                              _key, answerId),
                                        ))
                                        .addBlockTopic();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.block),
                                  title: const Text('このユーザーをブロックする'),
                                  onTap: () async {
                                    await context
                                        .read(answerDetailViewModelProvider(
                                          Tuple2<UniqueKey, String>(
                                              _key, answerId),
                                        ))
                                        .addBlockTopicUser();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.report),
                                  title: const Text('このユーザーを通報する'),
                                  onTap: () {},
                                ),
                              ],
                      ),
                    },
                    if (viewModel.answerViewData != null) ...{
                      AnswerDetailAnswerCardWidget(
                        viewData: viewModel.answerViewData!,
                        menuList: viewModel.answerViewData!.userId ==
                                viewModel.loginUserId
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
                                  onTap: () async {
                                    await context
                                        .read(answerDetailViewModelProvider(
                                          Tuple2<UniqueKey, String>(
                                              _key, answerId),
                                        ))
                                        .addBlockAnswer();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.block),
                                  title: const Text('このユーザーをブロックする'),
                                  onTap: () async {
                                    await context
                                        .read(answerDetailViewModelProvider(
                                          Tuple2<UniqueKey, String>(
                                              _key, answerId),
                                        ))
                                        .addBlockAnswerUser();
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.report),
                                  title: const Text('このユーザーを通報する'),
                                  onTap: () {},
                                ),
                              ],
                        onTapLikeButton: () async {
                          await context
                              .read(answerDetailViewModelProvider(
                                Tuple2<UniqueKey, String>(_key, answerId),
                              ))
                              .likeAnswer();
                        },
                        onTapFavorButton: () async {
                          await context
                              .read(answerDetailViewModelProvider(
                                Tuple2<UniqueKey, String>(_key, answerId),
                              ))
                              .favorAnswer();
                        },
                      ),
                    },
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

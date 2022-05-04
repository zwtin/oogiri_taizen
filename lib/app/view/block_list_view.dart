import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiri_taizen/app/view/block_answer_list_view.dart';
import 'package:oogiri_taizen/app/view/block_topic_list_view.dart';
import 'package:oogiri_taizen/app/view/block_user_list_view.dart';
import 'package:oogiri_taizen/app/view_model/block_list_view_model.dart';
import 'package:oogiri_taizen/app/widget/router_widget.dart';

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
                  BlockAnswerListView(),
                  BlockTopicListView(),
                  BlockUserListView(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

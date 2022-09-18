import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/view_model/my_favor_answer_list_view_model.dart';
import 'package:oogiri_taizen/app/widget/answer_list_card_widget.dart';
import 'package:oogiri_taizen/app/widget/router_widget.dart';
import 'package:oogiri_taizen/extension/flutter_hooks_extension.dart';

class MyFavorAnswerListView extends HookWidget {
  final _key = UniqueKey();
  final _logger = Logger();

  @override
  Widget build(BuildContext context) {
    _logger.d('MyFavorAnswerListView = $_key');
    final viewModel = useProvider(myFavorAnswerListViewModelProvider(_key));
    useAutomaticKeepAlive();

    return RouterWidget(
      key: _key,
      child: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFFFFCC00),
          onRefresh: () async {
            return context
                .read(myFavorAnswerListViewModelProvider(_key))
                .resetAnswers();
          },
          child: ListView.builder(
            key: const PageStorageKey<String>('MyFavorAnswerListView'),
            itemBuilder: (context, index) {
              if (viewModel.hasNext &&
                  index == viewModel.answerViewData.length - 3) {
                context
                    .read(myFavorAnswerListViewModelProvider(_key))
                    .fetchAnswers();
              }
              if (index == viewModel.answerViewData.length) {
                if (viewModel.hasNext) {
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
              final viewData = viewModel.answerViewData.elementAt(index);
              return AnswerListCardWidget(
                viewData: viewData,
                onTapImage: () {
                  context
                      .read(myFavorAnswerListViewModelProvider(_key))
                      .transitionToImageDetail(
                        imageUrl: viewData.imageUrl ?? '',
                        imageTag: viewData.imageTag ?? '',
                      );
                },
              );
            },
            itemCount: viewModel.answerViewData.isEmpty || viewModel.hasNext
                ? viewModel.answerViewData.length + 1
                : viewModel.answerViewData.length,
          ),
        ),
      ),
    );
  }
}

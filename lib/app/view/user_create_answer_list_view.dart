import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/view_model/user_create_answer_list_view_model.dart';
import 'package:oogiri_taizen/app/widget/answer_list_card_widget.dart';
import 'package:tuple/tuple.dart';

class UserCreateAnswerListView extends HookWidget {
  UserCreateAnswerListView({required this.userId});

  final _key = UniqueKey();
  final _logger = Logger();
  final String userId;

  @override
  Widget build(BuildContext context) {
    _logger.d('UserCreateAnswerListView = $_key');
    final viewModel = useProvider(
      userCreateAnswerListViewModelProvider(
        Tuple2(_key, userId),
      ),
    );

    return RefreshIndicator(
      color: const Color(0xFFFFCC00),
      onRefresh: () async {
        return context
            .read(
              userCreateAnswerListViewModelProvider(
                Tuple2(_key, userId),
              ),
            )
            .resetAnswers();
      },
      child: SafeArea(
        child: ListView.builder(
          key: PageStorageKey<String>('UserCreateAnswerListView_$_key'),
          itemBuilder: (context, index) {
            if (viewModel.hasNext &&
                index == viewModel.answerViewData.length - 3) {
              context
                  .read(
                    userCreateAnswerListViewModelProvider(
                      Tuple2(_key, userId),
                    ),
                  )
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
                    .read(
                      userCreateAnswerListViewModelProvider(
                        Tuple2(_key, userId),
                      ),
                    )
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
    );
  }
}

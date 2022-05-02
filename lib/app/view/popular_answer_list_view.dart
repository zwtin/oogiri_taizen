import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:oogiri_taizen/app/view_model/popular_answer_list_view_model.dart';

class PopularAnswerListView extends HookWidget {
  final _key = UniqueKey();
  final _logger = Logger();

  @override
  Widget build(BuildContext context) {
    _logger.d('PopularAnswerListView = $_key');
    final viewModel = useProvider(popularAnswerListViewModelProvider(_key));

    return RefreshIndicator(
      color: const Color(0xFFFFCC00),
      onRefresh: () async {
        return context
            .read(popularAnswerListViewModelProvider(_key))
            .resetAnswers();
      },
      child: SafeArea(
        child: ListView.builder(
          key: const PageStorageKey<String>('popular'),
          itemBuilder: (context, index) {
            if (viewModel.hasNext &&
                index == viewModel.answerViewData.length - 3) {
              context
                  .read(popularAnswerListViewModelProvider(_key))
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
            return AnswerCardWidget(
              userImageUrl:
                  viewModel.newAnswers.elementAt(index).createdUser.imageUrl,
              onTapUserImage: () {
                final viewModel = context.read(
                  answerListViewModelProvider(_key),
                );
                viewModel.transitionToProfile(
                  id: viewModel.newAnswers.elementAt(index).createdUser.id,
                );
              },
              createdTime: viewModel.newAnswers.elementAt(index).createdAt,
              userName: viewModel.newAnswers.elementAt(index).createdUser.name,
              menuList: viewModel.newAnswers.elementAt(index).isOwn
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
                            viewModel.newAnswers.elementAt(index),
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
                            viewModel.newAnswers.elementAt(index).createdUser,
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.report),
                        title: const Text('このユーザーを通報する'),
                        onTap: () {},
                      ),
                    ],
              text: viewModel.newAnswers.elementAt(index).topic.text,
              imageUrl: viewModel.newAnswers.elementAt(index).topic.imageUrl,
              imageTag: viewModel.newAnswers.elementAt(index).topic.imageTag,
              onTapImage: () {
                final viewModel = context.read(
                  answerListViewModelProvider(_key),
                );
                viewModel.transitionToImageDetail(
                    imageUrl:
                        viewModel.newAnswers.elementAt(index).topic.imageUrl ??
                            '',
                    imageTag:
                        viewModel.newAnswers.elementAt(index).topic.imageTag ??
                            '');
              },
              isLike: viewModel.newAnswers.elementAt(index).isLike,
              onTapLikeButton: () async {
                final viewModel = context.read(
                  answerListViewModelProvider(_key),
                );
                await viewModel.likeAnswer(
                  viewModel.newAnswers.elementAt(index),
                );
              },
              likedTime: viewModel.newAnswers.elementAt(index).likedTime,
              isFavor: viewModel.newAnswers.elementAt(index).isFavor,
              onTapFavorButton: () async {
                final viewModel = context.read(
                  answerListViewModelProvider(_key),
                );
                await viewModel.favorAnswer(
                  viewModel.newAnswers.elementAt(index),
                );
              },
              favoredTime: viewModel.newAnswers.elementAt(index).favoredTime,
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
          itemCount: viewModel.answerViewData.isEmpty || viewModel.hasNext
              ? viewModel.answerViewData.length + 1
              : viewModel.answerViewData.length,
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/ui/answer_detail/answer_detail_view_model.dart';
import 'package:oogiritaizen/ui/image_detail/fade_in_route.dart';
import 'package:sweetalert/sweetalert.dart';

import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/model/extension/int_extension.dart';
import 'package:oogiritaizen/model/extension/date_time_extension.dart';

class AnswerDetailView extends HookWidget {
  const AnswerDetailView(this.parameter);

  final AnswerDetailViewModelParameter parameter;

  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(
      answerDetailViewModelProvider(
        parameter,
      ),
    );

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
          switch (navigatorViewModel.transitionType) {
            case TransitionType.push:
              Navigator.of(context).push(
                MaterialPageRoute<Widget>(
                  builder: (BuildContext context) {
                    return navigatorViewModel.nextWidget;
                  },
                ),
              );
              break;
            case TransitionType.present:
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute<Widget>(
                  builder: (BuildContext context) {
                    return navigatorViewModel.nextWidget;
                  },
                  fullscreenDialog: true,
                ),
              );
              break;
            case TransitionType.image:
              Navigator.of(context, rootNavigator: true).push(
                FadeInRoute(
                  widget: navigatorViewModel.nextWidget,
                  opaque: false,
                ),
              );
              break;
            case TransitionType.pop:
              Navigator.of(context).pop();
              break;
            case TransitionType.popToRoot:
              Navigator.of(context).popUntil((route) => route.isFirst);
              break;
          }
        },
        provider: navigatorViewModelProvider(parameter.screenId),
        child: Scaffold(
          // ナビゲーションバー
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
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    imageUrl: viewModel
                                        .answer.topic.createdUser.imageUrl,
                                    imageBuilder: (context, imageProvider) =>
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
                                      'assets/images/no_user.jpg',
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        viewModel.answer.topic.createdAt
                                            .toJPString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Container(
                                              child: Text(
                                                viewModel.answer.topic
                                                    .createdUser.name,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: const Text(
                                              ' のお題：',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.menu),
                                  onPressed: () {
                                    showModalBottomSheet<int>(
                                      context: context,
                                      builder: (BuildContext _context) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 8, 0, 8),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.block),
                                                title:
                                                    const Text('この投稿をブロックする'),
                                                onTap: () {
                                                  viewModel.addBlockTopic(
                                                    topicId: viewModel
                                                        .answer.topic.id,
                                                  );
                                                  Navigator.of(_context).pop();
                                                },
                                              ),
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.block),
                                                title: const Text(
                                                    'このユーザーの投稿を全てブロックする'),
                                                onTap: () {
                                                  viewModel.addBlockUser(
                                                    userId: viewModel.answer
                                                        .topic.createdUser.id,
                                                  );
                                                  Navigator.of(_context).pop();
                                                },
                                              ),
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.report),
                                                title:
                                                    const Text('このユーザーを通報する'),
                                                onTap: () {
                                                  Navigator.of(_context).pop();
//                                                  viewModel.signOut();
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
                            Container(
                              height: 16,
                            ),
                            Text(
                              viewModel.answer.topic.text,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            (viewModel.answer.topic.imageUrl != null &&
                                    viewModel.answer.topic.imageUrl.isNotEmpty)
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      imageUrl: viewModel.answer.topic.imageUrl,
                                      errorWidget:
                                          (context, url, dynamic error) =>
                                              Image.asset(
                                        'assets/images/no_image.jpg',
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: SizedBox(
                                    width: 44,
                                    height: 44,
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      imageUrl:
                                          viewModel.answer.createdUser.imageUrl,
                                      imageBuilder: (context, imageProvider) =>
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
                                Container(
                                  width: 16,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        viewModel.answer.createdAt.toJPString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Container(
                                              child: Text(
                                                viewModel
                                                    .answer.createdUser.name,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: const Text(
                                              ' のボケ：',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.menu),
                                  onPressed: () {
                                    showModalBottomSheet<int>(
                                      context: context,
                                      builder: (BuildContext _context) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 8, 0, 8),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.block),
                                                title:
                                                    const Text('この投稿をブロックする'),
                                                onTap: () {
                                                  viewModel.addBlockAnswer(
                                                    answerId:
                                                        viewModel.answer.id,
                                                  );
                                                  Navigator.of(_context).pop();
                                                },
                                              ),
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.block),
                                                title: const Text(
                                                    'このユーザーの投稿を全てブロックする'),
                                                onTap: () {
                                                  viewModel.addBlockUser(
                                                    userId: viewModel
                                                        .answer.createdUser.id,
                                                  );
                                                  Navigator.of(_context).pop();
                                                },
                                              ),
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.report),
                                                title:
                                                    const Text('このユーザーを通報する'),
                                                onTap: () {
                                                  Navigator.of(_context).pop();
//                                                  viewModel.signOut();
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
                            Container(
                              height: 16,
                            ),
                            Text(
                              viewModel.answer.text,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      IconButton(
//                                        icon: viewModel.answer.isLike
//                                            ? const Icon(
//                                                Icons.favorite,
//                                                color: Colors.pink,
//                                              )
//                                            : const Icon(
//                                                Icons.favorite_outline,
//                                                color: Colors.pink,
//                                              ),
                                        icon: const Icon(
                                          Icons.favorite_outline,
                                          color: Colors.pink,
                                        ),
                                        onPressed: () {
                                          context
                                              .read(
                                                  answerDetailViewModelProvider(
                                                      parameter))
                                              .likeButtonAction();
                                        },
                                      ),
                                      Text(
                                        viewModel.answer.likedTime
                                            .toStringOverTenThousand(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      IconButton(
//                                        icon: viewModel.answer.isFavor
//                                            ? const Icon(
//                                                Icons.star,
//                                                color: Colors.cyan,
//                                              )
//                                            : const Icon(
//                                                Icons.star_outline,
//                                                color: Colors.cyan,
//                                              ),
                                        icon: const Icon(
                                          Icons.star_outline,
                                          color: Colors.cyan,
                                        ),
                                        onPressed: () {
                                          context
                                              .read(
                                                  answerDetailViewModelProvider(
                                                      parameter))
                                              .favorButtonAction();
                                        },
                                      ),
                                      Text(
                                        viewModel.answer.favoredTime
                                            .toStringOverTenThousand(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

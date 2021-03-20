import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/ui/post_answer/post_answer_view_model.dart';
import 'package:oogiritaizen/ui/post_topic/post_topic_view_model.dart';
import 'package:oogiritaizen/ui/topic_list/topic_list_view_model.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:oogiritaizen/model/extension/string_extension.dart';

class TopicListView extends HookWidget {
  const TopicListView(this.parameter);

  final TopicListViewModelParameter parameter;

  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(topicListViewModelProvider(parameter));

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
            Navigator.of(context).pop();
          }
        },
        provider: navigatorViewModelProvider(parameter.screenId),
        child: Scaffold(
          // ナビゲーションバー
          appBar: AppBar(
            title: const Text(
              'お題選択',
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
              RefreshIndicator(
                color: const Color(0xFFFFCC00),
                onRefresh: () async {
                  await context
                      .read(topicListViewModelProvider(parameter))
                      .refresh();
                },
                child: ListView.builder(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == viewModel.items.length - 3) {
                      viewModel.getNewTopicList();
                    }
                    if (index == viewModel.items.length) {
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
                            .read(topicListViewModelProvider(parameter))
                            .transitionToPostAnswer(
                                topicId: viewModel.items.elementAt(index).id);
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
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
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      imageUrl: viewModel.items
                                          .elementAt(index)
                                          .createdUser
                                          .imageUrl,
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
                                            viewModel.items
                                                .elementAt(index)
                                                .createdAt,
                                          ),
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
                                                  viewModel.items
                                                      .elementAt(index)
                                                      .createdUser
                                                      .name,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                ],
                              ),
                              Container(
                                height: 16,
                              ),
                              Text(
                                viewModel.items.elementAt(index).text,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              (viewModel.items.elementAt(index).imageUrl !=
                                          null &&
                                      viewModel.items
                                          .elementAt(index)
                                          .imageUrl
                                          .isNotEmpty)
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 16, 0, 0),
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        imageUrl: viewModel.items
                                            .elementAt(index)
                                            .imageUrl,
                                        errorWidget:
                                            (context, url, dynamic error) =>
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
                  itemCount: viewModel.hasNext
                      ? viewModel.items.length + 1
                      : viewModel.items.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

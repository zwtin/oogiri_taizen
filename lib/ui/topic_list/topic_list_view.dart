import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:oogiritaizen/data/model/entity/user.dart';
import 'package:oogiritaizen/data/provider/alert_notifier.dart';
import 'package:oogiritaizen/data/provider/navigator_notifier.dart';
import 'package:oogiritaizen/ui/post_answer/post_answer_view_model.dart';
import 'package:oogiritaizen/ui/post_topic/post_topic_view_model.dart';
import 'package:oogiritaizen/ui/topic_list/topic_list_view_model.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:oogiritaizen/data/model/extension/string_extension.dart';

class TopicListView extends HookWidget {
  TopicListView(this.user);

  final User user;
  final id = StringExtension.randomString(8);

  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(topicListViewModelProvider(id));

    viewModel.user = user;

    return ProviderListener(
      onChange: (BuildContext context, AlertNotifier alertNotifier) {
        SweetAlert.show(
          context,
          title: alertNotifier.title,
          subtitle: alertNotifier.subtitle,
          showCancelButton: alertNotifier.showCancelButton,
          onPress: alertNotifier.onPress,
          style: alertNotifier.style,
        );
      },
      provider: alertNotifierProvider(id),
      child: ProviderListener(
        onChange: (BuildContext context, NavigatorNotifier navigator) {
          if (navigator.nextWidget != null) {
            Navigator.of(context, rootNavigator: navigator.fullScreen).push(
              MaterialPageRoute<Widget>(
                builder: (BuildContext context) {
                  return navigator.nextWidget;
                },
                fullscreenDialog: navigator.fullScreen,
              ),
            );
          } else if (navigator.toRoot) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            Navigator.of(context).pop();
          }
        },
        provider: navigatorNotifierProvider(id),
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
                  await viewModel.refreshNewTopicList();
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
                    return Card(
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
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    imageUrl: viewModel.items
                                        .elementAt(index)
                                        .createdUserImageUrl,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        StringExtension.getJPStringFromDateTime(
                                          viewModel.items
                                              .elementAt(index)
                                              .topicCreatedAt,
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
                                                    .createdUserName,
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
                              ],
                            ),
                            Container(
                              height: 16,
                            ),
                            Text(
                              viewModel.items.elementAt(index).topicText,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                            (viewModel.items.elementAt(index).topicImageUrl !=
                                        null &&
                                    viewModel.items
                                        .elementAt(index)
                                        .topicImageUrl
                                        .isNotEmpty)
                                ? Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 16, 0, 0),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      imageUrl: viewModel.items
                                          .elementAt(index)
                                          .topicImageUrl,
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

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
                        child: Text(
                          '$index',
                          style: TextStyle(fontSize: 22.0),
                        ),
                        padding: EdgeInsets.all(20.0),
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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/ui/image_detail/fade_in_route.dart';
import 'package:sweetalert/sweetalert.dart';

import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/block_list/block_list_view_model.dart';

class BlockListView extends HookWidget {
  const BlockListView(this.parameter);

  final BlockListViewModelParameter parameter;

  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(blockListViewModelProvider(parameter));

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
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                SystemNavigator.pop();
              }
              break;
            case TransitionType.popToRoot:
              Navigator.of(context).popUntil((route) => route.isFirst);
              break;
          }
        },
        provider: navigatorViewModelProvider(parameter.screenId),
        child: DefaultTabController(
          // ?????????
          length: 3,

          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                '??????????????????',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color(0xFFFFCC00),
              elevation: 0, // ???????????????
              bottom: const TabBar(
                tabs: <Widget>[
                  Tab(
                    text: '??????',
                  ),
                  Tab(
                    text: '??????',
                  ),
                  Tab(
                    text: '????????????',
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
                    ListView.builder(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            viewModel.removeBlockTopic(
                                topicId:
                                    viewModel.blockTopics.elementAt(index).id);
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                  viewModel.blockTopics.elementAt(index).id),
                            ),
                          ),
                        );
                      },
                      itemCount: viewModel.blockTopics.length,
                    ),
                    ListView.builder(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            viewModel.removeBlockAnswer(
                                answerId:
                                    viewModel.blockAnswers.elementAt(index).id);
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                  viewModel.blockAnswers.elementAt(index).id),
                            ),
                          ),
                        );
                      },
                      itemCount: viewModel.blockAnswers.length,
                    ),
                    ListView.builder(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            viewModel.removeBlockUser(
                                userId:
                                    viewModel.blockUsers.elementAt(index).id);
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Text(
                                  viewModel.blockUsers.elementAt(index).id),
                            ),
                          ),
                        );
                      },
                      itemCount: viewModel.blockUsers.length,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/ui/image_detail/fade_in_route.dart';
import 'package:oogiritaizen/ui/post_topic/post_topic_view_model.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:oogiritaizen/model/extension/string_extension.dart';

class PostTopicView extends HookWidget {
  const PostTopicView(this.parameter);

  final PostTopicViewModelParameter parameter;

  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(postTopicViewModelProvider(parameter));
    final topicTextController = useTextEditingController();

    topicTextController.addListener(
      () {
        viewModel.editedTopic.text = topicTextController.text;
      },
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
        child: LoadingOverlay(
          isLoading: viewModel.isConnecting,
          color: Colors.grey,
          child: Scaffold(
            // ナビゲーションバー
            appBar: AppBar(
              title: const Text(
                'お題投稿',
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
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                  ),
                  onPressed: () {
                    context
                        .read(postTopicViewModelProvider(parameter))
                        .postTopic();
                  },
                ),
              ],
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
                                        imageUrl: viewModel.loginUser.imageUrl,
                                        imageBuilder:
                                            (context, imageProvider) =>
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          StringExtension
                                              .getJPStringFromDateTime(
                                            DateTime.now(),
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
                                                  viewModel.loginUser.name,
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
                              TextField(
                                maxLines: null,
                                controller: topicTextController,
                                autofocus: true,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                                decoration: const InputDecoration.collapsed(
                                  border: InputBorder.none,
                                  hintText: '例）こんな〇〇はいやだ',
                                ),
                              ),
                              Container(
                                height: 16,
                              ),
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read(
                                          postTopicViewModelProvider(parameter))
                                      .getImage();
                                },
                                child: viewModel.imageFile != null
                                    ? Image.file(
                                        viewModel.imageFile,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/images/no_image.jpg',
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      ),
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
      ),
    );
  }
}

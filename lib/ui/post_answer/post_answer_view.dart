import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:sweetalert/sweetalert.dart';

import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/ui/post_answer/post_answer_view_model.dart';
import 'package:oogiritaizen/model/extension/string_extension.dart';

class PostAnswerView extends HookWidget {
  const PostAnswerView(this.parameter);

  final PostAnswerViewModelParameter parameter;

  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(postAnswerViewModelProvider(parameter));
    final answerTextController = useTextEditingController();

    answerTextController.addListener(
      () {
        viewModel.editedAnswer.text = answerTextController.text;
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
        child: LoadingOverlay(
          isLoading: viewModel.isConnecting,
          color: Colors.grey,
          child: Scaffold(
            // ナビゲーションバー
            appBar: AppBar(
              title: const Text(
                'ボケ投稿',
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
                        .read(postAnswerViewModelProvider(parameter))
                        .postAnswer();
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
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 44,
                                    height: 44,
                                    child: (viewModel.topic.createdUser
                                                    ?.imageUrl !=
                                                null &&
                                            viewModel.topic.createdUser.imageUrl
                                                .isNotEmpty)
                                        ? CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            imageUrl: viewModel
                                                .topic.createdUser.imageUrl,
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
                                              'assets/images/no_user.jpg',
                                            ),
                                          )
                                        : Image.asset(
                                            'assets/images/no_user.jpg',
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
                                            viewModel.topic.createdAt ??
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
                                                  viewModel.topic.createdUser
                                                          ?.name ??
                                                      '',
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
                                viewModel.topic.text ?? '',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              (viewModel.topic?.imageUrl != null &&
                                      viewModel.topic.imageUrl.isNotEmpty)
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 16, 0, 0),
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        imageUrl:
                                            viewModel.topic.imageUrl ?? '',
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
                                ],
                              ),
                              Container(
                                height: 16,
                              ),
                              TextField(
                                maxLines: null,
                                controller: answerTextController,
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

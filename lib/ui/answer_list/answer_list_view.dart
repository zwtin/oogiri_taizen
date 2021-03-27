import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/ui/bottom_tab/navigator_view_model.dart';
import 'package:oogiritaizen/ui/image_detail/fade_in_route.dart';
import 'package:sweetalert/sweetalert.dart';

import 'package:oogiritaizen/ui/alert/alert_view_model.dart';
import 'package:oogiritaizen/ui/answer_list/answer_list_view_model.dart';
import 'package:oogiritaizen/ui/circular_button.dart';
import 'package:oogiritaizen/model/extension/string_extension.dart';
import 'package:oogiritaizen/model/extension/int_extension.dart';
import 'package:oogiritaizen/model/extension/date_time_extension.dart';

class AnswerListView extends HookWidget {
  const AnswerListView(this.parameter);

  final AnswerListViewModelParameter parameter;

  double getRadiansFromDegree(double degree) {
    const unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(answerListViewModelProvider(parameter));

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 250),
    );

    const beginPositionValue1 = 0.0;
    const peekPositionValue1 = 1.2;
    const endPositionValue1 = 1.0;
    const beginWeight1 = 75.0;
    const endWeight1 = 25.0;
    final degOneTransitionAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: beginPositionValue1,
          end: peekPositionValue1,
        ),
        weight: beginWeight1,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: peekPositionValue1,
          end: endPositionValue1,
        ),
        weight: endWeight1,
      ),
    ]).animate(controller);

    const beginPositionValue2 = 0.0;
    const peekPositionValue2 = 1.4;
    const endPositionValue2 = 1.0;
    const beginWeight2 = 55.0;
    const endWeight2 = 45.0;
    final degTwoTransitionAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: beginPositionValue2,
          end: peekPositionValue2,
        ),
        weight: beginWeight2,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: peekPositionValue2,
          end: endPositionValue2,
        ),
        weight: endWeight2,
      ),
    ]).animate(controller);

    const beginPositionValue3 = 0.0;
    const peekPositionValue3 = 1.75;
    const endPositionValue3 = 1.0;
    const beginWeight3 = 35.0;
    const endWeight3 = 65.0;
    final degThreeTransitionAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: beginPositionValue3,
          end: peekPositionValue3,
        ),
        weight: beginWeight3,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: peekPositionValue3,
          end: endPositionValue3,
        ),
        weight: endWeight3,
      ),
    ]).animate(controller);

    const beginRotationValue = 180.0;
    const endRotationValue = 0.0;
    final rotationAnimation =
        Tween(begin: beginRotationValue, end: endRotationValue)
            .animate(controller);

    const beginRotationValue2 = 0.0;
    const endRotationValue2 = -45.0;
    final rotationAnimation2 =
        Tween(begin: beginRotationValue2, end: endRotationValue2)
            .animate(controller);

    const backgroundColorOpacityStartValue = 0.0;
    const backgroundColorOpacityEndValue = 0.5;
    final backgroundColorOpacityAnimation = Tween(
      begin: backgroundColorOpacityStartValue,
      end: backgroundColorOpacityEndValue,
    ).animate(controller);

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
        provider: navigatorViewModelProvider('Tab0'),
        child: Stack(
          children: [
            DefaultTabController(
              // タブ数
              length: 2,

              child: Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'ホーム',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: const Color(0xFFFFCC00),
                  elevation: 0, // 影をなくす
                  bottom: const TabBar(
                    tabs: <Widget>[
                      Tab(
                        text: '新着順',
                      ),
                      Tab(
                        text: '人気順',
                      )
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
                        RefreshIndicator(
                          color: const Color(0xFFFFCC00),
                          onRefresh: () async {
                            await context
                                .read(answerListViewModelProvider(parameter))
                                .refreshNewAnswerList();
                          },
                          child: ListView.builder(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).padding.bottom,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              if (index == viewModel.newAnswers.length - 3) {
                                viewModel.getNewAnswerList();
                              }
                              if (index == viewModel.newAnswers.length) {
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
                                      .read(answerListViewModelProvider(
                                          parameter))
                                      .transitionToAnswerDetail(
                                        answerId: viewModel.newAnswers
                                            .elementAt(index)
                                            .id,
                                      );
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 44,
                                              height: 44,
                                              child: CachedNetworkImage(
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                imageUrl: viewModel.newAnswers
                                                    .elementAt(index)
                                                    .topic
                                                    .createdUser
                                                    .imageUrl,
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
                                                errorWidget: (context, url,
                                                        dynamic error) =>
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
                                                    viewModel.newAnswers
                                                        .elementAt(index)
                                                        .topic
                                                        .createdAt
                                                        .toJPString(),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Container(
                                                          child: Text(
                                                            viewModel.newAnswers
                                                                .elementAt(
                                                                    index)
                                                                .topic
                                                                .createdUser
                                                                .name,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
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
                                                  builder:
                                                      (BuildContext _context) {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 8, 0, 8),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          ListTile(
                                                            leading: const Icon(
                                                                Icons.block),
                                                            title: const Text(
                                                                'この投稿をブロックする'),
                                                            onTap: () {
                                                              Navigator.of(
                                                                      _context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          ListTile(
                                                            leading: const Icon(
                                                                Icons.block),
                                                            title: const Text(
                                                                'このユーザーの投稿を全てブロックする'),
                                                            onTap: () {
                                                              Navigator.of(
                                                                      _context)
                                                                  .pop();
//                                                  context
//                                                      .read(myProfileViewModelProvider(id))
//                                                      .transitionToSetting();
                                                            },
                                                          ),
                                                          ListTile(
                                                            leading: const Icon(
                                                                Icons.report),
                                                            title: const Text(
                                                                'このユーザーを通報する'),
                                                            onTap: () {
                                                              Navigator.of(
                                                                      _context)
                                                                  .pop();
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
                                          viewModel.newAnswers
                                              .elementAt(index)
                                              .topic
                                              .text,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                          ),
                                        ),
                                        (viewModel.newAnswers
                                                        .elementAt(index)
                                                        .topic
                                                        .imageUrl !=
                                                    null &&
                                                viewModel.newAnswers
                                                    .elementAt(index)
                                                    .topic
                                                    .imageUrl
                                                    .isNotEmpty)
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 16, 0, 0),
                                                child: CachedNetworkImage(
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  imageUrl: viewModel.newAnswers
                                                      .elementAt(index)
                                                      .topic
                                                      .imageUrl,
                                                  errorWidget: (context, url,
                                                          dynamic error) =>
                                                      Image.asset(
                                                    'assets/icon/no_image.jpg',
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    icon: viewModel.newAnswers
                                                            .elementAt(index)
                                                            .isLike
                                                        ? const Icon(
                                                            Icons.favorite,
                                                            color: Colors.pink,
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .favorite_outline,
                                                            color: Colors.pink,
                                                          ),
                                                    onPressed: () {
                                                      context
                                                          .read(
                                                              answerListViewModelProvider(
                                                                  parameter))
                                                          .likeButtonAction(
                                                              index: index);
                                                    },
                                                  ),
                                                  Text(
                                                    viewModel.newAnswers
                                                        .elementAt(index)
                                                        .likedTime
                                                        .toStringOverTenThousand(),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Row(
                                                children: [
                                                  IconButton(
                                                    icon: viewModel.newAnswers
                                                            .elementAt(index)
                                                            .isFavor
                                                        ? const Icon(
                                                            Icons.star,
                                                            color: Colors.cyan,
                                                          )
                                                        : const Icon(
                                                            Icons.star_outline,
                                                            color: Colors.cyan,
                                                          ),
                                                    onPressed: () {
                                                      context
                                                          .read(
                                                              answerListViewModelProvider(
                                                                  parameter))
                                                          .favorButtonAction(
                                                              index: index);
                                                    },
                                                  ),
                                                  Text(
                                                    viewModel.newAnswers
                                                        .elementAt(index)
                                                        .favoredTime
                                                        .toStringOverTenThousand(),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                              );
                            },
                            itemCount: viewModel.hasNextInNew &&
                                    viewModel.newAnswers.isNotEmpty
                                ? viewModel.newAnswers.length + 1
                                : viewModel.newAnswers.length,
                          ),
                        ),
                        Container(
//                  color: const Color(0xFFFFCC00),
                            ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget child) {
                return IgnorePointer(
                  ignoring: !controller.isCompleted || controller.isAnimating,
                  child: GestureDetector(
                    onTap: () {
                      if (controller.isCompleted) {
                        controller.reverse();
                      }
                    },
                    child: Container(
                      color: Colors.black
                          .withOpacity(backgroundColorOpacityAnimation.value),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget child) {
                return Positioned(
                  right: 35,
                  bottom: 35,
                  child: Transform.translate(
                    offset: Offset.fromDirection(
                      getRadiansFromDegree(270),
                      degOneTransitionAnimation.value * 100,
                    ),
                    child: Transform(
                      transform: Matrix4.rotationZ(
                        getRadiansFromDegree(rotationAnimation.value),
                      )..scale(degOneTransitionAnimation.value),
                      alignment: Alignment.center,
                      child: CircularButton(
                        color: const Color(0xFFFFCC00),
                        width: 55,
                        height: 55,
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        onClick: () {
                          context
                              .read(answerListViewModelProvider(parameter))
                              .transitionToPostTopic();
                          if (controller.isCompleted) {
                            controller.reverse();
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget child) {
                return Positioned(
                  right: 35,
                  bottom: 35,
                  child: Transform.translate(
                    offset: Offset.fromDirection(
                      getRadiansFromDegree(225),
                      degTwoTransitionAnimation.value * 100,
                    ),
                    child: Transform(
                      transform: Matrix4.rotationZ(
                        getRadiansFromDegree(rotationAnimation.value),
                      )..scale(degOneTransitionAnimation.value),
                      alignment: Alignment.center,
                      child: CircularButton(
                        color: const Color(0xFFFFCC00),
                        width: 55,
                        height: 55,
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        onClick: () {},
                      ),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, child) {
                return Positioned(
                  right: 35,
                  bottom: 35,
                  child: Transform.translate(
                    offset: Offset.fromDirection(
                      getRadiansFromDegree(180),
                      degThreeTransitionAnimation.value * 100,
                    ),
                    child: Transform(
                      transform: Matrix4.rotationZ(
                        getRadiansFromDegree(rotationAnimation.value),
                      )..scale(degOneTransitionAnimation.value),
                      alignment: Alignment.center,
                      child: CircularButton(
                        color: const Color(0xFFFFCC00),
                        width: 55,
                        height: 55,
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        onClick: () {
                          context
                              .read(answerListViewModelProvider(parameter))
                              .transitionToTopicList();
                          if (controller.isCompleted) {
                            controller.reverse();
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget child) {
                return Positioned(
                  right: 30,
                  bottom: 30,
                  child: Transform(
                    transform: Matrix4.rotationZ(
                      getRadiansFromDegree(rotationAnimation2.value),
                    ),
                    alignment: Alignment.center,
                    child: CircularButton(
                      color: const Color(0xFFFFCC00),
                      width: 60,
                      height: 60,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onClick: () {
                        if (controller.isCompleted) {
                          controller.reverse();
                        } else {
                          controller.forward();
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

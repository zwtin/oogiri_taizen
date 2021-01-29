import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oogiritaizen/data/provider/alert_notifier.dart';
import 'package:oogiritaizen/data/provider/tab_0_navigator_notifier.dart';
import 'package:oogiritaizen/ui/answer_list/answer_list_view_model.dart';
import 'package:oogiritaizen/ui/circular_button.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:oogiritaizen/data/model/extension/string_extension.dart';

class AnswerListView extends HookWidget {
  final id = StringExtension.randomString(8);

  @override
  Widget build(BuildContext context) {
    final viewModel = useProvider(answerListViewModelProvider(id));

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
        onChange: (BuildContext context, Tab0NavigatorNotifier navigator) {
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
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              SystemNavigator.pop();
            }
          }
        },
        provider: tab0NavigatorNotifierProvider,
        child: DefaultTabController(
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
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.announcement,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            body: Stack(
              children: [
                TabBarView(
                  children: [
                    Container(
//                  color: const Color(0xFFFFCC00),
                        ),
                    Container(
//                  color: const Color(0xFFFFCC00),
                        ),
                  ],
                ),
                AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, child) {
                    return Positioned(
                      right: 35,
                      bottom: 35,
                      child: Transform.translate(
                        offset: Offset.fromDirection(
                          viewModel.getRadiansFromDegree(270),
                          degOneTransitionAnimation.value * 100,
                        ),
                        child: Transform(
                          transform: Matrix4.rotationZ(
                            viewModel
                                .getRadiansFromDegree(rotationAnimation.value),
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
                              viewModel.transitionToPostAnswer();
                            },
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
                          viewModel.getRadiansFromDegree(225),
                          degTwoTransitionAnimation.value * 100,
                        ),
                        child: Transform(
                          transform: Matrix4.rotationZ(
                            viewModel
                                .getRadiansFromDegree(rotationAnimation.value),
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
                            onClick: () {
                              viewModel.tapped();
                            },
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
                          viewModel.getRadiansFromDegree(180),
                          degThreeTransitionAnimation.value * 100,
                        ),
                        child: Transform(
                          transform: Matrix4.rotationZ(
                            viewModel
                                .getRadiansFromDegree(rotationAnimation.value),
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
                              viewModel.transitionToPostTopic();
                            },
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
                      right: 30,
                      bottom: 30,
                      child: Transform(
                        transform: Matrix4.rotationZ(
                          viewModel
                              .getRadiansFromDegree(rotationAnimation2.value),
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
        ),
      ),
    );
  }
}

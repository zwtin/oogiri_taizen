import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oogiri_taizen/app/widget/circular_button.dart';

class FloatingActionButtonWidget extends HookWidget {
  const FloatingActionButtonWidget({
    required this.child,
    required this.action1,
    required this.action2,
    // required this.action3,
  });

  final Widget child;
  final void Function() action1;
  final void Function() action2;
  // final void Function() action3;

  double getRadiansFromDegree(double degree) {
    const unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  Widget build(BuildContext context) {
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

    // const beginPositionValue3 = 0.0;
    // const peekPositionValue3 = 1.75;
    // const endPositionValue3 = 1.0;
    // const beginWeight3 = 35.0;
    // const endWeight3 = 65.0;
    // final degThreeTransitionAnimation = TweenSequence([
    //   TweenSequenceItem(
    //     tween: Tween(
    //       begin: beginPositionValue3,
    //       end: peekPositionValue3,
    //     ),
    //     weight: beginWeight3,
    //   ),
    //   TweenSequenceItem(
    //     tween: Tween(
    //       begin: peekPositionValue3,
    //       end: endPositionValue3,
    //     ),
    //     weight: endWeight3,
    //   ),
    // ]).animate(controller);

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

    return Stack(
      children: [
        child,
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
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
          builder: (context, child) {
            return Positioned(
              right: 35,
              bottom: 35,
              child: Transform.translate(
                offset: Offset.fromDirection(
                  getRadiansFromDegree(195),
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
                      action1();
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
          builder: (context, child) {
            return Positioned(
              right: 35,
              bottom: 35,
              child: Transform.translate(
                offset: Offset.fromDirection(
                  getRadiansFromDegree(255),
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
                    onClick: () {
                      action2();
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
        // AnimatedBuilder(
        //   animation: controller,
        //   builder: (context, child) {
        //     return Positioned(
        //       right: 35,
        //       bottom: 35,
        //       child: Transform.translate(
        //         offset: Offset.fromDirection(
        //           getRadiansFromDegree(180),
        //           degThreeTransitionAnimation.value * 100,
        //         ),
        //         child: Transform(
        //           transform: Matrix4.rotationZ(
        //             getRadiansFromDegree(rotationAnimation.value),
        //           )..scale(degOneTransitionAnimation.value),
        //           alignment: Alignment.center,
        //           child: CircularButton(
        //             color: const Color(0xFFFFCC00),
        //             width: 55,
        //             height: 55,
        //             icon: const Icon(
        //               Icons.person,
        //               color: Colors.white,
        //             ),
        //             onClick: () {
        //               action3();
        //               if (controller.isCompleted) {
        //                 controller.reverse();
        //               }
        //             },
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // ),
        AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
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
    );
  }
}

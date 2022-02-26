import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class StartAnimationController {
  void Function()? play;
}

class StartAnimation extends StatefulWidget {
  StartAnimationController? controller;
  StartAnimation({Key? key, this.controller}) : super(key: key);

  @override
  State<StartAnimation> createState() => _StartAnimationState();
}

enum AniProps { x, y, opacity }

class _StartAnimationState extends State<StartAnimation> with AnimationMixin {
  CustomAnimationControl control = CustomAnimationControl.play;
  final _tween = TimelineTween<AniProps>()
    //step1
    ..addScene(begin: Duration.zero, duration: const Duration(seconds: 10), curve: Curves.easeOut).animate(AniProps.y, tween: Tween(begin: 100.0, end: 0.0))
    ..addScene(begin: Duration.zero, duration: const Duration(seconds: 10)).animate(AniProps.opacity, tween: Tween(begin: 0.0, end: 1.0))
    //step2
    ..addScene(begin: const Duration(seconds: 10), duration: const Duration(seconds: 15)).animate(AniProps.y, tween: Tween(begin: 0.0, end: -30.0))
    //step3
    ..addScene(begin: const Duration(seconds: 25), duration: const Duration(seconds: 10), curve: Curves.easeIn).animate(AniProps.y, tween: Tween(begin: -30.0, end: -130.0))
    ..addScene(begin: const Duration(seconds: 25), duration: const Duration(seconds: 10)).animate(AniProps.opacity, tween: Tween(begin: 1.0, end: 0.0));

  @override
  void initState() {
    controller.play();
    super.initState();
    _setController();
  }

  @override
  void didUpdateWidget(StartAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setController();
  }

  _setController() {
    widget.controller!.play = () {
      setState(() {
        control = control == CustomAnimationControl.play ? CustomAnimationControl.playReverse : CustomAnimationControl.play;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return CustomAnimation<TimelineValue<AniProps>>(
        control: control,
        tween: _tween,
        builder: (context, child, value) {
          return Center(
            child: Opacity(
              opacity: value.get(AniProps.opacity),
              child: Transform.translate(
                  offset: Offset(0, value.get(AniProps.y)),
                  child: FractionallySizedBox(
                    widthFactor: 0.4,
                    child: Image.asset(
                      "assets/images/start.png",
                    ),
                  )),
            ),
          );
        });
  }
}

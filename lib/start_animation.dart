import 'package:flutter/material.dart';
import 'package:flutter_sequence_animation/flutter_sequence_animation.dart';

class StartAnimationController {
  void Function()? play;
}

class StartAnimation extends StatefulWidget {
  final StartAnimationController? controller;
  StartAnimation({Key? key, this.controller}) : super(key: key);

  @override
  State<StartAnimation> createState() => _StartAnimationState();
}

class _StartAnimationState extends State<StartAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;
  late SequenceAnimation _sequenceAnimation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    _sequenceAnimation = SequenceAnimationBuilder()
        //opacity
        .addAnimatable(animatable: Tween<double>(begin: 0.0, end: 1.0), from: Duration.zero, to: const Duration(milliseconds: 250), curve: Curves.easeOut, tag: "opacity")
        .addAnimatable(animatable: Tween<double>(begin: 1.0, end: 1.0), from: const Duration(milliseconds: 250), to: const Duration(milliseconds: 500), curve: Curves.linear, tag: "opacity")
        .addAnimatable(animatable: Tween<double>(begin: 1.0, end: 0.0), from: const Duration(milliseconds: 500), to: const Duration(milliseconds: 750), curve: Curves.easeIn, tag: "opacity")
        //position
        .addAnimatable(animatable: Tween<double>(begin: 150, end: 15.0), from: Duration.zero, to: const Duration(milliseconds: 250), curve: Curves.easeOut, tag: "positionY")
        .addAnimatable(animatable: Tween<double>(begin: 15.0, end: -15.0), from: const Duration(milliseconds: 250), to: const Duration(milliseconds: 500), curve: Curves.linear, tag: "positionY")
        .addAnimatable(animatable: Tween<double>(begin: -15.0, end: -150.0), from: const Duration(milliseconds: 500), to: const Duration(milliseconds: 750), curve: Curves.easeIn, tag: "positionY")
        .animate(_controller);
    _setController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StartAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setController();
  }

  _setController() {
    widget.controller!.play = () {
      if (mounted) {
        _controller.reset();
        _controller.forward();
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Center(
          child: Opacity(
            opacity: _sequenceAnimation["opacity"].value,
            child: Transform.translate(
                offset: Offset(0, _sequenceAnimation["positionY"].value),
                child: FractionallySizedBox(
                  widthFactor: 0.4,
                  child: Image.asset(
                    "assets/images/start.png",
                  ),
                )),
          ),
        );
      },
    );
  }
}

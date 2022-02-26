import 'package:flutter/material.dart';

class AnimationWidget extends StatefulWidget {
  final int? index;
  final bool isRunAnimaion;
  final Widget? child;
  AnimationWidget({Key? key, this.child, this.index, this.isRunAnimaion = false}) : super(key: key);

  @override
  State<AnimationWidget> createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _animation;

  @override
  void didUpdateWidget(covariant AnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isRunAnimaion) {
      _controller.repeat(reverse: true);
    } else {
      _controller.forward(from: 1);
      _controller.stop(canceled: true);
    }
  }

  @override
  void initState() {
    _controller = AnimationController(lowerBound: 0.3, upperBound: 1.0, value: 1.0, vsync: this, duration: const Duration(milliseconds: 800));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint("idx: ${widget.index} build, isRunAnimaion:${widget.isRunAnimaion}");

    return FadeTransition(
      opacity: _animation!,
      child: Container(
        child: widget.child,
      ),
    );
  }
}

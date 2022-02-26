import 'package:flutter/material.dart';

class StepIndicatorController {
  void Function(int step)? setStep;
}

class StepIndicator extends StatefulWidget {
  final int step;
  final StepIndicatorController? controller;
  StepIndicator({Key? key, this.step = 0, this.controller}) : super(key: key);

  @override
  State<StepIndicator> createState() => _StepIndicatorState();
}

class _StepIndicatorState extends State<StepIndicator> {
  late int _step; //0,1,2,3,4(all)
  StepIndicatorController? _controller;

  final Color _completeColor = Colors.grey.shade700;
  final Color _unCompleteColor = Colors.white;

  @override
  void initState() {
    _setController();
    _step = widget.step;
    super.initState();
  }

  @override
  void didUpdateWidget(StepIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setController();
  }

  _setController() {
    _controller = widget.controller;
    _controller?.setStep = _setStep;
  }

  _setStep(int step) {
    setState(() {
      _step = step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(color: Colors.brown.shade100, borderRadius: BorderRadius.all(Radius.circular(6))),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 20, child: Text("1", textAlign: TextAlign.center, style: TextStyle(fontSize: _step >= 1 ? 22 : 18, color: _step >= 1 ? _completeColor : _unCompleteColor))),
            Icon(
              Icons.arrow_right,
              color: Colors.white,
              size: 26,
            ),
            SizedBox(width: 20, child: Text("2", textAlign: TextAlign.center, style: TextStyle(fontSize: _step >= 2 ? 22 : 18, color: _step >= 2 ? _completeColor : _unCompleteColor))),
            Icon(
              Icons.arrow_right,
              color: Colors.white,
              size: 26,
            ),
            SizedBox(width: 20, child: Text("3", textAlign: TextAlign.center, style: TextStyle(fontSize: _step >= 3 ? 22 : 18, color: _step >= 3 ? _completeColor : _unCompleteColor))),
            Icon(
              Icons.arrow_right,
              color: Colors.white,
              size: 26,
            ),
            SizedBox(width: 30, child: Text("all", textAlign: TextAlign.center, style: TextStyle(fontSize: _step >= 4 ? 22 : 18, color: _step >= 4 ? _completeColor : _unCompleteColor))),
          ],
        ),
      ),
    );
  }
}

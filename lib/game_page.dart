import 'dart:math';
// import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:puzzle123/animation_widget.dart';
import 'package:puzzle123/puzzle_view.dart';
import 'package:puzzle123/step_indicator.dart';

//for test
class GamePage extends StatefulWidget {
  GamePage({Key? key}) : super(key: key);

  @override
  GamePageState createState() {
    return new GamePageState();
  }
}

class GamePageState extends State<GamePage> {
  final PuzzleViewController _puzzleViewCtr = PuzzleViewController();

  Color _bgColor1 = Color(0xFFFDFDFD);
  Color _bgColor2 = Colors.grey.shade100;
  Color _itemUnselectColor = Colors.grey.shade300;
  Color _itemselectedColor = const Color(0xFF4CD6AF);

  @override
  void initState() {
    super.initState();
    setPuzzleViewController();
  }

  setPuzzleViewController() {
    _puzzleViewCtr.onGameClear = () {
      if (_puzzleViewCtr.resetGame != null) {
        _puzzleViewCtr.resetGame!();
      }
    };

    _puzzleViewCtr.onChangeStep = (int newStep) {
      // _stepIndicatorCtr?.setStep!(newStep);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor1,
      resizeToAvoidBottomInset: true,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Stage",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFFD4645B)),
                        ),
                        Text(
                          "1/6",
                          style: TextStyle(fontSize: 26, color: Color(0xFF333333)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Timer",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFFD4645B)),
                        ),
                        Text(
                          "60",
                          style: TextStyle(fontSize: 26, color: Color(0xFF333333)),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    // color: Colors.blue,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              // _resetGame();
                            });
                          },
                          icon: Icon(
                            Icons.pause,
                            color: Color(0xFF333333),
                            size: 30,
                          )),
                    ),
                  ))
                ],
              ),
            ),
            const SizedBox(height: 100),
            Expanded(
              child: PuzzleView(
                controller: _puzzleViewCtr,
              ),
            ),
            Container(height: 100)
          ],
        ),
      ),
    );
  }
}

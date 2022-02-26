import 'dart:math';
// import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:puzzle123/alert.dart';
import 'package:puzzle123/animation_widget.dart';
import 'package:puzzle123/def.dart';
import 'package:puzzle123/models/question.dart';
import 'package:puzzle123/puzzle_view.dart';
import 'package:puzzle123/speed_puzzle_intro.dart';
import 'package:puzzle123/start_animation.dart';
import 'package:puzzle123/step_indicator.dart';
import 'package:puzzle123/utility/db_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class PlayAllQuestions extends StatefulWidget {
  final QuestionType? type;
  PlayAllQuestions({Key? key, this.type}) : super(key: key);

  @override
  _PlayAllQuestionsState createState() {
    return new _PlayAllQuestionsState();
  }
}

class _PlayAllQuestionsState extends State<PlayAllQuestions> {
  late QuestionType _questionType;
  int _questionLength = 0;
  int _currentQuestionIdx = -1;
  List<Question> _questionList = [];
  Question? _currentQuestion;

  bool _showNextLevelBtn = false;

  final PuzzleViewController _puzzleViewCtr = PuzzleViewController();

  // final StepIndicatorController? _stepIndicatorCtr = StepIndicatorController();
  Color _bgColor1 = Color(0xFFFDFDFD);
  Color _bgColor2 = Colors.grey.shade100;
  Color _itemUnselectColor = Colors.grey.shade300; //Color.fromARGB(255, 244, 239, 237);
  Color _itemselectedColor = const Color(0xFF4CD6AF);

  AudioCache _player = AudioCache(prefix: 'assets/audios/');

  @override
  void initState() {
    super.initState();
    _initSound();
    _questionType = widget.type!;

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _loadLastPlayQuestion().then((value) {
        setPuzzleViewController();
        setState(() {});
      });
    });
  }

  _initSound() async {
    _player.load('win.mp3');
    _player.load('pause.mp3');
    _player.load('resume.mp3');
  }

  //最後一次玩的ID
  Future<String?> _getLastPlayQuestionId() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.getKeys().contains(Def.saveKeyLastPlayId)) {
      String? id = sharedPref.getString(Def.saveKeyLastPlayId);
      return id;
    }
    return null;
  }

  //儲存最後一次玩的ID
  _saveLastPlayQuestionID() async {
    if (_currentQuestion == null) return;
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString(Def.saveKeyLastPlayId, _currentQuestion!.id!);
  }

  Future _loadLastPlayQuestion() async {
    try {
      String? lastPlayQuestionID = await _getLastPlayQuestionId();
      _questionList = question6x6List;
      _questionLength = _questionList.length;

      if (lastPlayQuestionID != null) {
        int lastPlayQuestionIdx = _questionList.indexWhere((element) => element.id == lastPlayQuestionID);
        if (lastPlayQuestionIdx != -1) {
          _currentQuestionIdx = lastPlayQuestionIdx;
        } else {
          _currentQuestionIdx = 0;
        }
      } else {
        _currentQuestionIdx = 0;
      }
      _currentQuestion = _questionList[_currentQuestionIdx];
      setState(() {});
    } catch (e) {
      debugPrint("$e");
    }
  }

  _nextQuestion() {
    if (_currentQuestionIdx == -1) return;
    if (_currentQuestionIdx + 1 <= _questionList.length - 1) {
      _currentQuestionIdx++;
      _currentQuestion = _questionList[_currentQuestionIdx];
    }
    setState(() {});
  }

  _prevQuestion() {
    if (_currentQuestionIdx == -1) return;
    if (_currentQuestionIdx - 1 >= 0) {
      _currentQuestionIdx--;
      _currentQuestion = _questionList[_currentQuestionIdx];
    }
    setState(() {});
  }

  setPuzzleViewController() {
    //過關
    _puzzleViewCtr.onGameClear = () {
      _player.play("win.mp3");
      setState(() {
        question6x6ClearSet.add(_currentQuestion!.id!);
        DBUtil.saveQuestionIsClear(type: widget.type!, data: question6x6ClearSet);

        if (_currentQuestion != question6x6List.last) {
          _showNextLevelBtn = true;
        }
      });
    };

    //步驟達成顯示
    _puzzleViewCtr.onChangeStep = (int newStep) {
      // _stepIndicatorCtr?.setStep!(newStep);
    };
  }


  @override
  Widget build(BuildContext context) {
    if (_currentQuestion == null) return Container();
    return Scaffold(
      backgroundColor: kIsWeb ? Color(0xFFF6F1EE) : _bgColor1,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            color: kIsWeb ? Colors.white : Colors.transparent,
            constraints: kIsWeb ? BoxConstraints(maxWidth: Def.webMaxWidth) : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 15),
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                        // color: Colors.blue,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _showPause();
                                });
                              },
                              icon: const Icon(
                                Icons.pause,
                                color: Color(0xFF333333),
                                size: 30,
                              )),
                        ),
                      ))
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Level",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFFD4645B)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              _showNextLevelBtn = false;
                              _prevQuestion();
                            },
                            icon: const Icon(
                              Icons.arrow_left,
                              size: 30,
                            )),
                        const SizedBox(width: 10),
                        Text(
                          "${_currentQuestionIdx != -1 ? _currentQuestionIdx + 1 : -1}/$_questionLength",
                          style: TextStyle(fontSize: 26, color: Color(0xFF333333)),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                            onPressed: () {
                              _showNextLevelBtn = false;
                              _nextQuestion();
                            },
                            icon: const Icon(
                              Icons.arrow_right,
                              size: 30,
                            ))
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    color: (question6x6ClearSet.contains(_currentQuestion!.id!)) ? Colors.grey.shade100 : Colors.transparent,
                    child: Center(
                      child: Text(
                        () {
                          if (question6x6ClearSet.contains(_currentQuestion!.id!)) {
                            return "Level Complete";
                          }
                          return " ";
                        }(),
                        style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
                      ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: Column(
                  children: [
                    PuzzleView(
                      key: ValueKey(_currentQuestion!.id!),
                      questionType: _questionType,
                      controller: _puzzleViewCtr,
                      question: _currentQuestion,
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: _showNextLevelBtn,
                      child: Container(
                        height: 56,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(Colors.grey[100]!.withOpacity(0.5)),
                              backgroundColor: MaterialStateProperty.all(Colors.pinkAccent),
                            ),
                            onPressed: () {
                              _showNextLevelBtn = false;
                              _nextQuestion();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 2),
                              child: FittedBox(
                                  child: Text(
                                "Next level",
                                style: TextStyle(height: 1.5, fontSize: 25, fontFamily: "BalooBhaijaan2", color: Colors.white),
                              )),
                            )),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _showPause() {
    _player.play("pause.mp3", volume: 0.4);
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false, //不透明
        fullscreenDialog: false,
        pageBuilder: (buildContext, a1, a2) => Alert(
          title: "Pause",
          btn1Text: "Main Page",
          btn1TextColor: Colors.white,
          btn1Color: Colors.pinkAccent,
          onBtn1Pressed: () {
            _player.play("click.mp3", volume: 0.3);
            _saveLastPlayQuestionID();
            _gotoMainPage();
          },
          btn2Text: "Back",
          btn2TextColor: Colors.white,
          btn2Color: Colors.pinkAccent,
          onBtn2Pressed: () {
            _player.play("click.mp3", volume: 0.3);
          },
          onCancel: () {
            _player.play("click.mp3", volume: 0.3);
            _player.play("resume.mp3", volume: 0.4);
          },
        ),
        transitionsBuilder: (buildContext, a1, a2, child) => FadeTransition(opacity: a1, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  _showIntro() {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false, //不透明
        fullscreenDialog: false,
        pageBuilder: (buildContext, a1, a2) => SpeedPuzzleIntro(),
        transitionsBuilder: (buildContext, a1, a2, child) => FadeTransition(opacity: a1, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  _gotoMainPage() {
    Navigator.of(context).pop();
  }
}

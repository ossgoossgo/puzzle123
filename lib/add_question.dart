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
class AddQuestion extends StatefulWidget {
  AddQuestion({Key? key}) : super(key: key);

  @override
  _AddQuestionState createState() {
    return new _AddQuestionState();
  }
}

class _AddQuestionState extends State<AddQuestion> {
  QuestionType _questionType = QuestionType.question3x3;
  int _questionLength = 0;
  int _currentQuestionIdx = -1;
  List<Question> _questionList = [];
  Question? _currentQuestion;
  bool _isCanSave = false; //必須要通關一次才能儲存

  final PuzzleViewController _puzzleViewCtr = PuzzleViewController();

  // final StepIndicatorController? _stepIndicatorCtr = StepIndicatorController();
  Color _bgColor1 = Color(0xFFFDFDFD);
  Color _bgColor2 = Colors.grey.shade100;
  Color _itemUnselectColor = Colors.grey.shade300; //Color.fromARGB(255, 244, 239, 237);
  Color _itemselectedColor = const Color(0xFF4CD6AF);

  @override
  void initState() {
    super.initState();
    _loadLastQuestion();
    setPuzzleViewController();

    //FIXME:
    //txt回存回db
    // _exportTxtDataToDB();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // _showIntro();
    });
  }

  //把txt資料回存到db
  _exportTxtDataToDB() {
    for (var i = 0; i < question3x3List.length; i++) {
      Question question = question3x3List[i];
      DBUtil.addQuestion(type: QuestionType.question3x3, id: question.id!, dataStr: question.toString());
    }
    for (var i = 0; i < question4x4List.length; i++) {
      Question question = question4x4List[i];
      DBUtil.addQuestion(type: QuestionType.question4x4, id: question.id!, dataStr: question.toString());
    }
    for (var i = 0; i < question5x5List.length; i++) {
      Question question = question5x5List[i];
      DBUtil.addQuestion(type: QuestionType.question5x5, id: question.id!, dataStr: question.toString());
    }
    for (var i = 0; i < question6x6List.length; i++) {
      Question question = question6x6List[i];
      DBUtil.addQuestion(type: QuestionType.question6x6, id: question.id!, dataStr: question.toString());
    }
  }

  _loadLastQuestion() {
    //FIXME: 從db
    _questionList = DBUtil.getAllQuestion(type: _questionType);
    _questionLength = _questionList.length;
    _currentQuestionIdx = _questionList.isNotEmpty ? _questionLength - 1 : -1;
    if (_currentQuestionIdx != -1) {
      _currentQuestion = _questionList[_currentQuestionIdx];
    } else {
      _currentQuestion = null;
    }

    //FIXME: 測試資料
    // _currentQuestion = Question(id:"", type: QuestionType.question3x3, startPointIdx: 4, checkPointIdxList:[0,1,3]);

    setState(() {});
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

  _deleteQuestion() async {
    await DBUtil.deleteQuest(type: _questionType, id: _currentQuestion!.id!);
    _questionList = DBUtil.getAllQuestion(type: _questionType);
    _questionLength = _questionList.length;
    if (_questionLength > 0) {
      if (_currentQuestionIdx != -1) {
        if (_currentQuestionIdx <= _questionLength - 1) {
          _currentQuestion = _questionList[_currentQuestionIdx];
        } else {
          _currentQuestionIdx = _questionLength - 1;
          _currentQuestion = _questionList[_currentQuestionIdx];
        }
      } else {}
    } else {
      _questionLength = -1;
      _currentQuestion = null;
    }
    setState(() {});
  }

  _addQuestion() async {
    if (!_isCanSave) return;
    _isCanSave = false;
    Question question = _puzzleViewCtr.getQuestion!();
    debugPrint(question.toString());
    if (question.id != null && question.checkPointIdxList != null && question.checkPointMap != null && question.startPointIdx != null) {
      await DBUtil.addQuestion(type: _questionType, id: question.id!, dataStr: question.toString());

      //重新更新資料
      _loadLastQuestion();
    }
  }

  _newQuestion() {
    _puzzleViewCtr.resetGame!();
    _currentQuestionIdx = -1;
    _currentQuestion = null;
    _isCanSave = false;
    setState(() {});
  }

  _convertCurrentTypeDataToJson() {
    DBUtil.convertAllQuestionToJson(type: _questionType);
  }

  setPuzzleViewController() {
    _puzzleViewCtr.onGameClear = () {
      _isCanSave = true;

      if (_puzzleViewCtr.resetGame != null) {
        // _puzzleViewCtr.resetGame!();
      }
    };

    _puzzleViewCtr.onChangeStep = (int newStep) {
      // _stepIndicatorCtr?.setStep!(newStep);
    };
  }

  Widget _buildChoiceItem(int index) {
    return ChoiceChip(
      label: Text(() {
        switch (index) {
          case 0:
            return "3x3";
          case 1:
            return "4x4";
          case 2:
            return "5x5";
          case 3:
            return "6x6";
          default:
            return "3x3";
        }
      }()),
      selectedColor: Colors.orange,
      disabledColor: Colors.orange[100],
      onSelected: (bool selected) {
        setState(() {
          switch (index) {
            case 0:
              _questionType = QuestionType.question3x3;
              break;
            case 1:
              _questionType = QuestionType.question4x4;
              break;
            case 2:
              _questionType = QuestionType.question5x5;
              break;
            case 3:
              _questionType = QuestionType.question6x6;
              break;
            default:
              _questionType = QuestionType.question3x3;
          }
        });
        _loadLastQuestion();
        _puzzleViewCtr.resetGame!();
      },
      selected: () {
        switch (index) {
          case 0:
            return (_questionType == QuestionType.question3x3);
          case 1:
            return (_questionType == QuestionType.question4x4);
          case 2:
            return (_questionType == QuestionType.question5x5);
          case 3:
            return (_questionType == QuestionType.question6x6);
          default:
            return (_questionType == QuestionType.question3x3);
        }
      }(),
      labelStyle: TextStyle(color: Colors.black54),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor1,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 15),
                child: Row(
                  children: [
                    Wrap(
                      spacing: 5.0, //主軸
                      runSpacing: 8.0, //副軸
                      children: List<Widget>.generate(4, (int index) {
                        return _buildChoiceItem(index);
                      }),
                    ),
                    Expanded(
                        child: Container(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                _showAlert();
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
              Text("數量: $_questionLength"),
              SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                TextButton(
                    onPressed: () {
                      _deleteQuestion();
                    },
                    child: Text("刪除", style: TextStyle(fontSize: 20))),
                TextButton(
                    onPressed: () {
                      _addQuestion();
                    },
                    child: Text("儲存", style: TextStyle(fontSize: 20))),
                TextButton(
                    onPressed: () {
                      _newQuestion();
                    },
                    child: Text("新題目", style: TextStyle(fontSize: 20))),
                TextButton(
                    onPressed: () {
                      _convertCurrentTypeDataToJson();
                    },
                    child: Text("轉json", style: TextStyle(fontSize: 20)))
              ]),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        _prevQuestion();
                      },
                      icon: Icon(Icons.arrow_left)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Level",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFFD4645B)),
                      ),
                      Text(
                        "${_currentQuestionIdx != -1 ? _currentQuestionIdx + 1 : -1}/$_questionLength",
                        style: TextStyle(fontSize: 26, color: Color(0xFF333333)),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {
                        _nextQuestion();
                      },
                      icon: Icon(Icons.arrow_right)),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Expanded(
                child: Stack(
                  children: [
                    Align(
                      // alignment: Alignment.topCenter,
                      child: PuzzleView(
                        key: GlobalKey(),
                        questionType: _questionType,
                        controller: _puzzleViewCtr,
                        question: _currentQuestion,
                      ),
                    ),
                    // StartAnimation()
                  ],
                ),
              ),
              Container(height: 100)
            ],
          ),
        ),
      ),
    );
  }

  _showAlert() {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false, //不透明
        fullscreenDialog: false,
        pageBuilder: (buildContext, a1, a2) => Alert(
          title: "Option",
          btn1Text: "Restart",
          btn1TextColor: Colors.white,
          btn1Color: Colors.brown.shade300,
          onBtn1Pressed: () {},
          btn2Text: "Main Page",
          btn2TextColor: Colors.white,
          btn2Color: Colors.brown.shade300,
          onBtn2Pressed: () {
            _gotoMainPage();
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

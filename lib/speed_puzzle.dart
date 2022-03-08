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
import 'package:puzzle123/start_animation.dart';
import 'package:puzzle123/step_indicator.dart';
import 'package:puzzle123/utility/db_util.dart';
import 'dart:async';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:puzzle123/utility/sound_helper.dart';
import 'package:confetti/confetti.dart';

class SpeedPuzzle extends StatefulWidget {
  SpeedPuzzle({Key? key}) : super(key: key);

  @override
  SpeedPuzzleState createState() {
    return SpeedPuzzleState();
  }
}

class SpeedPuzzleState extends State<SpeedPuzzle> {
  final PuzzleViewController _puzzleViewCtr = PuzzleViewController();
  // final StepIndicatorController? _stepIndicatorCtr = StepIndicatorController();
  final Color _bgColor1 = Color(0xFFFDFDFD);
  List<Question> _remainingQuestionList = [];
  int _totalQuestionLength = 0;
  final int _maxTime = 120;
  late int _times = 0;
  int _currentQuestIdx = -1;
  Question? _currentQuestion;
  bool _isGameWin = false;
  bool _isGameLose = false;

  Timer? _timer;
  final StreamController<int> _timerStreamCtr = StreamController<int>();
  final StartAnimationController _startAnimationCtr = StartAnimationController();
  late ConfettiController _confettiCtr;

  @override
  void initState() {
    super.initState();
    // _initSound();
    _confettiCtr = ConfettiController(duration: const Duration(milliseconds: 100));
    setPuzzleViewController();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _resetGame();
      _showIntro();
    });
  }

  @override
  void dispose() {
    _confettiCtr.dispose();
    _timer?.cancel();
    _timerStreamCtr.close();
    super.dispose();
  }

  _playGamepassSound() {
    SoundHelper.playStartSound(volume: 0.5);
  }

  _playLoseSound() {
    SoundHelper.playLoseSound();
  }

  _playWinSound() {
    SoundHelper.playWinSound();
  }

  _resetGame() {
    _isGameWin = false;
    _isGameLose = false;
    _timer?.cancel();
    _timer = null;
    _times = _maxTime;
    _currentQuestIdx = -1;
    _loadQuestion();
    _nextQuestion();
  }

  _startCountdownTime() {
    if (_timer != null) _timer!.cancel();
    _timer = null;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        if (_times > 0) {
          _times--;
          if (_times == 0) {
            //失敗 lose
            _isGameLose = true;
            _timer?.cancel();
            _playLoseSound();
            setState(() {});
          }
          _timerStreamCtr.add(_times);
        }
      } else {
        _timer?.cancel();
      }
    });
  }

  _stopCountdownTime() {
    _timer?.cancel();
  }

  _loadQuestion() {
    Random random = Random();
    //3x3 3題
    List<Question> questions3x3 = [];

    //取db資料
    // List<Question> questions3x3All = DBUtil.getAllQuestion(type: QuestionType.question3x3);
    List<Question> questions3x3All = List.from(question3x3List);
    while (questions3x3.length < 3) {
      int idx = random.nextInt(questions3x3All.length);
      Question question = questions3x3All.removeAt(idx);
      question.type = QuestionType.question3x3;
      questions3x3.add(question);
    }

    //4x4 3題
    List<Question> questions4x4 = [];
    // List<Question> questions4x4All = DBUtil.getAllQuestion(type: QuestionType.question4x4);
    List<Question> questions4x4All = List.from(question4x4List);
    while (questions4x4.length < 3) {
      int idx = random.nextInt(questions4x4All.length);
      Question question = questions4x4All.removeAt(idx);
      question.type = QuestionType.question4x4;
      questions4x4.add(question);
    }

    //5x5 3題
    List<Question> questions5x5 = [];
    // List<Question> questions5x5All = DBUtil.getAllQuestion(type: QuestionType.question5x5);
    List<Question> questions5x5All = List.from(question5x5List);
    while (questions5x5.length < 3) {
      int idx = random.nextInt(questions5x5All.length);
      Question question = questions5x5All.removeAt(idx);
      question.type = QuestionType.question5x5;
      questions5x5.add(question);
    }

    //6x6 3題
    List<Question> questions6x6 = [];
    // List<Question> questions6x6All = DBUtil.getAllQuestion(type: QuestionType.question6x6);
    List<Question> questions6x6All = List.from(question6x6List);
    while (questions6x6.length < 3) {
      int idx = random.nextInt(questions6x6All.length);
      Question question = questions6x6All.removeAt(idx);
      question.type = QuestionType.question6x6;
      questions6x6.add(question);
    }

    _remainingQuestionList = [...questions3x3, ...questions4x4, ...questions5x5, ...questions6x6];
    _totalQuestionLength = _remainingQuestionList.length;
  }

  _nextQuestion() {
    if (_remainingQuestionList.isNotEmpty) {
      _currentQuestion = _remainingQuestionList.removeAt(0);
      _currentQuestIdx++;
      setState(() {});
    } else {
      //win
      _timer?.cancel();
      _confettiCtr.play();
      _playWinSound();
      setState(() {
        _isGameWin = true;
      });
    }
  }

  setPuzzleViewController() {
    _puzzleViewCtr.onGameClear = () {
      _nextQuestion();
    };

    _puzzleViewCtr.onChangeStep = (int newStep) {};
  }

  _startGame() {
    _playGamepassSound();
    _startCountdownTime();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (_startAnimationCtr.play != null) {
        _startAnimationCtr.play!();
      }
    });
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
              color: kIsWeb ? Colors.white : Colors.transparent,
              alignment: Alignment.center,
              constraints: kIsWeb ? BoxConstraints(maxWidth: Def.webMaxWidth) : null,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Level",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFFD4645B)),
                                    ),
                                    Text(
                                      "${_currentQuestIdx + 1}/$_totalQuestionLength",
                                      style: TextStyle(fontSize: 26, color: Color(0xFF333333)),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      "Timer",
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFFD4645B)),
                                    ),
                                    StreamBuilder<int>(
                                        stream: _timerStreamCtr.stream,
                                        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                                          int? times = _maxTime;
                                          if (snapshot.hasData) {
                                            times = snapshot.data;
                                          }
                                          return Text(
                                            "${times!}",
                                            style: TextStyle(fontSize: 26, color: Color(0xFF333333)),
                                          );
                                        })
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Align(
                                alignment: Alignment.centerRight,
                                child: Visibility(
                                  visible: !_isGameWin && !_isGameLose,
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _timer?.cancel();
                                          _showPause();
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
                        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                        Expanded(
                          child: (!_isGameWin && !_isGameLose)
                              ? Stack(
                                  children: [
                                    Align(
                                      child: PuzzleView(
                                        key: ValueKey(_currentQuestion!.id!),
                                        controller: _puzzleViewCtr,
                                        question: _currentQuestion,
                                        questionType: _currentQuestion!.type,
                                      ),
                                    ),
                                    // if (_isReady) //目前藉由_isReady啟動動畫
                                    StartAnimation(
                                      controller: _startAnimationCtr,
                                    )
                                  ],
                                )
                              : _isGameLose
                                  ? _buildGameLose()
                                  : _isGameWin
                                      ? _buildGameWin()
                                      : Container(),
                        ),
                        Container(height: 100)
                        // SizedBox(height: 100),
                        // Expanded(
                        //   child: Column(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       // StepIndicator(controller: _stepIndicatorCtr, step: _puzzleViewCtr.getStep == null ? 0 : _puzzleViewCtr.getStep!()),
                        //       SizedBox(height: 20),
                        //       PuzzleView(
                        //         controller: _puzzleViewCtr,
                        //       ),
                        //       SizedBox(height: 50),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: const Alignment(-1, -0.2),
                    child: ConfettiWidget(
                      confettiController: _confettiCtr,
                      blastDirection: pi / 180 * 320, // radial value - LEFT
                      particleDrag: 0.05, // apply drag to the confetti
                      emissionFrequency: 0.4, // how often it should emit
                      numberOfParticles: 15, // number of particles to emit
                      gravity: 0.05, // gravity - or fall speed
                      shouldLoop: false,
                      // colors: const [Colors.green, Colors.blue, Colors.pink], // manually specify the colors to be used
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ConfettiWidget(
                      confettiController: _confettiCtr,
                      blastDirection: pi / 180 * 180, // radial value - LEFT
                      particleDrag: 0.05, // apply drag to the confetti
                      emissionFrequency: 0.3, // how often it should emit
                      numberOfParticles: 10, // number of particles to emit
                      gravity: 0.08, // gravity - or fall speed
                      shouldLoop: false,
                      // colors: const [Colors.green, Colors.blue, Colors.pink], // manually specify the colors to be used
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  _buildGameLose() {
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        FractionallySizedBox(widthFactor: 0.7, child: Image.asset("assets/images/lose.png")),
        const SizedBox(
          height: 100,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.grey[100]!.withOpacity(0.5)),
                    backgroundColor: MaterialStateProperty.all(Colors.pinkAccent),
                  ),
                  onPressed: () {
                    SoundHelper.playClickSound();
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 2),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Baseline(
                        baselineType: TextBaseline.alphabetic,
                        baseline: kIsWeb ? (1.5 * 18 - 1.5 * 18 / 4) : (1.5 * 30 - 1.5 * 30 / 4), //height * textSize - height * textSize / 4;
                        child: const Text(
                          "MENU",
                          style: TextStyle(height: 1.5, fontSize: kIsWeb ? 18 : 30, fontFamily: "BalooBhaijaan2", color: Colors.white),
                        ),
                      ),
                    ),
                  )),
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.grey[100]!.withOpacity(0.5)),
                    backgroundColor: MaterialStateProperty.all(Colors.pinkAccent),
                  ),
                  onPressed: () {
                    SoundHelper.playClickSound();
                    _resetGame();
                    _startGame();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 2),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Baseline(
                        baselineType: TextBaseline.alphabetic,
                        baseline: kIsWeb ? (1.5 * 18 - 1.5 * 18 / 4) : (1.5 * 30 - 1.5 * 30 / 4), //height * textSize - height * textSize / 4;
                        child: const Text(
                          "RETRY",
                          style: TextStyle(height: 1.5, fontSize: kIsWeb ? 18 : 30, fontFamily: "BalooBhaijaan2", color: Colors.white),
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        )
      ]),
    );
  }

  _buildGameWin() {
    return Container(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        FractionallySizedBox(widthFactor: 0.7, child: Image.asset("assets/images/win.png")),
        const SizedBox(
          height: 100,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.grey[100]!.withOpacity(0.5)),
                    backgroundColor: MaterialStateProperty.all(Colors.pinkAccent),
                  ),
                  onPressed: () {
                    SoundHelper.playClickSound();
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Baseline(
                        baselineType: TextBaseline.alphabetic,
                        baseline: kIsWeb ? (1.5 * 18 - 1.5 * 18 / 4) : (1.5 * 30 - 1.5 * 30 / 4), //height * textSize - height * textSize / 4;
                        child: const Text(
                          "MENU",
                          style: TextStyle(height: 1.5, fontSize: kIsWeb ? 18 : 30, fontFamily: "BalooBhaijaan2", color: Colors.white),
                        ),
                      ),
                    ),
                  )),
            ),
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.grey[100]!.withOpacity(0.5)),
                    backgroundColor: MaterialStateProperty.all(Colors.pinkAccent), //Colors.blue
                  ),
                  onPressed: () {
                    SoundHelper.playClickSound();
                    _resetGame();
                    _startGame();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Baseline(
                        baselineType: TextBaseline.alphabetic,
                        baseline: kIsWeb ? (1.5 * 18 - 1.5 * 18 / 4) : (1.5 * 30 - 1.5 * 30 / 4),
                        child: const Text(
                          "PLAY AGAIN",
                          style: TextStyle(height: 1.5, fontSize: kIsWeb ? 18 : 30, fontFamily: "BalooBhaijaan2", color: Colors.white),
                        ),
                      ),
                    ),
                  )),
            ),
          ],
        )
      ]),
    );
  }

  _showPause() {
    // _player.play("pause.mp3", volume: 0.4);
    SoundHelper.playPauseSound(volume: 0.4);
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false, //不透明
        fullscreenDialog: false,
        pageBuilder: (buildContext, a1, a2) => Alert(
          title: "Pause",
          btn1Text: "Restart",
          btn1TextColor: Colors.white,
          btn1Color: Colors.pinkAccent,
          onBtn1Pressed: () {
            SoundHelper.playClickSound();
            _resetGame();
            _startGame();
          },
          btn2Text: "Main Page",
          btn2TextColor: Colors.white,
          btn2Color: Colors.pinkAccent,
          onBtn2Pressed: () {
            SoundHelper.playClickSound();
            _gotoMainPage();
          },
          onCancel: () {
            SoundHelper.playClickSound();
            _startCountdownTime();
            SoundHelper.playResumeSound();
          },
        ),
        transitionsBuilder: (buildContext, a1, a2, child) => FadeTransition(opacity: a1, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  _showIntro() async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false, //不透明
        fullscreenDialog: false,
        pageBuilder: (buildContext, a1, a2) => SpeedPuzzleIntro(),
        transitionsBuilder: (buildContext, a1, a2, child) => FadeTransition(opacity: a1, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
    _startGame();
  }

  _gotoMainPage() {
    Navigator.of(context).pop();
  }
}

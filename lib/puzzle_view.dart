import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:puzzle123/animation_widget.dart';
import 'package:puzzle123/def.dart';
import 'package:puzzle123/models/question.dart';
import 'package:puzzle123/utility/sound_helper.dart';
// import 'package:soundpool/soundpool.dart';

// sound play lag in ios browser, other platform ok
// import 'package:audioplayers/audioplayers.dart';

enum GameState { loadGame, gameStart, complete, animationOut }

class PuzzleViewController {
  void Function()? onGameClear;
  void Function(int)? onChangeStep;
  void Function()? resetGame;
  int Function()? getStep;
  Question Function()? getQuestion;
}

class PuzzleView extends StatefulWidget {
  final PuzzleViewController? controller;
  final QuestionType? questionType;
  final Question? question;
  PuzzleView({Key? key, this.controller, this.questionType, this.question}) : super(key: key);

  @override
  State<PuzzleView> createState() => _PuzzleViewState();
}

class _PuzzleViewState extends State<PuzzleView> {
  PuzzleViewController? _controller;
  GameState _gameState = GameState.loadGame;

  Set<int> _selectedIndexes = <int>{};
  final GlobalKey? key = GlobalKey();
  final Set<_TouchDetectWidget> _trackTaped = <_TouchDetectWidget>{};

  int _colCount = 6; //直的數量
  int _rowCount = 6; //橫的數量
  int? _totalCount;
  final int _checkPointCount = 3;

  int? _currentSelectIdx;
  int? _startIndex;
  List<int> _checkPointList = [];

  final Color _bgColor = Colors.grey.shade100;
  final Color _itemUnselectColor = Colors.grey.shade300; //Color.fromARGB(255, 244, 239, 237);
  final Color _itemselectedColor = const Color(0xFF4CD6AF);

  int _step = 0; //0,1,2,3,4(all)

  //audioplayers
  // AudioCache _player = AudioCache(prefix: 'assets/audios/');
  // final Soundpool _soudPool = Soundpool.fromOptions(options: const SoundpoolOptions(streamType: StreamType.alarm, maxStreams: 10));

  @override
  void didUpdateWidget(PuzzleView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _setController();
  }

  @override
  void initState() {
    super.initState();
    _setController();
    _resetGame();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _playGamepassSound() {
    SoundHelper.playGamepassSound();
  }

  _playBoSound() {
    SoundHelper.playBoSound();
  }

  _playCancelSound() {
    SoundHelper.playCancelSound();
  }

  _setController() {
    _controller = widget.controller;
    _controller?.resetGame = _resetGame;
    _controller?.getStep = _getStep;
    _controller?.getQuestion = _getQuestion;
  }

  _resetGame() {
    switch (widget.questionType) {
      case QuestionType.question3x3:
        _colCount = 3;
        _rowCount = 3;
        break;
      case QuestionType.question4x4:
        _colCount = 4;
        _rowCount = 4;
        break;
      case QuestionType.question5x5:
        _colCount = 5;
        _rowCount = 5;
        break;
      case QuestionType.question6x6:
        _colCount = 6;
        _rowCount = 6;
        break;
      default:
    }
    _totalCount = _colCount * _rowCount;
    _selectedIndexes = <int>{};
    _step = 0;
    _controller?.onChangeStep!(0);

    _resetSelectIdx();
    _clearCheckPoint();
    _generateStartPoint();
    _generateCheckPoint();
    if (mounted) setState(() {});
  }

  int _getStep() {
    return _step;
  }

  Question _getQuestion() {
    if (widget.question != null) {
      return widget.question!;
    } else {
      return Question(
          id: "${_startIndex}_${_checkPointList[0]}_${_checkPointList[1]}_${_checkPointList[2]}",
          startPointIdx: _startIndex,
          checkPointIdxList: _checkPointList,
          checkPointMap: {1: _checkPointList[0], 2: _checkPointList[1], 3: _checkPointList[2]});
    }
  }

  _resetSelectIdx() {
    _currentSelectIdx = null;
    _controller?.onChangeStep!(0);
  }

  _clearCheckPoint() {
    _checkPointList = [];
  }

  _generateStartPoint() {
    if (widget.question != null) {
      _startIndex = widget.question?.startPointIdx;
    } else {
      //隨機生成
      //測試
      // _startPosition = const Offset(3, 3);
      // _startIndex = (_startPosition!.dx * _startPosition!.dy - 1).toInt();
      Random random = Random();
      Offset? startPosition = Offset(
        random.nextInt(_rowCount).toDouble(),
        random.nextInt(_colCount).toDouble(),
      );
      _startIndex = ((startPosition.dy * _rowCount) + startPosition.dx).toInt();

      //測試
      // _startIndex = 0;
    }
  }

  _generateCheckPoint() {
    if (widget.question != null) {
      try {
        _checkPointList = [...widget.question!.checkPointIdxList!];
      } catch (e) {
        debugPrint("$e");
      }
    } else {
      //隨機生成
      //測試
      // _checkPointList.add(2);
      // _checkPointList.add(4);
      // _checkPointList.add(6);
      // return;

      while (_checkPointList.length < _checkPointCount) {
        Random random = Random();
        int num = random.nextInt(_totalCount!);
        if (num != _startIndex && !_checkPointList.contains(num)) {
          _checkPointList.add(num);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext buildContext, BoxConstraints boxConstraints) {
      return Container(
        constraints: BoxConstraints(maxWidth: () {
          if (_rowCount == 3) return boxConstraints.maxWidth * 0.65;
          if (_rowCount == 4) return boxConstraints.maxWidth * 0.8;
          if (_rowCount == 5) return boxConstraints.maxWidth * 0.9;
          return double.infinity;
        }()),
        child: Listener(
          onPointerDown: _onDetectTouch,
          onPointerMove: _onDetectTouch,
          onPointerUp: _clearSelection,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
            ),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(color: _bgColor, borderRadius: BorderRadius.circular(10)),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: GridView.builder(
                  key: key,
                  shrinkWrap: true,
                  itemCount: _totalCount,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _rowCount,
                    childAspectRatio: 1,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemBuilder: (context, index) {
                    //start
                    if (index == _startIndex) {
                      return LayoutBuilder(builder: (BuildContext buildContext, BoxConstraints boxConstraints) {
                        return TouchDetectWidget(
                          index: index,
                          child: Container(
                            margin: EdgeInsets.all(_selectedIndexes.contains(index) ? 1 : 2),
                            padding: EdgeInsets.all(boxConstraints.maxWidth * 0.1),
                            decoration: BoxDecoration(
                                color: _selectedIndexes.contains(index) ? _itemselectedColor : Colors.grey.shade600,
                                borderRadius: BorderRadius.circular(10)),
                            child: const FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  "START",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                )),
                          ),
                        );
                      });
                    }

                    //checkPoint
                    if (_checkPointList.contains(index)) {
                      return LayoutBuilder(builder: (BuildContext buildContext, BoxConstraints boxConstraints) {
                        return TouchDetectWidget(
                          index: index,
                          child: AnimationWidget(
                            index: index,
                            isRunAnimaion: _currentSelectIdx == index,
                            child: Container(
                              margin: EdgeInsets.all(_selectedIndexes.contains(index) ? 1 : 2),
                              padding: EdgeInsets.all(boxConstraints.maxWidth * 0.1),
                              decoration: BoxDecoration(
                                  color: _selectedIndexes.contains(index) ? _itemselectedColor : _itemUnselectColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  "${_checkPointList.indexOf(index) + 1}",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: _selectedIndexes.contains(index) ? Colors.white : Colors.grey, fontSize: 30),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    }
                    return TouchDetectWidget(
                      index: index,
                      child: AnimationWidget(
                        index: index,
                        isRunAnimaion: _currentSelectIdx == index,
                        child: Container(
                          margin: EdgeInsets.all(_selectedIndexes.contains(index) ? 1 : 2),
                          padding: EdgeInsets.all(boxConstraints.maxWidth * 0.1),
                          decoration: BoxDecoration(
                              color: _selectedIndexes.contains(index) ? _itemselectedColor : _itemUnselectColor,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  _onDetectTouch(PointerEvent event) {
    if (_step == 4) return;
    if (key!.currentContext == null) return;
    final box = key!.currentContext!.findRenderObject() as RenderBox;
    box.localToGlobal(Offset.zero);

    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        final target = hit.target;
        if (target is _TouchDetectWidget && !_trackTaped.contains(target) && _canSelect(target.index!)) {
          _trackTaped.add(target);
          _selectIndex(target.index);
          _updateStep(target.index!);
          _checkComplete();
        }
      }
    }
  }

  _updateStep(int newSelectIdx) {
    if (_checkPointList.contains(newSelectIdx)) {
      _step = _checkPointList.indexOf(newSelectIdx) + 1;
      _controller?.onChangeStep!(_step);
    }
  }

  _selectIndex(int? index) {
    if (!mounted) return;

    if (!_selectedIndexes.contains(index)) {
      Random random = Random();
      _currentSelectIdx = index;

      if((_checkPointList.contains(index))){
        SoundHelper.playCheckPointSound();
      }
      _playBoSound();
      setState(() {
        _selectedIndexes.add(index!);
      });
    }
  }

  bool _canSelect(int index) {
    //起始點
    if (_currentSelectIdx == null && index == _startIndex!) {
      return true;
    }

    if (_currentSelectIdx == null) {
      return false;
    }

    if (_checkPointList.contains(index)) {
      if (_checkPointCheck(index)) {
        //left
        if (_currentSelectIdx! - 1 == index && _currentSelectIdx! % _rowCount != 0 && !_selectedIndexes.contains(index)) {
          return true;
        }

        //top
        if (_currentSelectIdx! - _rowCount == index && !_selectedIndexes.contains(index)) {
          return true;
        }

        //right
        if (_currentSelectIdx! + 1 == index && (_currentSelectIdx! + 1) % _rowCount != 0 && !_selectedIndexes.contains(index)) {
          return true;
        }

        //bottom
        if (_currentSelectIdx! + _rowCount == index && !_selectedIndexes.contains(index)) {
          return true;
        }
      }
    } else {
      //left
      if (_currentSelectIdx! - 1 == index && _currentSelectIdx! % _rowCount != 0 && !_selectedIndexes.contains(index)) {
        return true;
      }

      //top
      if (_currentSelectIdx! - _rowCount == index && !_selectedIndexes.contains(index)) {
        return true;
      }

      //right
      if (_currentSelectIdx! + 1 == index && (_currentSelectIdx! + 1) % _rowCount != 0 && !_selectedIndexes.contains(index)) {
        return true;
      }

      //bottom
      if (_currentSelectIdx! + _rowCount == index && !_selectedIndexes.contains(index)) {
        return true;
      }
    }

    return false;
  }

  bool _checkPointCheck(int index) {
    //checkPoint
    if (!_selectedIndexes.contains(index) && _checkPointList.contains(index)) {
      int checkPoinstIndex = _checkPointList.indexOf(index);
      if (checkPoinstIndex == 0) {
        return true;
      } else {
        if (checkPoinstIndex - 1 >= 0) {
          return _selectedIndexes.contains(_checkPointList[checkPoinstIndex - 1]);
        }
      }
    }
    return false;
  }

  void _clearSelection(PointerUpEvent event) {
    //TouchDetectWidget
    if (_step == 4) return;
    if (!mounted) return;
    _playCancelSound();
    _trackTaped.clear();
    setState(() {
      _resetSelectIdx();
      _selectedIndexes.clear();
    });
  }

  _checkComplete() {
    if (_selectedIndexes.length == _colCount * _rowCount) {
      _step = 4;
      _controller?.onChangeStep!(_step);

      if (_step == 4) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _gameClear();
        });
      }
    }
  }

  //過關
  _gameClear() {
    if (_controller?.onGameClear != null) {
      _playGamepassSound();
      _controller?.onGameClear!();
    }
  }
}

class TouchDetectWidget extends SingleChildRenderObjectWidget {
  final int? index;

  const TouchDetectWidget({Widget? child, this.index, Key? key}) : super(child: child, key: key);

  @override
  _TouchDetectWidget createRenderObject(BuildContext context) {
    return _TouchDetectWidget()..index = index!;
  }

  @override
  void updateRenderObject(BuildContext context, _TouchDetectWidget renderObject) {
    renderObject..index = index!;
  }
}

class _TouchDetectWidget extends RenderProxyBox {
  int? index;
}

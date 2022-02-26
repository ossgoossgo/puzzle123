import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:puzzle123/def.dart';
import 'package:puzzle123/game_page.dart';
import 'package:puzzle123/how_to_play.dart';
import 'package:puzzle123/play_all_questions.dart';
import 'package:puzzle123/speed_puzzle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class MainMenuPage extends StatefulWidget {
  MainMenuPage({Key? key}) : super(key: key);

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  int total6x6Count = 0;
  int total6x6ClearCount = 0;

  AudioCache _player = AudioCache(prefix: 'assets/audios/');

  @override
  void initState() {
    super.initState();
    _initSound();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _checkNeedShowHowToPlay();
    });
  }

  _initSound() async {
    _player.load('click.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF6F1EE),
        body: Stack(
          children: [
            Positioned.fill(
              child: SafeArea(
                child: Center(
                  child: Container(
                    constraints: kIsWeb ? BoxConstraints(maxWidth: Def.webMaxWidth) : null,
                    width: double.infinity,
                    // color: Color(0xFFFDFDFD),
                    child: Container(
                      color: kIsWeb ? Colors.white : Colors.transparent,
                      padding: kIsWeb ? const EdgeInsets.symmetric(horizontal: 20) : null,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                        Container(
                          padding: EdgeInsets.only(top: 10, right: 10),
                          width: double.infinity,
                          child: const Text(
                            'v1.0.0',
                            textAlign: TextAlign.end,
                            style: TextStyle(height: 1.5, fontSize: 16, fontFamily: "BalooBhaijaan2"),
                          ),
                        ),
                        Expanded(
                            flex: 7,
                            child: FractionallySizedBox(
                              widthFactor: 0.78,
                              child: Center(child: Image.asset("assets/images/logo.png")),
                            )),
                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: ElevatedButton(
                            onPressed: () {
                              _player.play("click.mp3", volume: 0.3);
                              _gotoSpeedPuzzle();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 5.0,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Baseline(
                                baselineType: TextBaseline.alphabetic,
                                baseline: 1.5 * 25 - 1.5 * 25 / 2,
                                child: Text(
                                  'Speed puzzle',
                                  style: TextStyle(height: 1.5, fontSize: 25, fontFamily: "BalooBhaijaan2"),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: ElevatedButton(
                            onPressed: () {
                              _player.play("click.mp3", volume: 0.3);
                              _gotoPlayAllQuestion();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.pinkAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 5.0,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Baseline(
                                  baselineType: TextBaseline.alphabetic,
                                  baseline: 1.5 * 30 - 1.5 * 30 / 4,
                                  child: Text(
                                    '${question6x6List.length} levels (${question6x6ClearSet.length}/${question6x6List.length})',
                                    style: TextStyle(height: 1.5, fontSize: 30, fontFamily: "BalooBhaijaan2"),
                                  ),
                                ),
                                // Text(
                                //   '${question6x6List.length} levels (${question6x6ClearSet.length}/${question6x6List.length})',
                                //   style: TextStyle(height: 1.5, fontSize: 25, fontFamily: "BalooBhaijaan2"),
                                // ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: ElevatedButton(
                            onPressed: () {
                              _player.play("click.mp3", volume: 0.3);
                              _showHowToPlay();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 5.0,
                            ),
                            child: const Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Baseline(
                                baselineType: TextBaseline.alphabetic,
                                baseline: 1.5 * 25 - 1.5 * 25 / 2,
                                child: Text(
                                  'How to play',
                                  style: TextStyle(height: 1.5, fontSize: 25, fontFamily: "BalooBhaijaan2"),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spacer(flex: 2),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '© 2022 Sheng-wen Wang. All rights reserved.', //'v1.0.0'
                              style: TextStyle(height: 1.5, fontSize: 14, fontFamily: "BalooBhaijaan2"),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  _checkNeedShowHowToPlay() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    if (!sharedPref.containsKey(Def.saveKeySeeHowToPlay)) {
      _showHowToPlay();
      await sharedPref.setBool(Def.saveKeySeeHowToPlay, true);
    }
  }

  _gotoSpeedPuzzle() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (buildContext, a1, a2) => SpeedPuzzle(),
        transitionsBuilder: (buildContext, a1, a2, child) => FadeTransition(opacity: a1, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  _gotoPlayAllQuestion() async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (buildContext, a1, a2) => PlayAllQuestions(type: QuestionType.question6x6),
        transitionsBuilder: (buildContext, a1, a2, child) => FadeTransition(opacity: a1, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
    setState(() {});
  }

  _showHowToPlay() {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        fullscreenDialog: false,
        pageBuilder: (buildContext, a1, a2) => HowToPlay(),
        transitionsBuilder: (buildContext, a1, a2, child) => FadeTransition(opacity: a1, child: child),
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }
}

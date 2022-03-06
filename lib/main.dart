import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puzzle123/add_question.dart';
import 'package:puzzle123/def.dart';
import 'package:puzzle123/game_page.dart';
import 'package:puzzle123/main_menu.dart';
import 'package:puzzle123/models/question.dart';
import 'package:puzzle123/question/question3x3.dart';
import 'package:puzzle123/question/question4x4.dart';
import 'package:puzzle123/question/question5x5.dart';
import 'package:puzzle123/question/question6x6.dart';
import 'package:puzzle123/utility/db_util.dart';
import 'package:desktop_window/desktop_window.dart';
import 'dart:io';

import 'package:puzzle123/utility/sound_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 放這邊windows run不起來,除非加個delay,但怪怪的 
  // 設定windows linux macos視窗大小
  // Future.delayed(Duration(milliseconds: 500), () {
  //   try {
  //     if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //       DesktopWindow.setMinWindowSize(const Size(350, 700));
  //       DesktopWindow.setMaxWindowSize(const Size(400, 800));
  //       DesktopWindow.setWindowSize(const Size(400, 800));
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // });
  await SoundHelper.init();
  await DBUtil.init();

  _initGameQuestions();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) {
    debugPrint("layout: portraint");

    runZonedGuarded(() {
      runApp(App());
    }, (Object error, StackTrace stack) {
      debugPrint("ERROR!! ${stack.toString()} $error");
    });
  });
}

_initGameQuestions() {
  //取得總關卡數
  Iterable iterable1 = json.decode(question3x3Str);
  question3x3List =
      List<Question>.from(iterable1.map((json) => Question.fromJson(json)));

  Iterable iterable2 = json.decode(question4x4Str);
  question4x4List =
      List<Question>.from(iterable2.map((json) => Question.fromJson(json)));

  Iterable iterable3 = json.decode(question5x5Str);
  question5x5List =
      List<Question>.from(iterable3.map((json) => Question.fromJson(json)));

  Iterable iterable4 = json.decode(question6x6Str);
  question6x6List =
      List<Question>.from(iterable4.map((json) => Question.fromJson(json)));

  question6x6ClearSet =
      DBUtil.getQuestionIsClear(type: QuestionType.question6x6);
}

class App extends StatefulWidget {
  App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    _setScreen();
    super.initState();
  }

  _setScreen() async {
    try {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        DesktopWindow.setMinWindowSize(const Size(350, 700));
        DesktopWindow.setMaxWindowSize(const Size(400, 800));
        DesktopWindow.setWindowSize(const Size(400, 800));
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) {
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      home: MainMenuPage(), //MainMenuPage()// GamePage() //AddQuestion
    );
  }
}

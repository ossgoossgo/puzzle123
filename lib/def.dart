import 'package:flutter/material.dart';
import 'package:puzzle123/models/question.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui';

enum QuestionType { question3x3, question4x4, question5x5, question6x6 }

List<Question> question3x3List = [];
List<Question> question4x4List = [];
List<Question> question5x5List = [];
List<Question> question6x6List = [];
Set<String> question6x6ClearSet = {};

class Def {
  static late bool isWebFillLayout; //手機網頁
  static double get webMaxWidth => window.physicalSize.width > 400.0 ? 400.0 : window.physicalSize.width;
  static String saveKeySeeHowToPlay = "seeHowToPlay";
  static String saveKeyLastPlayId = "lastPlayId"; //最後一次玩所有關卡模式的id
}

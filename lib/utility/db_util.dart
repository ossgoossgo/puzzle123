import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
// import 'package:hive/hive.dart';
import 'dart:io';
// import 'package:path_provider/path_provider.dart';
import 'package:puzzle123/def.dart';
import 'package:puzzle123/models/question.dart';
// import 'package:puzzle123/question/question6x6.dart';\
import 'package:hive_flutter/hive_flutter.dart';

class DBUtil {
  static DBUtil? instance;
  late Box question3x3Box;
  late Box question4x4Box;
  late Box question5x5Box;
  late Box question6x6Box;
  late Box questionIsClearBox;

  static Future<void> init() async {
    if (instance == null) {

        await Hive.initFlutter();
      // Directory document = await getApplicationDocumentsDirectory();
      // Hive.init(document.path);
      // 註冊Adapter，此方法要在class宣告HiveField，不能更動順序，彈性不好，不用
      // Hive.registerAdapter(ShoppingCart());
      instance = DBUtil();
      //open box
      //instance.cartBox = await Hive.openBox<ShoppingCart>('shoppingCart');
      // instance.cartBox = await Hive.openBox('shoppingCart');
      // instance.photoBox = await Hive.openBox('photo');
      instance!.question3x3Box = await Hive.openBox('question3x3');
      instance!.question4x4Box = await Hive.openBox('question4x4');
      instance!.question5x5Box = await Hive.openBox('question5x5');
      instance!.question6x6Box = await Hive.openBox('question6x6');
      instance!.questionIsClearBox = await Hive.openBox('questionIsClear');
    }
  }

  static removeAll() {
    instance!.question3x3Box.clear();
    instance!.question4x4Box.clear();
    instance!.question5x5Box.clear();
    instance!.question6x6Box.clear();
    instance!.questionIsClearBox.clear();
  }

  /*
  static Future addCartItemPhotoInfo({@required String itemID, CartItemPhotoInfo cartItemPhotoInfo, DiyFlashCardsInfo diyFlashCardsInfo}) async {
    //原本joyphoto圖片資訊(一張一張存) itemID = "${cartItemID}_${assetpathentityID}_$assetentityID";
    if (cartItemPhotoInfo != null) {
      return DBUtil.instance.cartItemPhotoInfoBox.put(itemID, cartItemPhotoInfo.toString());
    }
    //閃卡圖片資訊(全部存一起) itemID = 購物車ID;
    if (diyFlashCardsInfo != null) {
      return DBUtil.instance.cartItemPhotoInfoBox.put(itemID, diyFlashCardsInfo.toString());
    }
  }

  static Future deleteCartItemPhotoInfo({@required String itemID}) async {
    return DBUtil.instance.cartItemPhotoInfoBox.delete(itemID);
  }

  static Future deleteAllCartItemPhotoInfo() async {
    return DBUtil.instance.cartItemPhotoInfoBox.clear();
  }

  static CartItemPhotoInfo getCartItemInfo({@required String itemID}) {
    String jsonStr = DBUtil.instance.cartItemPhotoInfoBox.get(itemID);
    if (jsonStr != null) {
      try {
        return CartItemPhotoInfo.fromJson(json.decode(jsonStr));
      } catch (e) {
        print(e);
        return null;
      }
    } else {
      return null;
    }
  }
  */

  //type = 3x3, 4x4, 5x5, 6x6
  static Future addQuestion({required QuestionType type, required String id, required String dataStr}) async {
    switch (type) {
      case QuestionType.question3x3:
        DBUtil.instance!.question3x3Box.put(id, dataStr);
        debugPrint("3x3 length: ${DBUtil.instance!.question3x3Box.length}");
        break;
      case QuestionType.question4x4:
        DBUtil.instance!.question4x4Box.put(id, dataStr);
        debugPrint("4x4 length: ${DBUtil.instance!.question4x4Box.length}");
        break;
      case QuestionType.question5x5:
        DBUtil.instance!.question5x5Box.put(id, dataStr);
        debugPrint("5x5 length: ${DBUtil.instance!.question5x5Box.length}");
        break;
      case QuestionType.question6x6:
        DBUtil.instance!.question6x6Box.put(id, dataStr);
        debugPrint("6x6 length: ${DBUtil.instance!.question6x6Box.length}");
        break;
      default:
    }
  }

  static Future deleteQuest({required QuestionType type, required String id}) async {
    Box? box;
    switch (type) {
      case QuestionType.question3x3:
        box = DBUtil.instance!.question3x3Box;
        break;
      case QuestionType.question4x4:
        box = DBUtil.instance!.question4x4Box;
        break;
      case QuestionType.question5x5:
        box = DBUtil.instance!.question5x5Box;
        break;
      case QuestionType.question6x6:
        box = DBUtil.instance!.question6x6Box;
        break;
      default:
    }
    await box!.delete(id);
  }

  static List<Question> getAllQuestion({required QuestionType type}) {
    Box? box;
    switch (type) {
      case QuestionType.question3x3:
        box = DBUtil.instance!.question3x3Box;
        break;
      case QuestionType.question4x4:
        box = DBUtil.instance!.question4x4Box;
        break;
      case QuestionType.question5x5:
        box = DBUtil.instance!.question5x5Box;
        break;
      case QuestionType.question6x6:
        box = DBUtil.instance!.question6x6Box;
        break;
      default:
    }

    List<Question> list = [];
    final values = box!.values.toList();
    for (var i = 0; i < values.length; i++) {
      try {
        list.add(Question.fromJson(json.decode(values[i])));
      } catch (e) {
        debugPrint("$e");
      }
    }
    return list;
  }

  static Future<int> getQuestionLength({required QuestionType type}) async {
    switch (type) {
      case QuestionType.question3x3:
        debugPrint("3x3 length: ${DBUtil.instance!.question3x3Box.length}");
        return DBUtil.instance!.question3x3Box.length;
      case QuestionType.question4x4:
        debugPrint("4x4 length: ${DBUtil.instance!.question4x4Box.length}");
        return DBUtil.instance!.question4x4Box.length;
      case QuestionType.question5x5:
        debugPrint("5x5 length: ${DBUtil.instance!.question5x5Box.length}");
        return DBUtil.instance!.question5x5Box.length;
      case QuestionType.question6x6:
        debugPrint("6x6 length: ${DBUtil.instance!.question6x6Box.length}");
        return DBUtil.instance!.question6x6Box.length;
      default:
        return 0;
    }
  }

  static Future saveQuestionIsClear({required QuestionType type, required Set data}) async {
    late String key;
    switch (type) {
      case QuestionType.question3x3:
        key = "3x3";
        break;
      case QuestionType.question4x4:
        key = "4x4";
        break;
      case QuestionType.question5x5:
        key = "5x5";
        break;
      case QuestionType.question6x6:
        key = "6x6";
        break;
      default:
        key = "3x3";
    }

    String json = jsonEncode(data.toList());
    DBUtil.instance!.questionIsClearBox.put(key, json);
  }

  static Set<String> getQuestionIsClear({required QuestionType type}) {
    late String key;
    switch (type) {
      case QuestionType.question3x3:
        key = "3x3";
        break;
      case QuestionType.question4x4:
        key = "4x4";
        break;
      case QuestionType.question5x5:
        key = "5x5";
        break;
      case QuestionType.question6x6:
        key = "6x6";
        break;
      default:
        key = "3x3";
    }

    String? jsonStr = DBUtil.instance!.questionIsClearBox.get(key);
    if (jsonStr != null) {
      List<String> list = List<String>.from(jsonDecode(jsonStr));
      Set<String> set = list.toSet();
      return set;
    } else {
      return <String>{};
    }
  }

  //匯出存成txt用
  static convertAllQuestionToJson({required QuestionType type}) {
    List<Question> list = getAllQuestion(type: type);
    String jsonStr = jsonEncode(list);
    print(jsonStr);

    try {
      Iterable l = json.decode(jsonStr);
      List<Question> list2 = List<Question>.from(l.map((json) => Question.fromJson(json)));
      print(list2);

      //讀取文件測試
      // Iterable l = json.decode(question6x6Str);
      // List<Question> list2 = List<Question>.from(l.map((json)=> Question.fromJson(json)));
      // print(list2);

    } catch (e) {
      print(e);
    }
  }
}

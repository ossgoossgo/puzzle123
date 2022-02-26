import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:puzzle123/def.dart';
part 'question.g.dart';

@JsonSerializable()
class Question {
  String? id; //startPointIdx_point1Idx_point2Idx_point3Idx
  QuestionType? type;
  int? startPointIdx;
  List<int>? checkPointIdxList; //[index, index, index]
  Map<int, int>? checkPointMap; //1:index, 2:index 3:index

  @JsonKey(defaultValue: false)
  bool? isClear; //是否通關

  Question({required this.id, this.type, this.startPointIdx, this.checkPointIdxList, this.checkPointMap, this.isClear = false});

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  @override
  String toString() {
    return JsonEncoder().convert(toJson());
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      id: json['id'] as String?,
      type: $enumDecodeNullable(_$QuestionTypeEnumMap, json['type']),
      startPointIdx: json['startPointIdx'] as int?,
      checkPointIdxList: (json['checkPointIdxList'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      checkPointMap: (json['checkPointMap'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k), e as int),
      ),
      isClear: json['isClear'] as bool? ?? false,
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'type': _$QuestionTypeEnumMap[instance.type],
      'startPointIdx': instance.startPointIdx,
      'checkPointIdxList': instance.checkPointIdxList,
      'checkPointMap':
          instance.checkPointMap?.map((k, e) => MapEntry(k.toString(), e)),
      'isClear': instance.isClear,
    };

const _$QuestionTypeEnumMap = {
  QuestionType.question3x3: 'question3x3',
  QuestionType.question4x4: 'question4x4',
  QuestionType.question5x5: 'question5x5',
  QuestionType.question6x6: 'question6x6',
};

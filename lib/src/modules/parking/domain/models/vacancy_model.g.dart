// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vacancy_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VacancyModel _$VacancyModelFromJson(Map<String, dynamic> json) => VacancyModel(
      id: json['id'] as String?,
      number: json['number'] as int?,
      plate: json['plate'] as String?,
      status: $enumDecodeNullable(_$VacancyStatusEnumEnumMap, json['status']) ??
          VacancyStatusEnum.released,
      entryTime: json['entryTime'] == null
          ? null
          : DateTime.parse(json['entryTime'] as String),
      exitTime: json['exitTime'] == null
          ? null
          : DateTime.parse(json['exitTime'] as String),
    );

Map<String, dynamic> _$VacancyModelToJson(VacancyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'plate': instance.plate,
      'status': _$VacancyStatusEnumEnumMap[instance.status]!,
      'entryTime': instance.entryTime?.toIso8601String(),
      'exitTime': instance.exitTime?.toIso8601String(),
    };

const _$VacancyStatusEnumEnumMap = {
  VacancyStatusEnum.released: 'released',
  VacancyStatusEnum.busy: 'busy',
};

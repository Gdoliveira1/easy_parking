import "package:easy_parking/src/modules/parking/domain/enums/vacancy_status_enum.dart";
import "package:json_annotation/json_annotation.dart";

part "vacancy_model.g.dart";

@JsonSerializable()
class VacancyModel {
  late String? id;
  late int? number;
  late String? plate;
  late VacancyStatusEnum status;
  late DateTime? entryTime;
  late DateTime? exitTime;

  VacancyModel({
    this.id,
    this.number,
    this.plate,
    this.status = VacancyStatusEnum.released,
    this.entryTime,
    this.exitTime,
  });

  factory VacancyModel.fromJson(Map<String, dynamic> json) =>
      _$VacancyModelFromJson(json);

  Map<String, dynamic> toJson() => _$VacancyModelToJson(this);
}

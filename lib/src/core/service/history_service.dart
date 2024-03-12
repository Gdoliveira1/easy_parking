import "package:easy_parking/src/core/repositories/history_repository.dart";
import "package:easy_parking/src/modules/parking/domain/enums/vacancy_status_enum.dart";
import "package:easy_parking/src/modules/parking/domain/models/vacancy_model.dart";

class HistoryService {
  HistoryService._internal();

  factory HistoryService() {
    return _instance;
  }
  static final HistoryService _instance = HistoryService._internal();

  static HistoryService get instance => _instance;

  final HistoryRepository _repository = HistoryRepository.instance;

  Future<void> saveVacancy(VacancyModel vacancy) async {
    final Map<String, dynamic> row = {
      "id": vacancy.id,
      "number": vacancy.number,
      "plate": vacancy.plate,
      "entryTime": vacancy.entryTime!.millisecondsSinceEpoch,
      "status": vacancy.status.title
    };
    await _repository.createVacancy(row);
  }

  Future<void> updateVacancy(VacancyModel vacancy) async {
    await _repository.updateVacancy(vacancy);
  }

  Future<List<VacancyModel>> getAllVacancies() async {
    final List<Map<String, dynamic>> rows = await _repository.getAllVacancies();
    return rows.map((row) {
      return VacancyModel(
          id: row["id"],
          number: row["number"],
          plate: row["plate"],
          entryTime: DateTime.fromMillisecondsSinceEpoch(row["entryTime"]),
          exitTime: row["exitTime"] != null
              ? DateTime.fromMillisecondsSinceEpoch(row["exitTime"])
              : null,
          status: VacancyStatusEnum.values
              .firstWhere((item) => item.title == row["status"]));
    }).toList();
  }
}

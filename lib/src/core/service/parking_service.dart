import "dart:async";

import "package:easy_parking/src/core/helpers/random_helper.dart";
import "package:easy_parking/src/core/service/history_service.dart";
import "package:easy_parking/src/modules/parking/domain/enums/vacancy_status_enum.dart";
import "package:easy_parking/src/modules/parking/domain/models/vacancy_model.dart";

class ParkingService {
  ParkingService._internal();

  static final ParkingService _instance = ParkingService._internal();

  static ParkingService get instance => _instance;

  static bool _hasInit = false;

  static Future<void> init() async {
    if (!_hasInit) {
      _hasInit = true;
      await _instance._init();
    }
  }

  late List<VacancyModel> _histories = [];

  List<VacancyModel> get vacancies => _vacancies;

  final HistoryService _historyService = HistoryService.instance;

  final StreamController<List<VacancyModel>> _vacanciesController =
      StreamController<List<VacancyModel>>.broadcast();

  Stream<List<VacancyModel>> get vacanciesStream => _vacanciesController.stream;

  List<VacancyModel> get histories => _histories;

  late final List<VacancyModel> _vacancies = List<VacancyModel>.generate(
    10,
    (index) => VacancyModel(number: index + 1),
  );

  Future<void> addVacancy(VacancyModel vacancy) async {
    _updateVacancyDetails(vacancy);
    await _addToHistory(vacancy);

    _updateParking();
  }

  Future<void> handleExitVacancy(VacancyModel vacancy) async {
    final int index = _vacancies.indexWhere(
        (entry) => entry.number == vacancy.number && entry.id == vacancy.id);

    _vacancies[index].status = VacancyStatusEnum.released;
    _vacancies[index].exitTime = DateTime.now();

    await _historyService.updateVacancy(vacancy);

    _addStatusToHistory(vacancy);

    _updateParking();
  }

  Future<void> _init() async {
    await _load();
  }

  Future<void> _addToHistory(VacancyModel vacancy) async {
    final VacancyModel vacancyHistory = VacancyModel(
      id: vacancy.id,
      number: vacancy.number,
      plate: vacancy.plate,
      entryTime: vacancy.entryTime,
      status: vacancy.status,
    );

    _histories.add(vacancyHistory);
    print("HISTORIES  ${_histories.map((e) => e.id)}");
    await _historyService.saveVacancy(vacancy);
  }

  void _addStatusToHistory(VacancyModel vacancy) {
    final int index = _histories.indexWhere((entry) => entry.id == vacancy.id);

    _histories[index].status = VacancyStatusEnum.released;
    _histories[index].exitTime = DateTime.now();
  }

  void _updateVacancyDetails(VacancyModel vacancy) {
    final int index =
        _vacancies.indexWhere((element) => element.number == vacancy.number);

    _vacancies[index].id = RandomHelper.identifier(size: 8);
    _vacancies[index].status = VacancyStatusEnum.busy;
    _vacancies[index].plate = vacancy.plate;
    _vacancies[index].number = vacancy.number;
    _vacancies[index].entryTime = DateTime.now();
  }

  Future<void> _load() async {
    _histories = await _historyService.getAllVacancies();

    for (final historyVacancy in _histories) {
      final int index = _vacancies.indexWhere((vacancy) =>
          vacancy.number == historyVacancy.number &&
          vacancy.status != historyVacancy.status);

      if (index != -1) {
        _vacancies[index] = historyVacancy;
      }
    }

    _updateParking();
  }

  void _updateParking() async {
    _vacanciesController.sink.add(_vacancies);
  }
}

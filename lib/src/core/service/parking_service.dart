import "dart:async";

import "package:easy_parking/src/core/helpers/random_helper.dart";
import "package:easy_parking/src/modules/parking/domain/enums/vacancy_status_enum.dart";
import "package:easy_parking/src/modules/parking/domain/models/vacancy_model.dart";

class ParkingService {
  ParkingService._internal();

  factory ParkingService() {
    return _instance;
  }

  final List<VacancyModel> _history = [];

  static final ParkingService _instance = ParkingService._internal();

  static ParkingService get instance => _instance;

  List<VacancyModel> get vacancys => _listVacancies;

  final StreamController<List<VacancyModel>> _vacanciesController =
      StreamController<List<VacancyModel>>.broadcast();

  Stream<List<VacancyModel>> get vacanciesStream => _vacanciesController.stream;

  List<VacancyModel> get history => _history;

  final List<VacancyModel> _listVacancies =
      List<VacancyModel>.generate(10, (index) {
    return VacancyModel(number: index + 1);
  });

  void addVacancy(VacancyModel vacancy) {
    _updateVacancyDetails(vacancy);
    _addToHistory(vacancy);

    _updateParking();
  }

  void handleExitVacancy(VacancyModel vacancy) {
    final int index =
        _listVacancies.indexWhere((entry) => entry.id == vacancy.id);

    _listVacancies[index].status = VacancyStatusEnum.released;
    _listVacancies[index].exitTime = DateTime.now();

    _addStatusToHistory(vacancy);
    _updateParking();
  }

  void _addToHistory(VacancyModel vacancy) {
    final VacancyModel vacancyHistory = VacancyModel(
      id: vacancy.id,
      number: vacancy.number,
      plate: vacancy.plate,
      entryTime: vacancy.entryTime,
      status: vacancy.status,
    );
    _history.add(vacancyHistory);
  }

  void _addStatusToHistory(VacancyModel vacancy) {
    final int index = _history.indexWhere((entry) => entry.id == vacancy.id);

    _history[index].status = VacancyStatusEnum.released;
    _history[index].exitTime = DateTime.now();
  }

  void _updateVacancyDetails(VacancyModel vacancy) {
    final int index = _listVacancies
        .indexWhere((element) => element.number == vacancy.number);

    _listVacancies[index].id = RandomHelper.identifier(size: 8);
    _listVacancies[index].status = VacancyStatusEnum.busy;
    _listVacancies[index].entryTime = DateTime.now();
  }

  void _updateParking() {
    _vacanciesController.sink.add(_listVacancies);
  }
}

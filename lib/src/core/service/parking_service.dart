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

  late List<VacancyModel> _historys = [];

  List<VacancyModel> get vacancys => _listVacancies;

  final HistoryService _historyService = HistoryService.instance;

  final StreamController<List<VacancyModel>> _vacanciesController =
      StreamController<List<VacancyModel>>.broadcast();

  Stream<List<VacancyModel>> get vacanciesStream => _vacanciesController.stream;

  List<VacancyModel> get historys => _historys;

  late List<VacancyModel> _listVacancies = [];

  void addVacancy(VacancyModel vacancy) async {
    _updateVacancyDetails(vacancy);
    await _addToHistory(vacancy);

    _updateParking();
  }

  Future<void> handleExitVacancy(VacancyModel vacancy) async {
    final int index =
        _listVacancies.indexWhere((entry) => entry.id == vacancy.id);

    _listVacancies[index].status = VacancyStatusEnum.released;
    _listVacancies[index].exitTime = DateTime.now();
    print(vacancy.toJson());

    _addStatusToHistory(vacancy);
    await _historyService.updateVacancy(vacancy);

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

    _historys.add(vacancyHistory);

    await _historyService.saveVacancy(vacancy);
  }

  void _addStatusToHistory(VacancyModel vacancy) {
    final int index = _historys.indexWhere((entry) => entry.id == vacancy.id);

    _historys[index].status = VacancyStatusEnum.released;
    _historys[index].exitTime = DateTime.now();
  }

  void _updateVacancyDetails(VacancyModel vacancy) {
    final int index = _listVacancies
        .indexWhere((element) => element.number == vacancy.number);

    _listVacancies[index].id = RandomHelper.identifier(size: 8);
    _listVacancies[index].status = VacancyStatusEnum.busy;
    _listVacancies[index].plate = vacancy.plate;
    _listVacancies[index].number = vacancy.number;
    _listVacancies[index].entryTime = DateTime.now();
  }

  Future<void> _load() async {
    // Carrega as vagas do histórico do banco de dados
    List<VacancyModel> historyVacancies =
        await _historyService.getAllVacancies();

    // Ordena as vagas do histórico por número, para garantir consistência
    historyVacancies.sort((a, b) => a.number!.compareTo(b.number!));

    // Limita a quantidade de vagas do histórico para 10 ou menos
    if (historyVacancies.length > 10) {
      historyVacancies = historyVacancies.sublist(0, 10);
    }

    // Preenche a lista de vagas com as informações do histórico
    _listVacancies = List<VacancyModel>.generate(10, (index) {
      if (index < historyVacancies.length) {
        return historyVacancies[index];
      } else {
        return VacancyModel(number: index + 1);
      }
    });

    // Atualiza o fluxo com a lista atualizada de vagas no estacionamento
    _updateParking();
  }

  void _updateParking() async {
    _vacanciesController.sink.add(_listVacancies);
  }
}

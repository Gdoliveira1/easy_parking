import "package:easy_parking/src/core/controllers/notification_controller.dart";
import "package:easy_parking/src/core/service/parking_service.dart";
import "package:easy_parking/src/domain/models/response_status_model.dart";
import "package:easy_parking/src/modules/parking/bloc/parking_state.dart";
import "package:easy_parking/src/modules/parking/domain/models/vacancy_model.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class ParkingCubit extends Cubit<ParkingState> {
  ParkingCubit() : super(const ParkingState()) {
    _init();
  }

  final ParkingService _parkingService = ParkingService.instance;

  List<VacancyModel> _vacancys = [];

  void _init() {
    _loadParking();
    _startListeners();
  }

  void _loadParking() {
    _vacancys = _parkingService.vacancies;
    _update();
    return;
  }

  void _startListeners() {
    _parkingService.vacanciesStream.listen((vacancys) {
      _vacancys = vacancys;
      _update();
    });
  }

  Future<void> handleCreateVacancy(VacancyModel vacancy) async {
    await _parkingService.addVacancy(vacancy);

    NotificationController.alert(
        response:
            ResponseStatusModel(message: "Entrada Cadastrada com Sucesso"));

    _update();
  }

  Future<void> handleExitVacancy(VacancyModel vacancy) async {
    await _parkingService.handleExitVacancy(vacancy);

    NotificationController.alert(
        response: ResponseStatusModel(message: "Saida Feita com Sucesso"));

    _update();
  }

  /// Updates the vacancy state with the latest vacancys.
  void _update() {
    emit(state.copyWith(
      status: ParkingStatus.initial,
      vacancys: _vacancys,
    ));
  }
}

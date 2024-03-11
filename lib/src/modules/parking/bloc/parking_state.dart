import "package:easy_parking/src/modules/parking/domain/models/vacancy_model.dart";
import "package:equatable/equatable.dart";

enum ParkingStatus { initial, loading }

class ParkingState extends Equatable {
  final ParkingStatus status;
  final List<VacancyModel>? vacancys;
  final bool isRefresh;

  const ParkingState({
    this.status = ParkingStatus.loading,
    this.vacancys = const [],
    this.isRefresh = false,
  });

  ParkingState copyWith({
    ParkingStatus? status,
    List<VacancyModel>? vacancys,
  }) {
    return ParkingState(
      status: status ?? this.status,
      vacancys: vacancys ?? this.vacancys ?? [],
      isRefresh: !isRefresh,
    );
  }

  @override
  List<Object?> get props => [
        status,
        vacancys,
        isRefresh,
      ];
}

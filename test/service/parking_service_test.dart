import "package:easy_parking/src/core/service/parking_service.dart";
import "package:easy_parking/src/modules/parking/domain/enums/vacancy_status_enum.dart";
import "package:easy_parking/src/modules/parking/domain/models/vacancy_model.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  group("ParkingService", () {
    late ParkingService parkingService;

    setUp(() {
      parkingService = ParkingService.instance;
    });

    test("addVacancy adds vacancy to history with unique ID", () {
      final vacancy = VacancyModel(
        number: 1,
        plate: "ABC1234",
        entryTime: DateTime.now(),
        status: VacancyStatusEnum.busy,
      );

      parkingService.addVacancy(vacancy);

      expect(parkingService.history.length, equals(1));
      expect(parkingService.history[0].id, isNotNull);
      expect(parkingService.history[0].id, isNotEmpty);
    });

    test("addStatusToHistory updates vacancy status and exit time", () {
      final vacancy = VacancyModel(
        number: 3,
        plate: "DEF9012",
        entryTime: DateTime.now(),
        status: VacancyStatusEnum.busy,
      );

      parkingService.addVacancy(vacancy);

      final exitVacancy = VacancyModel(
        id: vacancy.id,
        number: vacancy.number,
        plate: vacancy.plate,
        entryTime: vacancy.entryTime,
        status: vacancy.status,
      );

      parkingService.handleExitVacancy(exitVacancy);

      expect(parkingService.history.last.status,
          equals(VacancyStatusEnum.released));
      expect(parkingService.history.last.exitTime, isNotNull);
    });
  });
}

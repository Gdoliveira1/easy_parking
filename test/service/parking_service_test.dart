import "package:easy_parking/src/core/helpers/random_helper.dart";
import "package:easy_parking/src/core/service/parking_service.dart";
import "package:easy_parking/src/modules/parking/domain/enums/vacancy_status_enum.dart";
import "package:easy_parking/src/modules/parking/domain/models/vacancy_model.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

void main() {
  group("ParkingService", () {
    late ParkingService parkingService;
    late VacancyModel vacancy;

    setUpAll(() {
      sqfliteFfiInit();

      databaseFactory = databaseFactoryFfi;
      TestWidgetsFlutterBinding.ensureInitialized();
      WidgetsFlutterBinding.ensureInitialized();
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
              const MethodChannel("plugins.flutter.io/path_provider"),
              (methodCall) async {
        return ".";
      });
    });

    setUp(() async {
      parkingService = ParkingService.instance;
      vacancy = VacancyModel(
        id: RandomHelper.identifier(size: 8),
        number: 1,
        plate: "ABC1234",
        entryTime: DateTime.now(),
        // status: VacancyStatusEnum.busy,
      );
    });

    test("addVacancy adds vacancy to history with unique ID", () async {
      // final vacancy = VacancyModel(
      //   id: RandomHelper.identifier(size: 8),
      //   number: 1,
      //   plate: "ABC1234",
      //   entryTime: DateTime.now(),
      //   status: VacancyStatusEnum.busy,
      // );

      await parkingService.addVacancy(vacancy);

      expect(parkingService.histories.length, equals(1));
      expect(parkingService.histories[0].id, isNotNull);
      expect(parkingService.histories[0].id, isNotEmpty);
    });

    test("Exiting a vacancy should mark it as released and update history",
        () async {
      if (parkingService.histories.isNotEmpty) {
        parkingService.vacancies.last = VacancyModel();
        parkingService.histories.clear();
        await parkingService.addVacancy(vacancy);
      }

      parkingService.vacancies[vacancy.number!].id = vacancy.id;
      parkingService.vacancies[vacancy.number!].exitTime = DateTime.now();
      parkingService.vacancies[vacancy.number!].status =
          VacancyStatusEnum.released;

      // final int index = parkingService.vacancies
      //     .indexWhere((entry) => entry.id == vacancy.id);
      // Act
      await parkingService.handleExitVacancy(vacancy);

      // Assert
      expect(parkingService.histories.first.status,
          equals(VacancyStatusEnum.released));
      expect(parkingService.histories.first.exitTime, isNotNull);
    });
  });
}

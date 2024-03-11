import "package:easy_parking/src/modules/parking/domain/models/vacancy_model.dart";
import "package:easy_parking/src/modules/parking/widgets/create_vacancy_modal.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  testWidgets("CreateVacancyModal should display correctly", (tester) async {
    final VacancyModel vacancy = VacancyModel(number: 1);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CreateVacancyModal(
          vacancy: vacancy,
          onCreateVacancy: (vacancy) {},
        ),
      ),
    ));

    expect(find.text("Cadastrar Caminhão"), findsOneWidget);
    expect(find.text("Número da Placa"), findsOneWidget);
    expect(find.text("Número da Vaga: 1"), findsOneWidget);
    expect(find.text("Salvar"), findsOneWidget);
    expect(find.text("Cancelar"), findsOneWidget);
  });

  testWidgets("CreateVacancyModal should validate plate input", (tester) async {
    final VacancyModel vacancy = VacancyModel(number: 1);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: CreateVacancyModal(
          vacancy: vacancy,
          onCreateVacancy: (vacancy) {},
        ),
      ),
    ));

    final textFormField = find.byType(TextFormField);
    await tester.enterText(textFormField, "");
    await tester.pump();

    expect(find.text("Por favor, digite o número da placa"), findsOneWidget);

    await tester.enterText(textFormField, "ABC123");
    await tester.pump();

    expect(find.text("Por favor, digite o número da placa"), findsNothing);
  });
}

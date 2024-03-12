import "dart:async";
import "package:easy_parking/src/domain/constants/app_assets.dart";
import "package:easy_parking/src/domain/constants/app_colors.dart";
import "package:easy_parking/src/domain/constants/app_text_styles.dart";
import "package:easy_parking/src/modules/parking/bloc/parking_cubit.dart";
import "package:easy_parking/src/modules/parking/bloc/parking_state.dart";
import "package:easy_parking/src/modules/parking/domain/models/vacancy_model.dart";
import "package:easy_parking/src/modules/parking/parking_module.dart";
import "package:easy_parking/src/modules/parking/widgets/create_vacancy_modal.dart";
import "package:easy_parking/src/modules/parking/widgets/custom_info_bar.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_modular/flutter_modular.dart"
    hide ModularWatchExtension;

class HomeParkingView extends StatefulWidget {
  const HomeParkingView({super.key});

  @override
  State<HomeParkingView> createState() => _HomeParkingViewState();
}

class _HomeParkingViewState extends State<HomeParkingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Controle do Estacionamento"),
      ),
      body: BlocBuilder<ParkingCubit, ParkingState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    CustomInfoBar(),
                    SizedBox(height: 26),
                    Text(
                      "Clique no Número que Deseja Dar Entrada ou Saida",
                      style: AppTextStyles.black16w500,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.spaceEvenly,
                  spacing: 15,
                  children: state.vacancys != null
                      ? state.vacancys!
                          .map(
                            (vacancy) => _buildVacancyItem(vacancy),
                          )
                          .toList()
                          .cast<Widget>()
                      : [Container()],
                ),
              ),
              const SizedBox(height: 20),
              _buildButton(
                  onPressed: () {
                    Modular.to.navigate(routeParkingHistory);
                  },
                  title: "Histórico"),
            ],
          );
        },
      ),
    );
  }

  Widget _buildVacancyItem(VacancyModel vacancy) {
    final bool occupied = vacancy.status.title.contains("Ocupado");

    return GestureDetector(
      onTap: () => showDialogVacancy(vacancy, onCreateVacancy: (vacancy) async {
        await context.read<ParkingCubit>().handleCreateVacancy(vacancy);
      }),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.4,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: occupied ? AppColors.pastelPink : AppColors.zanah,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: occupied ? vacancyOccupied(vacancy) : Text("${vacancy.number}"),
      ),
    );
  }

  Widget vacancyOccupied(
    VacancyModel vacancy,
  ) {
    return Container(
      height: 100,
      width: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.pastelPink,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            vacancy.plate!,
            style: const TextStyle(
              fontSize: 12,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: AppColors.white,
                  offset: Offset(3.0, 4.0),
                ),
              ],
            ),
          ),
          Image.asset(
            AppAssets.truck,
            height: 30,
          ),
        ],
      ),
    );
  }

  void showDialogVacancy(
    VacancyModel item, {
    required dynamic Function(VacancyModel) onCreateVacancy,
  }) {
    final bool vacancyOccupied = item.status.title.contains("Ocupado");
    final bool vacancyReleased =
        item.plate != null && item.status.title.contains("Liberado");

    final String vacancyTitle =
        vacancyOccupied ? "Vaga ocupada" : "Vaga liberada";
    final String vacancyDescription = !vacancyReleased && vacancyOccupied
        ? "Dados do caminhão\n"
        : "Dados do último caminhão\n";

    final String truckInformation = item.plate != null
        ? "Placa: ${item.plate} \nHorário: ${item.entryTime!.hour}h:${item.entryTime!.minute}min:${item.entryTime!.second}s \nVaga: ${item.number}"
        : "Vaga: ${item.number}";

    final Text description = item.plate != null
        ? Text(vacancyDescription)
        : const Text("Nenhum caminhão cadastrado!\n");

    return unawaited(showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          surfaceTintColor: Colors.transparent,
          title: Text(vacancyTitle),
          content: SizedBox(
            width: 400,
            height: 200,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                description,
                Text(truckInformation),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButton(
                    onPressed: () {
                      Modular.to.pop();
                      if (vacancyOccupied) {
                        Modular.get<ParkingCubit>().handleExitVacancy(item);
                        return;
                      }

                      unawaited(showDialog(
                        context: context,
                        builder: (context) => CreateVacancyModal(
                            vacancy: item, onCreateVacancy: onCreateVacancy),
                      ));
                      return;
                    },
                    title: vacancyOccupied ? "Saida" : "Entrada"),
                _buildButton(
                    onPressed: () {
                      Modular.to.pop();
                    },
                    title: "Fechar"),
              ],
            )
          ],
        );
      },
    ));
  }

  Widget _buildButton({
    required void Function()? onPressed,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(title),
      ),
    );
  }
}

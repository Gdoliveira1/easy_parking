import "package:easy_parking/src/core/service/parking_service.dart";
import "package:easy_parking/src/modules/parking/bloc/parking_cubit.dart";
import "package:easy_parking/src/modules/parking/bloc/parking_state.dart";
import "package:easy_parking/src/modules/parking/domain/enums/vacancy_status_enum.dart";
import "package:easy_parking/src/modules/parking/domain/models/vacancy_model.dart";
import "package:easy_parking/src/modules/parking/parking_module.dart";
import "package:easy_parking/src/shared/custom_message_info.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_modular/flutter_modular.dart"
    hide ModularWatchExtension;

class HistoryParkingView extends StatefulWidget {
  const HistoryParkingView({super.key});

  @override
  State<HistoryParkingView> createState() => _HistoryParkingViewState();
}

class _HistoryParkingViewState extends State<HistoryParkingView> {
  late List<VacancyModel> historys = ParkingService.instance.histories;
  late int entries = 0;
  late int exits = 0;

  late DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text("Histórico"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Modular.to.navigate(routeParkingHome);
          },
        ),
      ),
      body: BlocBuilder<ParkingCubit, ParkingState>(
        builder: (context, state) {
          _processHistory();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Entradas: $entries"),
                    Text("Saídas: $exits"),
                  ],
                ),
              ),
              _buildDateFilter(),
              historys.isEmpty
                  ? const CustomMessageInfo(
                      alignment: Alignment.center,
                      message: "Sem Histórico No Momento",
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: historys.length,
                        itemBuilder: (context, index) {
                          final VacancyModel vacancy = historys[index];
                          return ListTile(
                            title: Text("Vaga ${vacancy.number}"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Placa: ${vacancy.plate}"),
                                Text("Status: ${vacancy.status.title}"),
                                Text(
                                    "Entrada: ${vacancy.entryTime!.hour}h:${vacancy.entryTime!.minute}min:${vacancy.entryTime!.second}s"),
                                Text(
                                    'Saída: ${vacancy.exitTime != null ? '${vacancy.exitTime!.hour}h:${vacancy.exitTime!.minute}min:${vacancy.exitTime!.second}s' : 'Não registrada'}'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDateFilter() {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            _selectDate(context);
          },
          child: Text(
            "Filtrar por Data: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      _filterHistoryByDate(pickedDate);
    }
  }

  void _processHistory() {
    entries = historys
        .where((vacancy) => vacancy.status == VacancyStatusEnum.busy)
        .length;
    exits = historys
        .where((vacancy) => vacancy.status != VacancyStatusEnum.busy)
        .length;
  }

  void _filterHistoryByDate(DateTime selectedDate) {
    setState(() {
      historys = ParkingService.instance.histories
          .where((vacancy) =>
              vacancy.entryTime!.day == selectedDate.day &&
              vacancy.entryTime!.month == selectedDate.month &&
              vacancy.entryTime!.year == selectedDate.year)
          .toList();
    });
  }
}

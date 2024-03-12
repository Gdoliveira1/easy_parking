import "package:easy_parking/src/domain/constants/app_colors.dart";
import "package:easy_parking/src/modules/parking/domain/models/vacancy_model.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_modular/flutter_modular.dart";

class CreateVacancyModal extends StatefulWidget {
  final VacancyModel vacancy;
  final Function(VacancyModel) onCreateVacancy;

  const CreateVacancyModal(
      {required this.vacancy, required this.onCreateVacancy, super.key});

  @override
  State<CreateVacancyModal> createState() => _CreateVacancyModalState();
}

class _CreateVacancyModalState extends State<CreateVacancyModal> {
  final TextEditingController _plateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppColors.whiteSmoke,
      title: const Text("Cadastrar Caminhão"),
      content: SizedBox(
        height: 300,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  "Informe os dados do caminhão e o horário correspondente:"),
              TextFormField(
                controller: _plateController,
                decoration: const InputDecoration(labelText: "Número da Placa"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Por favor, digite o número da placa";
                  }
                  if (value.length < 7) {
                    return "Deve ter pelo menos 7 caracteres";
                  }
                  if (!RegExp(r"^[a-zA-Z]{3}\d{4}$").hasMatch(value)) {
                    return "Placa deve seguir o padrão\n AAA1234";
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r"[a-zA-Z0-9]"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              Text(
                "Número da Vaga: ${widget.vacancy.number!}",
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.vacancy.plate =
                            _plateController.text.toUpperCase();
                        widget.onCreateVacancy(widget.vacancy);
                        Modular.to.pop();
                      }
                    },
                    child: const Text("Salvar"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancelar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

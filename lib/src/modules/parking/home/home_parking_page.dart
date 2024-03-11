import "package:easy_parking/src/modules/parking/bloc/parking_cubit.dart";
import "package:easy_parking/src/modules/parking/home/home_parking_view.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_modular/flutter_modular.dart";

class HomeParkingPage extends StatefulWidget {
  const HomeParkingPage({super.key});

  @override
  State<HomeParkingPage> createState() => _HomeParkingPageState();
}

class _HomeParkingPageState extends State<HomeParkingPage> {
  final ParkingCubit _parkingCubit = Modular.get<ParkingCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _parkingCubit,
      child: const HomeParkingView(),
    );
  }
}

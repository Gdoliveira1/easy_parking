import "package:easy_parking/src/modules/app_status/bloc/app_status_state.dart";
import "package:easy_parking/src/modules/parking/parking_module.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_modular/flutter_modular.dart";

class AppStatusCubit extends Cubit<AppStatusState> {
  AppStatusCubit() : super(const AppStatusState()) {
    init();
  }

  void init() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      Modular.to.navigate(routeParkingHome);
    });
  }
}

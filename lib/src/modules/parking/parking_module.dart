import "package:easy_parking/src/modules/parking/bloc/parking_cubit.dart";
import "package:easy_parking/src/modules/parking/history/history_parking_page.dart";
import "package:easy_parking/src/modules/parking/home/home_parking_page.dart";
import "package:flutter_modular/flutter_modular.dart";

const String routeParkingHome = "/app/parking/main";
const String routeParkingHistory = "/app/parking/history";

class ParkingModule extends Module {
  final String _home = "/main";
  final String _history = "/history";

  @override
  void binds(i) {
    i.addSingleton(() => ParkingCubit());
  }

  @override
  void routes(r) {
    r.child(_home, child: (__) => const HomeParkingPage());
    r.child(_history, child: (__) => const HistoryParkingPage());
  }
}

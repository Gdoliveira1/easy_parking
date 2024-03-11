import "package:easy_parking/src/modules/parking/parking_module.dart";
import "package:flutter_modular/flutter_modular.dart";

void binds(i) {}

class AppModule extends Module {
  final String _parking = "/parking";

  @override
  void routes(r) {
    r.module(_parking, module: ParkingModule());
  }
}

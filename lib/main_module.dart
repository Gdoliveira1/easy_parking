import "package:easy_parking/src/app_module.dart";
import "package:easy_parking/src/app_wrap_page.dart";
import "package:easy_parking/src/modules/app_status/app_status_module.dart";
import "package:flutter_modular/flutter_modular.dart";

/// A module responsible for defining the main navigation routes and providing singleton instances of core services.
///
/// This module utilizes the Modular package for managing application navigation and dependency injection.
class MainModule extends Module {
  final String _status = "/status";
  final String _initial = "/app";

  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(
      "/",
      child: (_) => const AppWrapPage(),
      transition: TransitionType.noTransition,
      children: [
        ModuleRoute(_status, module: AppStatusModule()),
        ModuleRoute(_initial, module: AppModule()),
      ],
    );
  }
}

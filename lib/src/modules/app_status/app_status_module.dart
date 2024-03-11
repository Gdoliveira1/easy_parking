import "package:easy_parking/src/modules/app_status/loading/app_status_loading_page.dart";
import "package:flutter_modular/flutter_modular.dart";

const String routeAppLoading = "/status/loading";

class AppStatusModule extends Module {
  final String _loading = "/loading";

  @override
  void routes(r) {
    r.child(_loading, child: (__) => const AppStatusLoadingPage());
  }
}

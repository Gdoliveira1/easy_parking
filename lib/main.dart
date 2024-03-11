import "package:easy_parking/main_module.dart";
import "package:easy_parking/src/modules/app_status/app_status_module.dart";
import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ModularApp(module: MainModule(), child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute(routeAppLoading);
    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: "Ubuntu",
      ),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      debugShowCheckedModeBanner: false,
      title: "EasyParking",
    );
  }
}

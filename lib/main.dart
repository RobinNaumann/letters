import 'package:elbe/bit/bit/bit.dart';
import 'package:elbe/elbe.dart';
import 'package:letters/bit/b_installed.dart';
import 'package:letters/view/v_explore.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:moewe/moewe.dart';

import 'bit/b_fonts.dart';

/// This method initializes macos_window_utils and styles the window.
Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig(
    toolbarStyle: NSWindowToolbarStyle.unified,
  );
  await config.apply();
}

void main() async {
  await _configureMacosWindowUtils();
  LoggerService.init(ConsoleLoggerService());
  WidgetsFlutterBinding.ensureInitialized();
  final packageInfo =
      await maybeOr(() async => await PackageInfo.fromPlatform(), null);

  // setup Moewe for crash logging
  await Moewe(
    host: "moewe.robbb.in",
    project: "8d81cd0217d0500f",
    app: "892300188b05e826",
    appVersion: packageInfo?.version ?? "0.0.0",
    buildNumber: int.tryParse(packageInfo?.buildNumber ?? "0") ?? 0,
  ).init();

  moewe.events.appOpen();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
            color: ColorThemeData.fromColor(accent: Colors.blue),
            type: TypeThemeData.preset(),
            geometry: GeometryThemeData.preset()),
        child: BitProvider(
            create: (_) => InstalledBit(),
            child: const MacosApp(
              debugShowCheckedModeBanner: false,
              title: 'Letters',
              home: MyHomePage(),
            )));
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BitProvider(
        create: (_) => FontsBit(),
        child: MacosWindow(child: const ExploreView()));
  }
}

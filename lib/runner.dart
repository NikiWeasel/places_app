import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:places_surf/app/app.dart';
import 'package:places_surf/app/di/app_dependencies.dart';
import 'package:places_surf/router/app_router.dart';
import 'package:yandex_maps_mapkit/init.dart' as init;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> run() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final String mapsKey = dotenv.env['MAPS_API_KEY'] ?? '';

  await init.initMapkit(apiKey: mapsKey);
  AppRouter appRouter = AppRouter();

  await setupDI();

  runApp(App(appRouter: appRouter));
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/utils/preferences.dart';
import 'package:weather/utils/shared.dart';

import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Preferences.init();
  List<String>? cities = Preferences.getCities();
  Shared.cities = (cities == null)
      ? ["Kuala Lumpur", "George Town", "Johor Bahru"]
      : cities;
  await Preferences.setCities(Shared.cities!);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Today',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const HomeScreen(),
      },
    ),
  );
}

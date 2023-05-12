import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/domain/states/city_provider.dart';
import 'package:weatherapp/presentation/ui/views/my_home.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: FlexThemeData.light(scheme: FlexScheme.mandyRed),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.mandyRed),
      themeMode: ThemeMode.system,
      home: ChangeNotifierProvider(
        create: (_) => CityProvider(),
        child: const MyHome(title: 'Weather App'),
      ),
    );
  }
}

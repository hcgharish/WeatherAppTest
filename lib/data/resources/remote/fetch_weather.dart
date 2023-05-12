// ignore_for_file: avoid_print

import 'package:weather/weather.dart';

Future<Weather?> fetchWeather(double lat, double lon) async {
  if (lat != 0 && lon != 0) {
    String key = '6803c5fd9a91efcb38d8ec4f86c50110';

    WeatherFactory wf = WeatherFactory(key);

    Weather weather = await wf.currentWeatherByLocation(lat, lon);
    print('WeatherFactory wf [$weather]');

    return weather;
  }

  return null;
}

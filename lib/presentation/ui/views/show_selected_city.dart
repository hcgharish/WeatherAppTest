// ignore_for_file: avoid_print, library_prefixes, implementation_imports, depend_on_referenced_packages, unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';
import 'package:weatherapp/application/config/cities.dart';
import 'package:weatherapp/data/resources/city_info_model.dart';
import 'package:weatherapp/domain/states/city_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:weatherapp/data/resources/remote/fetch_weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as lAccuracy;

class ShowSelectedCity extends StatefulWidget {
  const ShowSelectedCity({super.key});

  @override
  State<ShowSelectedCity> createState() => _ShowSelectedCityState();
}

class _ShowSelectedCityState extends State<ShowSelectedCity> {
  @override
  void initState() {
    super.initState();

    getWeather();
  }

  getWeather() async {
    final city = Provider.of<CityProvider>(context, listen: false).city;

    Weather? weather = await fetchWeather(city.lat, city.lng);
    setWeatherInfo(weather);

    lPermission();
  }

  setWeatherInfo(Weather? weather) {
    if (weather != null) {
      Provider.of<CityProvider>(context, listen: false).weatherInfo =
          "$weather";
    } else {
      Provider.of<CityProvider>(context, listen: false).weatherInfo = "";
    }
  }

  String getWeatherString() {
    String weatherInfo =
        Provider.of<CityProvider>(context, listen: false).weatherInfo;

    return weatherInfo;
  }

  @override
  Widget build(BuildContext context) {
    final city = Provider.of<CityProvider>(context).city;

    return Column(
      children: [
        InkWell(
          onTap: () {
            bool boolShowCityList =
                Provider.of<CityProvider>(context, listen: false)
                    .boolShowCityList;
            Provider.of<CityProvider>(context, listen: false).boolShowCityList =
                !boolShowCityList;
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 50,
            decoration: BoxDecoration(
              color: Colors.black12.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(city.name),
                const Icon(Icons.arrow_downward),
              ],
            ),
          ),
        ),
      ],
    );
  }

  late LocationSettings locationSettings;

  lPermission() async {
    if (Platform.isAndroid) {
      locationSettings = AndroidSettings(
        accuracy: lAccuracy.LocationAccuracy.best,
        distanceFilter: 100,
        forceLocationManager: true,
        intervalDuration: const Duration(seconds: 10),
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText:
              "Example app will continue to receive your location even when you aren't using it",
          notificationTitle: "Running in Background",
          enableWakeLock: true,
        ),
      );
    } else if (Platform.isIOS) {
      locationSettings = AppleSettings(
        accuracy: lAccuracy.LocationAccuracy.best,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: lAccuracy.LocationAccuracy.best,
        distanceFilter: 100,
      );
    }

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      print(position == null
          ? 'Locations H3 : Unknown'
          : 'Locations H4 : ${position.latitude.toString()}, ${position.longitude.toString()}');

      if (Platform.isAndroid) {
        timerThread();
      } else {
        getWeatherNow(position, true);
      }
    });

    if (Platform.isAndroid) {
      timerThread();
    }
  }

  timerThread() async {
    Position val = await getGeoLocationPosition();

    getWeatherNow(val, false);
  }

  getWeatherNow(Position? val, bool addCity) async {
    Weather? weather =
        await fetchWeather(val?.latitude ?? 0, val?.longitude ?? 0);
    setWeatherInfo(weather);

    CityInfo city = CityInfo(
        weather?.areaName ?? "", val?.latitude ?? 0, val?.longitude ?? 0);

    Provider.of<CityProvider>(context, listen: false).city = city;

    if (addCity) {
      cities.insert(0, city);
    }
  }

  Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var loc = await Geolocator.getCurrentPosition(
        desiredAccuracy: lAccuracy.LocationAccuracy.best);

    return loc;
  }
}

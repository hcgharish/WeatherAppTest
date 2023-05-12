// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';
import 'package:weatherapp/application/config/cities.dart';
import 'package:weatherapp/domain/states/city_provider.dart';
import 'package:weatherapp/data/resources/remote/fetch_weather.dart';
import 'package:weatherapp/data/resources/city_info_model.dart';
import 'package:weatherapp/presentation/ui/views/city_row_item.dart';

class CityList extends StatefulWidget {
  const CityList({super.key});

  @override
  State<CityList> createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  @override
  Widget build(BuildContext context) {
    bool boolShowCityList = Provider.of<CityProvider>(context).boolShowCityList;

    if (boolShowCityList) {
      return Container(
        height: 300,
        width: MediaQuery.of(context).size.width - 50,
        margin: const EdgeInsets.only(top: 55),
        padding: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.amber.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListView.builder(
          itemCount: cities.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            CityInfo city = cities[index];

            return InkWell(
              child: CityRowItem(cityInfo: city),
              onTap: () {
                Provider.of<CityProvider>(context, listen: false).city = city;

                Provider.of<CityProvider>(context, listen: false)
                    .boolShowCityList = false;

                getWeather();
              },
            );
          },
        ),
      );
    }

    return const SizedBox();
  }

  getWeather() async {
    final city = Provider.of<CityProvider>(context, listen: false).city;

    Weather? weather = await fetchWeather(city.lat, city.lng);

    setWeatherInfo(weather);
  }

  setWeatherInfo(Weather? weather) {
    if (weather != null) {
      Provider.of<CityProvider>(context, listen: false).weatherInfo =
          "$weather";
    } else {
      Provider.of<CityProvider>(context, listen: false).weatherInfo = "";
    }
  }
}

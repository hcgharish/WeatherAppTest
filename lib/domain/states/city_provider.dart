import 'package:flutter/material.dart';
import 'package:weatherapp/application/config/cities.dart';
import 'package:weatherapp/data/resources/city_info_model.dart';

class CityProvider extends ChangeNotifier {
  CityInfo _city = CityInfo(cities[0].name, cities[0].lat, cities[0].lng);

  CityInfo get city => _city;

  set city(CityInfo val) {
    _city = val;
    notifyListeners();
  }

  bool _boolShowCityList = false;

  bool get boolShowCityList => _boolShowCityList;

  set boolShowCityList(bool val) {
    _boolShowCityList = val;
    notifyListeners();
  }

  String _weatherInfo = "";

  String get weatherInfo => _weatherInfo;

  set weatherInfo(String val) {
    _weatherInfo = val;
    notifyListeners();
  }
}

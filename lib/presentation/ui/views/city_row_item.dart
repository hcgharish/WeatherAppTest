// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:weatherapp/data/resources/city_info_model.dart';

class CityRowItem extends StatelessWidget {
  CityInfo? cityInfo;
  CityRowItem({super.key, this.cityInfo});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 51,
      child: Column(
        children: [
          Container(
            height: 50,
            alignment: Alignment.centerLeft,
            child: Text(cityInfo?.name ?? ""),
          ),
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width - 50,
            color: Colors.black12.withOpacity(0.05),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weatherapp/domain/states/city_provider.dart';
import 'package:weatherapp/presentation/ui/views/city_list.dart';
import 'package:weatherapp/presentation/ui/views/show_selected_city.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key, required this.title});

  final String title;

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final weatherInfo = Provider.of<CityProvider>(context).weatherInfo;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Text(
                weatherInfo,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            Stack(
              children: const <Widget>[
                ShowSelectedCity(),
                CityList(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather/models/city_weather_5_days_model.dart';
import 'package:weather/models/current_weather_model.dart';
import 'package:weather/utils/shared.dart';

class InfoService {
  final toast = FToast();

  Future<CurrentWeatherClass> fetchCurrentWeatherData(BuildContext context) async {
    toast.init(context);
    LocationPermission permission;
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      toast.showToast(
        child: Shared.customToast(Colors.green,
            'Please activate your location then reopen the app again.'),
        gravity: ToastGravity.BOTTOM,
      );
    }
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      toast.showToast(
        child:
            Shared.customToast(Colors.red, 'Location permissions are denied.'),
        gravity: ToastGravity.BOTTOM,
      );
      return CurrentWeatherClass();
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      debugPrint('location: ${position.latitude} ${position.longitude}');

      var url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=f55362ec49c9fe887382a18f74c7f011');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return currentWeatherClassFromJson(response.body);
      } else {
        toast.showToast(
          child: Shared.customToast(Colors.red, 'Something went wrong!'),
          gravity: ToastGravity.BOTTOM,
        );
      }
    }
    return CurrentWeatherClass();
  }

  Future<CurrentWeatherClass> fetchCityWeatherData(BuildContext context, String city) async {
    toast.init(context);
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=f55362ec49c9fe887382a18f74c7f011');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return currentWeatherClassFromJson(response.body);
    } else {
      toast.showToast(
        child: Shared.customToast(Colors.red, 'Something went wrong!'),
        gravity: ToastGravity.BOTTOM,
      );
    }
    return CurrentWeatherClass();
  }

  Future<CityWeatherFor5DaysClass> fetchCityWeatherFor5DaysData(BuildContext context, String city) async {
    toast.init(context);
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$city&lang&appid=f55362ec49c9fe887382a18f74c7f011');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return cityWeatherFor5DaysClassFromJson(response.body);
    } else {
      toast.showToast(
        child: Shared.customToast(Colors.red, 'Something went wrong!'),
        gravity: ToastGravity.BOTTOM,
      );
    }
    return CityWeatherFor5DaysClass();
  }
}

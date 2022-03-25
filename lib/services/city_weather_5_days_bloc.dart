import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather/models/city_weather_5_days_model.dart';
import 'package:weather/services/info_service.dart';

enum CityWeather5DaysAction { fetch }

class CityWeather5DaysBloc {
  final BuildContext? context;
  final String? city;

  final _stateStreamController =
      StreamController<CityWeatherFor5DaysClass>.broadcast();

  StreamSink<CityWeatherFor5DaysClass> get _cityWeather5DaysSink =>
      _stateStreamController.sink;

  Stream<CityWeatherFor5DaysClass> get cityWeather5DaysStream =>
      _stateStreamController.stream;

  final _eventStreamController = StreamController<CityWeather5DaysAction>();

  StreamSink<CityWeather5DaysAction> get eventSink =>
      _eventStreamController.sink;

  Stream<CityWeather5DaysAction> get _eventStream =>
      _eventStreamController.stream;

  CityWeather5DaysBloc(this.context, this.city) {
    _eventStream.listen((event) async {
      if (event == CityWeather5DaysAction.fetch) {
        try {
          CityWeatherFor5DaysClass data =
              await InfoService().fetchCityWeatherFor5DaysData(context!,city!);
          _cityWeather5DaysSink.add(data);
        } on Exception catch (e) {
          _cityWeather5DaysSink.addError(e);
        }
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}

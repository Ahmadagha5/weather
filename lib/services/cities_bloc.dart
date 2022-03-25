import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather/models/current_weather_model.dart';
import 'package:weather/services/info_service.dart';

enum CitiesAction { fetch }

class CitiesBloc {
  final BuildContext? context;
  final String? city;

  final _stateStreamController =
      StreamController<CurrentWeatherClass>.broadcast();

  StreamSink<CurrentWeatherClass> get _citiesSink =>
      _stateStreamController.sink;

  Stream<CurrentWeatherClass> get citiesStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<CitiesAction>();

  StreamSink<CitiesAction> get eventSink => _eventStreamController.sink;

  Stream<CitiesAction> get _eventStream => _eventStreamController.stream;

  CitiesBloc(this.context, this.city) {
    _eventStream.listen((event) async {
      if (event == CitiesAction.fetch) {
        try {
          CurrentWeatherClass data =
              await InfoService().fetchCityWeatherData(context!, city!);
          _citiesSink.add(data);
        } on Exception catch (e) {
          _citiesSink.addError(e);
        }
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}

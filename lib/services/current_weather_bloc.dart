import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather/models/current_weather_model.dart';
import 'package:weather/services/info_service.dart';

enum CurrentWeatherAction { fetch }

class CurrentWeatherBloc {
  final BuildContext? context;
  final _stateStreamController =
      StreamController<CurrentWeatherClass>.broadcast();

  StreamSink<CurrentWeatherClass> get _currentWeatherSink =>
      _stateStreamController.sink;

  Stream<CurrentWeatherClass> get currentWeatherStream =>
      _stateStreamController.stream;

  final _eventStreamController = StreamController<CurrentWeatherAction>();

  StreamSink<CurrentWeatherAction> get eventSink => _eventStreamController.sink;

  Stream<CurrentWeatherAction> get _eventStream =>
      _eventStreamController.stream;

  CurrentWeatherBloc(this.context) {
    _eventStream.listen((event) async {
      if (event == CurrentWeatherAction.fetch) {
        try {
          CurrentWeatherClass data =
              await InfoService().fetchCurrentWeatherData(context!);
          _currentWeatherSink.add(data);
        } on Exception catch (e) {
          _currentWeatherSink.addError(e);
        }
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}

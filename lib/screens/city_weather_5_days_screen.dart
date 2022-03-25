import 'package:flutter/material.dart';
import 'package:weather/models/city_weather_5_days_model.dart';
import 'package:weather/services/city_weather_5_days_bloc.dart';
import 'package:weather/utils/shared.dart';

class CityWeather5Days extends StatefulWidget {
  final String? cityName;

  const CityWeather5Days({Key? key, @required this.cityName}) : super(key: key);

  @override
  State<CityWeather5Days> createState() => _CityWeather5DaysState();
}

class _CityWeather5DaysState extends State<CityWeather5Days> {
  CityWeather5DaysBloc? cityWeather5DaysBloc;

  @override
  void initState() {
    super.initState();
    cityWeather5DaysBloc = CityWeather5DaysBloc(context, widget.cityName);
    cityWeather5DaysBloc!.eventSink.add(CityWeather5DaysAction.fetch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff4632a8),
        title: const Text('City weather for 5 days'),
      ),
      body: StreamBuilder<CityWeatherFor5DaysClass>(
          stream: cityWeather5DaysBloc!.cityWeather5DaysStream,
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Shared.loading(Colors.white)
                : ListView(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            List.generate(5, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Day ${index + 1}:',
                                    style: const TextStyle(
                                        color: Color(0xff4632a8),
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: List.generate(
                                        snapshot.data!.list![index].weather!
                                            .length, (j) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: RichText(
                                              text: TextSpan(
                                                text: 'Main: ',
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        '${snapshot.data!.list![index].weather![j].main}',
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xff4632a8),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: RichText(
                                              text: TextSpan(
                                                text: 'Description: ',
                                                style: TextStyle(
                                                    color: Colors.grey[600],
                                                    fontWeight:
                                                        FontWeight.bold),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text:
                                                        '${snapshot.data!.list![index].weather![j].description}',
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xff4632a8),
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Temp: ',
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    '${snapshot.data!.list![index].main!.temp}',
                                                style: const TextStyle(
                                                    color: Color(0xff4632a8),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Humidity: ',
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    '${snapshot.data!.list![index].main!.humidity}',
                                                style: const TextStyle(
                                                    color: Color(0xff4632a8),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Wind Speed: ',
                                            style: TextStyle(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.bold),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    '${snapshot.data!.list![index].wind!.speed}',
                                                style: const TextStyle(
                                                    color: Color(0xff4632a8),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  );
          }),
    );
  }
}

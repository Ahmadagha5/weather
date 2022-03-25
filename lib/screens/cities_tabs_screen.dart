import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather/models/current_weather_model.dart';
import 'package:weather/services/cities_bloc.dart';
import 'package:weather/utils/preferences.dart';
import 'package:weather/utils/shared.dart';

class CitiesTabs extends StatefulWidget {
  const CitiesTabs({Key? key}) : super(key: key);

  @override
  State<CitiesTabs> createState() => _CitiesTabsState();
}

class _CitiesTabsState extends State<CitiesTabs> {
  CitiesBloc? citiesBloc;

  List<String> myCities = ["Kuala Lumpur",  "Klang", "Ipoh", "Butterworth", "Johor Bahru", "George Town", "Petaling Jaya", "Kuantan", "Shah Alam", "Kota Bharu", "Melaka", "Kota Kinabalu", "Seremban", "Sandakan", "Sungai Petani", "Kuching", "Kuala Terengganu", "Alor Setar","Putrajaya", "Kangar", "Labuan", "Pasir Mas", "Tumpat", "Ketereh", "Kampung Lemal", "Pulai Chondong"];

  String? _selectedCity;

  @override
  void initState() {
    super.initState();
    _selectedCity = myCities[0];
    citiesBloc = CitiesBloc(context, Shared.cities![0]);
    citiesBloc!.eventSink.add(CitiesAction.fetch);
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        item,
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: Shared.cities!.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff4632a8),
          title: const Text('Cities Tabs'),
          actions: [
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.circlePlus,
                color: Colors.green,
              ),
              onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: Colors.grey)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedCity,
                            items: myCities.map(buildMenuItem).toList(),
                            onChanged: (value) async {
                              setState(() {
                                _selectedCity = value;
                                Shared.cities!.add(_selectedCity!);
                              });
                              await Preferences.setCities(Shared.cities!);
                              citiesBloc = CitiesBloc(context,value);
                              citiesBloc!.eventSink.add(CitiesAction.fetch);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
          bottom: TabBar(
            onTap: (tabIndex) {
              setState(() {
                citiesBloc = CitiesBloc(context, Shared.cities![tabIndex]);
                citiesBloc!.eventSink.add(CitiesAction.fetch);
              });
            },
            tabs: List.generate(Shared.cities!.length, (index) {
              return Tab(text: Shared.cities![index]);
            }),
          ),
        ),
        body: StreamBuilder<CurrentWeatherClass>(
            stream: citiesBloc!.citiesStream,
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Shared.loading(Colors.white)
                  : TabBarView(
                      children: List.generate(Shared.cities!.length, (index) {
                        return tabBody(snapshot.data!);
                      }),
                    );
            }),
      ),
    );
  }

  Widget tabBody(CurrentWeatherClass data) {
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 12.0, left: 8.0, bottom: 8.0),
          child: Text(
            'Weather Info',
            style: TextStyle(
                color: Color(0xff4632a8),
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
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
              children: List.generate(data.weather!.length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Name: ',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${data.name}',
                              style: const TextStyle(
                                  color: Color(0xff4632a8),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Main: ',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${data.weather![index].main}',
                              style: const TextStyle(
                                  color: Color(0xff4632a8),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: RichText(
                        text: TextSpan(
                          text: 'Description: ',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                              text: '${data.weather![index].description}',
                              style: const TextStyle(
                                  color: Color(0xff4632a8),
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        Padding(
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
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Temp: ',
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: '${data.main!.temp}',
                          style: const TextStyle(
                              color: Color(0xff4632a8),
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Humidity: ',
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: '${data.main!.humidity}',
                          style: const TextStyle(
                              color: Color(0xff4632a8),
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RichText(
                    text: TextSpan(
                      text: 'Wind Speed: ',
                      style: TextStyle(
                          color: Colors.grey[600], fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                          text: '${data.wind!.speed}',
                          style: const TextStyle(
                              color: Color(0xff4632a8),
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

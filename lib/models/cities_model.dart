class Cities {
  String? name;
  double? latitude;
  double? longitude;

  Cities({this.name, this.latitude, this.longitude});

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Latitude": latitude,
        "Longitude": longitude,
      };

  @override
  String toString() {
    return '{Name:$name, Latitude:$latitude,'
        ' Longitude:$longitude}';
  }
}

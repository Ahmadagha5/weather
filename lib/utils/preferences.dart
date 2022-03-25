import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? _preferences;

  static const _keyCities = 'cities';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setCities(List<String> cities) async =>
      await _preferences!.setStringList(_keyCities, cities);

  static List<String>? getCities() => _preferences!.getStringList(_keyCities);
}

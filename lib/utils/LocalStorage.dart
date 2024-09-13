import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const accountJson = 'account_json_key';

  Future<void> setValue(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

}

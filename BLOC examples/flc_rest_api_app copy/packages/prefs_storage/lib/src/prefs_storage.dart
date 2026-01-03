
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

class PrefsStorage {
  PrefsStorage(this.prefs);
  final SharedPreferences prefs;

  void saveString(String key, String val) {
    try {
      prefs.setString(key, val);
    } catch (e) {
      log(e.toString());
    }
  }

  String getString(String key) {
    return prefs.getString(key) ?? '';
  }
}

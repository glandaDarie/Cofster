import 'package:shared_preferences/shared_preferences.dart';

class LoggedInService {
  LoggedInService._();

  static Future<String> changeSharedPreferenceLoggingStatus() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      bool keepMeLoggedIn = !preferences.getBool("keepMeLoggedIn");
      preferences.setBool("keepMeLoggedIn", keepMeLoggedIn);
    } catch (error) {
      return "Couldn't change the logging status, error: ${error}";
    }
    return null;
  }

  static Future<bool> checkSharedPreferenceExistence(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    key = key.substring(0, key.length);
    return preferences.containsKey(key);
  }

  static Future<String> setSharedPreferenceValue(String key,
      {String nameUser}) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if (key == "<keepMeLoggedIn>") {
        preferences.setBool(key.substring(1, key.length - 1), false);
      } else if (key == "<nameUser>") {
        preferences.setString(key.substring(1, key.length - 1), nameUser);
      } else {
        return "Error, the key provided is invalid";
      }
    } catch (error) {
      return "Error when trying to set default logging status, error: ${error}";
    }
    return null;
  }

  static Future<dynamic> getSharedPreferenceValue(String key) async {
    dynamic value;
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if (key == "<keepMeLoggedIn>") {
        value = preferences.getBool(key.substring(1, key.length - 1));
      } else if (key == "<nameUser>") {
        value = preferences.getString(key.substring(1, key.length - 1));
      } else {
        return "Error, the key provided is invalid";
      }
    } catch (error) {
      return "Error when trying to get the value from ${key}, ${error}";
    }
    return value;
  }

  static Future<String> removeSharedPreferenceKey(String key) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      if (key == "<keepMeLoggedIn>") {
        preferences.remove(key.substring(1, key.length - 1));
      } else if (key == "<nameUser>") {
        preferences.remove(key.substring(1, key.length - 1));
      } else {
        return "Error, the key provided is invalid";
      }
    } catch (error) {
      return "Error when trying to remove the key: ${key}, ${error}";
    }
    return null;
  }
}

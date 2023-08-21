import 'package:shared_preferences/shared_preferences.dart';

class LoggedInService {
  LoggedInService._();

  // static Future<bool> getLoggingStatus() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   return preferences.getBool("keepMeLoggedIn");
  // }

  // static Future<bool> checkIfLoggingStatusIsPresent() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   return preferences.containsKey("keepMeLoggedIn");
  // }

  // static Future<String> setDefaultLoggingStatus() async {
  //   try {
  //     SharedPreferences preferences = await SharedPreferences.getInstance();
  //     preferences.setBool("keepMeLoggedIn", false);
  //   } catch (error) {
  //     return "Error when trying to set default logging status, error: ${error}";
  //   }
  //   return "Successfully set default logging status";
  // }

  static Future<String> changeLoggingStatus() async {
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
        preferences.setBool("keepMeLoggedIn", false);
      } else if (key == "<nameUser>") {
        preferences.setString("nameUser", nameUser);
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
        value = preferences.getBool(key);
      } else if (key == "<nameUser>") {
        value = preferences.getString(key);
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
        preferences.remove(key);
      } else if (key == "<nameUser>") {
        preferences.remove(key);
      } else {
        return "Error, the key provided is invalid";
      }
    } catch (error) {
      return "Error when trying to remove the key: ${key}, ${error}";
    }
    return null;
  }
}

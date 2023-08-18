import 'package:shared_preferences/shared_preferences.dart';

class LoggedInService {
  LoggedInService();

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

  static Future<bool> getLoggingStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("keepMeLoggedIn");
  }

  static Future<bool> checkIfLoggingStatusIsPresent() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.containsKey("keepMeLoggedIn");
  }

  static Future<String> setDefaultLoggingStatus() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool("keepMeLoggedIn", false);
    } catch (error) {
      return "Error when trying to set default logging status, error: ${error}";
    }
    return "Successfully set default logging status";
  }
}

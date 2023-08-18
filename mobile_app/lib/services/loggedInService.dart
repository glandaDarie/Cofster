import 'package:shared_preferences/shared_preferences.dart';

class LoggedInService {
  LoggedInService();

  static Future<String> changeLoggingStatus() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      bool keepMeLoggedIn = await !preferences.getBool("keepMeLoggedIn");
      preferences.setBool("keepMeLoggedIn", keepMeLoggedIn);
    } catch (error) {
      return "Couldn't change the logging status, error: ${error}";
    }
    return "Changed logging value successfully";
  }

  static Future<bool> getLoggingStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getBool("keepMeLoggedIn");
  }
}

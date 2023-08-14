import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LoggedInService {
  LoggedInService();

  static Future<String> changeLoggingStatus(String path) async {
    try {
      String contentToRead = await rootBundle.loadString(path);
      List<String> lines = contentToRead.split("\n");
      if (!lines.contains("false") && !lines.contains("true")) {
        return "Could not change the status";
      }
      String contentToWrite = lines.contains("false") ? "true" : "false";
      final directory = await getApplicationDocumentsDirectory();
      File file = File("${directory.path}/${path.split('/').last}");
      await file.writeAsString(contentToWrite, flush: true);
    } catch (e) {
      return "Error reading file: $e";
    }
    return null;
  }

  static Future<dynamic> getLoggingStatus(String path) async {
    try {
      String content = await rootBundle.loadString(path);
      List<String> lines = content.split("\n");
      if (!lines.contains("false") && !lines.contains("true")) {
        return "Logging status is not written correctly in the logging file.";
      }
      return lines.contains("false") ? false : true;
    } catch (error) {
      return "Error when trying to get the logging status: ${error}";
    }
  }
}

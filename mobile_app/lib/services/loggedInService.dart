import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LoggedInService {
  LoggedInService();

  static Future<String> changeLoggingStatus(String filePath) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File("${directory.path}/${filePath.split('/').last}");
      String contentToRead = await file.readAsString();
      List<String> lines = contentToRead.split("\n");
      if (!lines.contains("false") && !lines.contains("true")) {
        return "Could not change the status";
      }
      String contentToWrite = lines.contains("false") ? "true" : "false";
      await file.writeAsString(contentToWrite, flush: true);
    } catch (error) {
      return "Error when doing IO operations on the file: $error";
    }
    return null;
  }

  static Future<String> getLoggingStatus(String filePath) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      File file = File("${directory.path}/${filePath.split('/').last}");
      String contentToRead = await file.readAsString();
      List<String> lines = contentToRead.split("\n");
      bool fileIsEmpty =
          lines.every((String line) => line == "" || line == "\n");
      if (fileIsEmpty) {
        await file.writeAsString("false", flush: true);
        contentToRead = await file.readAsString();
        lines = contentToRead.split("\n");
      }
      if (!lines.contains("false") && !lines.contains("true")) {
        return "Logging status is not written correctly in the logging file.";
      }
      return lines.last;
    } catch (error) {
      return "Error when trying to get the logging status: $error";
    }
  }
}

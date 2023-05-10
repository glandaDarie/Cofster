import 'dart:io' show Directory, File;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> storeUserInformationInCache(
    Map<String, String> userInformation) async {
  try {
    final Directory directory = await getApplicationDocumentsDirectory();
    File outputFile = File("${directory.path}/userInformation.txt");
    String userInformationFormatted = "";
    userInformation.forEach((key, value) {
      userInformationFormatted += "$key $value\n";
    });
    await outputFile.writeAsString(userInformationFormatted, flush: true);
  } catch (e) {
    Fluttertoast.showToast(
        msg: "Error when storing data: $e",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Color.fromARGB(255, 102, 33, 12),
        textColor: Color.fromARGB(255, 220, 217, 216),
        fontSize: 16);
  }
}

Future<String> loadUserInformationFromCache() async {
  String userInformationRead = "";
  try {
    final Directory directory = await getApplicationDocumentsDirectory();
    File inputFile = File("${directory.path}/userInformation.txt");
    userInformationRead = await inputFile.readAsString();
  } catch (e) {
    Fluttertoast.showToast(
        msg: "Error when loading data: $e",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Color.fromARGB(255, 102, 33, 12),
        textColor: Color.fromARGB(255, 220, 217, 216),
        fontSize: 16);
  }
  return userInformationRead;
}

Map<String, String> fromStringCachetoMapCache(String stringCache) {
  Map<String, String> cache = {};
  List<String> splittedStringCache = stringCache.split("\n");
  splittedStringCache.removeLast();
  splittedStringCache.forEach((pair) {
    List<String> wrapper = pair.split(" ");
    cache[wrapper[0].toString()] = wrapper[1].toString();
  });
  return cache;
}

Future<void> appendInformationInCache(
    Map<String, String> cache, Map<String, String> newData) async {
  try {
    for (MapEntry<String, String> entry in newData.entries) {
      cache[entry.key] = entry.value;
    }
    await storeUserInformationInCache(cache);
  } catch (e) {
    Fluttertoast.showToast(
        msg: "When appending information, exception: $e",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Color.fromARGB(255, 102, 33, 12),
        textColor: Color.fromARGB(255, 220, 217, 216),
        fontSize: 16);
  }
}

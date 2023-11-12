import 'dart:io' show Directory, File;
import 'package:path_provider/path_provider.dart';
import 'package:coffee_orderer/utils/toast.dart' show ToastUtils;

Future<String> createUserInformationFile() async {
  String msg = "File is already created";
  try {
    final Directory directory = await getApplicationDocumentsDirectory();
    File userInformationFile = File("${directory.path}/userInformation.txt");
    if (!await userInformationFile.exists()) {
      userInformationFile.create();
      msg = "Created file: ${userInformationFile.path} successfully";
    }
  } catch (e) {
    throw Exception(
        "Error when ensuring user information file existence: ${e}");
  }
  return msg;
}

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
    ToastUtils.showToast("Error when storing data: ${e}");
    return null;
  }
}

Future<String> loadUserInformationFromCache() async {
  String userInformationRead = "";
  try {
    final Directory directory = await getApplicationDocumentsDirectory();
    File inputFile = File("${directory.path}/userInformation.txt");
    userInformationRead = await inputFile.readAsString();
  } catch (e) {
    ToastUtils.showToast("Error when loading data: ${e}");
    return null;
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
    ToastUtils.showToast("When appending information, exception: ${e}");
    return null;
  }
}

import 'package:coffee_orderer/models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:coffee_orderer/services/encryptPasswordService.dart';

class DynamoDBUserDao {
  String url;
  List<User> users;

  DynamoDBUserDao(String url) {
    this.url = url;
  }

  Future<List<dynamic>> getAllUsers() async {
    List<dynamic> information = [];
    List<dynamic> usersInformation = [];
    try {
      http.Response response = await http.get(Uri.parse(this.url));
      if (response.statusCode == 200) {
        information = jsonDecode(response.body);
        usersInformation = parseJson(information);
      }
    } catch (error) {
      throw Exception(
          "Could not fetch all the users information, error: ${error}");
    }
    return usersInformation;
  }

  Future<dynamic> getLastUser() async {
    List<dynamic> users = await getAllUsers();
    return users[users.length - 1];
  }

  Future<List<dynamic>> getDrinksFromNameAndUsername(
      String name, String username) async {
    List<dynamic> users = await getAllUsers();
    if (username != null) {
      for (dynamic user in users) {
        if (name == user.name && username == user.username) {
          return List.from(user.favouriteDrinks);
        }
      }
    }
    return [];
  }

  Future<dynamic> getUserNameFromUsername(String username) {
    dynamic name;
    if (username != null) {
      for (dynamic user in users) {
        if (username == user.username) {
          name = user.name;
          break;
        }
      }
    }
    return name ?? "User with that specified name not found";
  }

  Future<dynamic> getUserNameFromCredentials(
      Map<dynamic, dynamic> userCredentials, List<dynamic> users) async {
    dynamic name;
    if (userCredentials != null && users != null) {
      for (dynamic user in users) {
        if (userCredentials["username"] == user.username &&
            passwordIsMatchedWithHash(
                userCredentials["password"], user.password)) {
          name = user.name;
          break;
        }
      }
    }
    return name ?? "User with specified credentials not found";
  }

  List<dynamic> parseJson(List<dynamic> data) {
    List<dynamic> usersInformation = [];
    List<dynamic> users = data[0]["users"];
    List<dynamic> _user = users[0]["user"];
    for (dynamic _u in _user) {
      int id = int.parse(_u["id"]);
      String name = _u["name"];
      String username = _u["username"];
      String password = _u["password"];
      String photo = _u["photo"];
      List<dynamic> favouriteDrinksJson = _u["favouriteDrinks"];
      List<Map<String, String>> favouriteDrinksConverted = favouriteDrinksJson
          .map<Map<String, String>>(
              (favDrink) => Map<String, String>.from(favDrink))
          .toList();
      List<String> favouriteDrinks = favouriteDrinksConverted
          .map((favDrink) => favDrink[
              "drink ${favouriteDrinksConverted.indexOf(favDrink) + 1}"])
          .toList();
      User user = User(id, name, username, password, photo, favouriteDrinks);
      usersInformation.add(user);
    }
    return usersInformation;
  }

  Future<String> updateUsersPassword(
      String username, String newPassword) async {
    String msg = null;
    try {
      http.Response response = await http.put(Uri.parse(this.url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"username": username, "newPassword": newPassword}));
      msg = "Successfully updated the password";
      if (response.statusCode != 200) {
        msg = "Status code is: ${response.statusCode}";
      }
    } catch (e) {
      msg = "Exception when updating the password: ${e}";
    }
    return msg;
  }

  Future<String> insertNewUser(Map<String, String> content) async {
    String msg = null;
    Map<String, dynamic> requestBody = {"body": content};
    try {
      http.Response response = await http.post(
        Uri.parse(this.url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );
      String responseBody = response.body;
      dynamic jsonResponse = jsonDecode(responseBody);
      if (jsonResponse["statusCode"] != 201) {
        msg = "Error: ${jsonResponse["body"]}";
      }
    } catch (e) {
      msg = "Exception when inserting a new user: ${e}";
    }
    return msg;
  }

  Future<String> uploadUsersPhotoToS3(Map<String, String> content) async {
    String msg = null;
    Map<String, dynamic> requestBody = {"body": content};
    try {
      http.Response response = await http.post(Uri.parse(this.url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody));
      String responseBody = response.body;
      dynamic jsonResponse = jsonDecode(responseBody);
      if (jsonResponse["statusCode"] != 201) {
        msg = "Error: ${jsonResponse["body"]}";
      }
    } catch (e) {
      msg = "Exception when adding a file to the S3 bucket: ${e}";
    }
    return msg;
  }

  Future<String> getUsersPhotoFromS3() async {
    String msg = null;
    String photoBase64 = null;
    try {
      http.Response response = await http.get(Uri.parse(this.url));
      if (response.statusCode == 200) {
        photoBase64 = response.body;
      }
    } catch (e) {
      msg = "Exception when fetching a file from S3 bucket: ${e}";
    }
    return msg == null ? photoBase64 : msg;
  }

  Future<String> updateUsersFavouriteDrinks(Map<String, String> content) async {
    String msg = null;
    try {
      Map<String, dynamic> requestBody = {"body": content};
      http.Response response = await http.put(Uri.parse(this.url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(requestBody));
      msg = "Successfully updated the favourite drinks";
      if (response.statusCode != 200) {
        msg = "Status code is: ${response.statusCode}";
      }
    } catch (e) {
      msg = "Exception when updating the password: ${e}";
    }
    return msg;
  }
}

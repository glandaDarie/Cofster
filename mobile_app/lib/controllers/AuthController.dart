import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:coffee_orderer/controllers/UserController.dart';
import 'package:coffee_orderer/services/validateCredentialsService.dart';
import 'package:coffee_orderer/models/user.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:coffee_orderer/utils/localUserInformation.dart';
import 'package:coffee_orderer/services/encryptPasswordService.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:coffee_orderer/credentials/EmailCredentials.dart';
import 'package:coffee_orderer/services/passwordGeneratorService.dart';
import 'dart:convert';
import 'dart:typed_data';

class AuthController extends ValidateCredentialsService {
  Duration get loginTime => Duration(milliseconds: 2250);
  UserController userController;
  AuthController() {
    userController = UserController();
  }

  Future<List<dynamic>> getUsers() async {
    List<dynamic> _users;
    try {
      _users = await this.userController.getAllUsers();
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Exception when trying to fetch users: $e",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Color.fromARGB(255, 102, 33, 12),
          textColor: Color.fromARGB(255, 220, 217, 216),
          fontSize: 16);
      return null;
    }
    return _users;
  }

  Future<String> authUser(LoginData data) async {
    // write information necesssary for login/register to cache
    await storeUserInformationInCache(
        {"username": data.name, "password": data.password});
    List<dynamic> users = await getUsers();
    return Future.delayed(loginTime).then((_) {
      for (User user in users) {
        if (user.username == data.name &&
            passwordIsMatchedWithHash(data.password, user.password)) {
          return null;
        }
      }
      return "Credentials Username and/or password are not correct";
    });
  }

  Future<String> signupUser(SignupData data, String name, String surname) {
    return Future.delayed(loginTime).then((_) async {
      String responseNameValidator = validateNameSurname(name);
      if (responseNameValidator != null) {
        return responseNameValidator;
      }
      String responseSurnameValidator = validateNameSurname(surname);
      if (responseSurnameValidator != null) {
        return responseSurnameValidator;
      }
      String responseUsernameValidator = validateUsername(data.name);
      if (responseUsernameValidator != null) {
        return responseUsernameValidator;
      }
      String responsePasswordValidator = validatePassword(data.password);
      if (responsePasswordValidator != null) {
        return responsePasswordValidator;
      }
      return await sendEmail(data.name);
    });
  }

  Future<String> recoverPassword(String username) async {
    List<dynamic> users = await getUsers();
    return Future.delayed(loginTime).then((_) async {
      for (User user in users) {
        if (user.username == username) {
          String data = await sendEmail(username, "password");
          if (data == null) {
            return "Exception: ${data}";
          }
          // PUT request to update the password of that specific user
          String response = await this
              .userController
              .updateUsersPassword(username, encryptPassword(data));
          if (response != "Successfully updated the password") {
            return response;
          }
          return null;
        }
      }
      return "User does not exist";
    });
  }

  Future<String> sendEmail(String recipientEmail,
      [String lock = "verification_code"]) async {
    String usernameSender = emailCredentials["username"];
    String passwordSender = emailCredentials["password"];
    SmtpServer smtpServer = null;
    try {
      smtpServer = SmtpServer("smtp-mail.outlook.com",
          port: 587, username: usernameSender, password: passwordSender);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error creating SmtpServer: ${e}",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Color.fromARGB(255, 102, 33, 12),
          textColor: Color.fromARGB(255, 220, 217, 216),
          fontSize: 16);
      return null;
    }
    String data;
    Message message;
    if (lock == "password") {
      data = generateNewPassword();
      message = Message()
        ..from = Address(usernameSender, "Cofster")
        ..recipients.add(recipientEmail)
        ..subject = "Password reset"
        ..text = "Your new password is: ${data}";
    } else if (lock == "verification_code") {
      data = generateNewVerificationCode();
      message = Message()
        ..from = Address(usernameSender, "Cofster")
        ..recipients.add(recipientEmail)
        ..subject = "Verification code"
        ..text = "Your verification code is: ${data}";
    } else {
      Fluttertoast.showToast(
          msg: "No valid operation for sending an email.",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Color.fromARGB(255, 102, 33, 12),
          textColor: Color.fromARGB(255, 220, 217, 216),
          fontSize: 16);
      return null;
    }
    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      Fluttertoast.showToast(
          msg: "Could not send email. Exception : ${e}",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Color.fromARGB(255, 102, 33, 12),
          textColor: Color.fromARGB(255, 220, 217, 216),
          fontSize: 16);
      return null;
    }
    return data;
  }

  Future<String> loginCompletedSuccessfully() async {
    Map<String, String> cache = {};
    String errorMsg = null;
    dynamic nameUser;
    try {
      String _userCredentialsLoginStr = await loadUserInformationFromCache();
      String userCredentialsLoginStr = _userCredentialsLoginStr.trim();
      List<String> userCredentialsLoginList =
          userCredentialsLoginStr.split("\n");
      userCredentialsLoginList.forEach((String credential) {
        List<String> _credential = credential.split(" ");
        cache[_credential[0]] = _credential[1];
      });
    } catch (e) {
      errorMsg = "Exception when trying to fetch the credentials or name: $e";
    }
    nameUser =
        await this.userController.getUserNameFromCredentials(cache, getUsers());
    await appendInformationInCache(cache, {"name": nameUser});
    return errorMsg;
  }

  Future<String> singupCompletedSuccessfully(
      String name, LoginData data) async {
    Map<String, String> cache = {
      "name": name,
      "username": data.name,
      "password": encryptPassword(data.password)
    };
    storeUserInformationInCache(cache);
    String response = await this.userController.insertNewUser(cache);
    if (response != null) {
      Fluttertoast.showToast(
          msg: "Exception : ${response}",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Color.fromARGB(255, 102, 33, 12),
          textColor: Color.fromARGB(255, 220, 217, 216),
          fontSize: 16);
    }
    return response;
  }

  Future<String> compareVerificationCode(String formVerificationCode) async {
    String stringCache = await loadUserInformationFromCache();
    Map<String, String> cache = fromStringCachetoMapCache(stringCache);
    if (formVerificationCode != cache["code"]) {
      return "Code is not written correctly";
    }
    return null;
  }

  Future<String> usernameUniqueOnSingup(String username) async {
    List<dynamic> users = await this.userController.getAllUsers();
    for (dynamic user in users) {
      if (username == user.username) {
        return "Username = ${username} is already\npresent in the database";
      }
    }
    return null;
  }

  Future<String> getNameFromCache() async {
    String cacheAsString = await loadUserInformationFromCache();
    Map<String, String> cache = fromStringCachetoMapCache(cacheAsString);
    for (MapEntry<String, String> content in cache.entries) {
      if (content.key.trim() == "name") {
        return content.value.trim();
      }
    }
    return null;
  }

  // comment for better integration testing
  Future<Uint8List> loadUserPhoto() async {
    String cacheStr;
    try {
      cacheStr = await loadUserInformationFromCache();
    } catch (e) {
      return null;
    }
    Map<String, String> cache = fromStringCachetoMapCache(cacheStr);
    Map<String, String> content = {"name": cache["name"].toLowerCase()};
    String photoBase64 = await this.userController.getUsersPhotoFromS3(content);
    Uint8List photoBytes = base64.decode(photoBase64);
    return photoBytes;
  }

  Future<String> loadName() async {
    String cacheNameValue;
    try {
      String cacheStr = await loadUserInformationFromCache();
      Map<String, String> cache = fromStringCachetoMapCache(cacheStr);
      cacheNameValue = cache["name"];
      if (cacheNameValue == null) {
        cacheNameValue = "User";
      }
    } catch (e) {
      return "Error loading name: ${e}";
    }
    return cacheNameValue;
  }
}

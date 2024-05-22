import 'package:coffee_orderer/services/urlService.dart';
import 'package:coffee_orderer/data_access/DynamoDBUserDao.dart';

class UserController {
  UrlService urlServiceGetUsers;
  String urlGetUsers;
  DynamoDBUserDao userDaoGetUsers;

  UrlService urlServiceUpdateUsersPassword;
  String urlUpdateUsersPassword;
  DynamoDBUserDao userDaoUpdateUsersPassword;

  UrlService urlServiceInsertNewUser;
  String urlInsertNewUser;
  DynamoDBUserDao userDaoInsertNewUser;

  UrlService urlServiceDeleteUserFromUsers;
  String urlDeleteUser;
  DynamoDBUserDao userDaoDeleteUser;

  UrlService urlServiceUploadUsersPhoto;
  String urlUploadUsersPhoto;
  DynamoDBUserDao userDaoUploadUsersPhoto;

  UrlService urlServiceGetUsersPhoto;
  String urlGetUsersPhoto;
  DynamoDBUserDao userDaoGetUsersPhoto;

  UrlService urlServiceUpdateUsersFavouriteDrinks;
  String urlUpdateUsersFavouriteDrinks;
  DynamoDBUserDao userDaoUpateUsersFavouriteDrinks;

  UserController() {
    this.urlServiceGetUsers = UrlService(
        "https://p5niyz4q2e.execute-api.us-east-1.amazonaws.com/prod",
        "/users",
        {"usersInformation": "info"});
    this.urlGetUsers = this.urlServiceGetUsers.createUrl();
    this.userDaoGetUsers = DynamoDBUserDao(this.urlGetUsers);
  }

  Future<List<dynamic>> getAllUsers() async {
    return await this.userDaoGetUsers.getAllUsers();
  }

  Future<List<dynamic>> getLastUser() async {
    return await this.userDaoGetUsers.getLastUser();
  }

  Future<List<dynamic>> getDrinksFromNameAndUsername(
      String name, String username) async {
    return await this
        .userDaoGetUsers
        .getDrinksFromNameAndUsername(name, username);
  }

  Future<dynamic> getUserNameFromCredentials(
      Map<dynamic, dynamic> params, List<dynamic> users) async {
    return await this.userDaoGetUsers.getUserNameFromCredentials(params, users);
  }

  Future<String> insertNewUser(Map<String, String> content) async {
    this.urlServiceInsertNewUser = UrlService(
        "https://p5niyz4q2e.execute-api.us-east-1.amazonaws.com/prod",
        "/users");
    this.urlInsertNewUser = this.urlServiceInsertNewUser.createUrl();
    this.userDaoInsertNewUser = new DynamoDBUserDao(this.urlInsertNewUser);
    return await this.userDaoInsertNewUser.insertNewUser(content);
  }

  Future<String> deleteUserFromCredentials(Map<String, String> content) async {
    this.urlServiceDeleteUserFromUsers = UrlService(
        "https://p5niyz4q2e.execute-api.us-east-1.amazonaws.com/prod",
        "/users");
    this.urlDeleteUser = this.urlServiceDeleteUserFromUsers.createUrl();
    this.userDaoDeleteUser = new DynamoDBUserDao(this.urlDeleteUser);
    return await this.userDaoDeleteUser.deleteUserFromCredentials(content);
  }

  Future<String> updateUsersPassword(
      String username, String newPassword) async {
    this.urlServiceUpdateUsersPassword = UrlService(
        "https://p5niyz4q2e.execute-api.us-east-1.amazonaws.com/prod",
        "/users/password",
        {"username": username, "newPassword": newPassword});
    this.urlUpdateUsersPassword =
        this.urlServiceUpdateUsersPassword.createUrl();
    this.userDaoUpdateUsersPassword =
        DynamoDBUserDao(this.urlUpdateUsersPassword);
    return await this
        .userDaoUpdateUsersPassword
        .updateUsersPassword(username, newPassword);
  }

  //comment for better integration testing
  Future<String> uploadUsersPhotoToS3(Map<String, String> content) async {
    this.urlServiceUploadUsersPhoto = UrlService(
        "https://p5niyz4q2e.execute-api.us-east-1.amazonaws.com/prod",
        "/users/photo");
    this.urlUploadUsersPhoto = this.urlServiceUploadUsersPhoto.createUrl();
    this.userDaoUploadUsersPhoto = DynamoDBUserDao(this.urlUploadUsersPhoto);
    return await this.userDaoUploadUsersPhoto.uploadUsersPhotoToS3(content);
  }

  // comment for better integration testing
  Future<String> getUsersPhotoFromS3(Map<String, String> content) async {
    this.urlServiceGetUsersPhoto = UrlService(
        "https://p5niyz4q2e.execute-api.us-east-1.amazonaws.com/prod",
        "/users/photo",
        content);
    this.urlGetUsersPhoto = this.urlServiceGetUsersPhoto.createUrl();
    this.userDaoGetUsersPhoto = DynamoDBUserDao(this.urlGetUsersPhoto);
    return await this.userDaoGetUsersPhoto.getUsersPhotoFromS3();
  }

  Future<String> updateUsersFavouriteDrinks(Map<String, String> content) async {
    this.urlServiceUpdateUsersFavouriteDrinks = UrlService(
        "https://p5niyz4q2e.execute-api.us-east-1.amazonaws.com/prod",
        "/users/favourite_drinks",
        content);
    this.urlUpdateUsersFavouriteDrinks =
        this.urlServiceUpdateUsersFavouriteDrinks.createUrl();
    this.userDaoUpateUsersFavouriteDrinks =
        DynamoDBUserDao(this.urlUpdateUsersFavouriteDrinks);
    return await this
        .userDaoUpateUsersFavouriteDrinks
        .updateUsersFavouriteDrinks(content);
  }
}

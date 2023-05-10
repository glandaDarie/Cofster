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

  UrlService urlServiceUploadUsersPhoto;
  String urlUploadUsersPhoto;
  DynamoDBUserDao userDaoUploadUsersPhoto;

  UrlService urlServiceGetUsersPhoto;
  String urlGetUsersPhoto;
  DynamoDBUserDao userDaoGetUsersPhoto;

  UserController() {
    this.urlServiceGetUsers = UrlService(
        "https://2rbfw9r283.execute-api.us-east-1.amazonaws.com/prod",
        "/users",
        {"usersInformation": "info"});
    this.urlGetUsers = this.urlServiceGetUsers.createUrl();
    this.userDaoGetUsers = DynamoDBUserDao(this.urlGetUsers);

    this.urlServiceUpdateUsersPassword = null;
    this.userDaoUpdateUsersPassword = null;
    this.urlUpdateUsersPassword = null;

    this.urlServiceInsertNewUser = null;
    this.urlInsertNewUser = null;
    this.userDaoInsertNewUser = null;

    this.urlServiceUploadUsersPhoto = null;
    this.urlUploadUsersPhoto = null;
    this.userDaoUploadUsersPhoto = null;

    this.urlServiceGetUsersPhoto = null;
    this.urlGetUsersPhoto = null;
    this.userDaoGetUsersPhoto = null;
  }

  Future<List<dynamic>> getAllUsers() async {
    return await this.userDaoGetUsers.getAllUsers();
  }

  Future<List<dynamic>> getLastUser() async {
    return await this.userDaoGetUsers.getLastUser();
  }

  Future<dynamic> getUserNameFromCredentials(
      Map<dynamic, dynamic> params, Future<List<dynamic>> _users) async {
    List<dynamic> users = await _users;
    return await this.userDaoGetUsers.getUserNameFromCredentials(params, users);
  }

  Future<String> insertNewUser(Map<String, String> content) async {
    this.urlServiceInsertNewUser = UrlService(
        "https://2rbfw9r283.execute-api.us-east-1.amazonaws.com/prod",
        "/users");
    this.urlInsertNewUser = this.urlServiceInsertNewUser.createUrl();
    this.userDaoInsertNewUser = new DynamoDBUserDao(this.urlInsertNewUser);
    return await this.userDaoInsertNewUser.insertNewUser(content);
  }

  Future<String> updateUsersPassword(
      String username, String newPassword) async {
    this.urlServiceUpdateUsersPassword = UrlService(
        "https://2rbfw9r283.execute-api.us-east-1.amazonaws.com/prod",
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

  Future<String> uploadUsersPhotoToS3(Map<String, String> content) async {
    this.urlServiceUploadUsersPhoto = UrlService(
        "https://2rbfw9r283.execute-api.us-east-1.amazonaws.com/prod",
        "/users/photo");
    this.urlUploadUsersPhoto = this.urlServiceUploadUsersPhoto.createUrl();
    this.userDaoUploadUsersPhoto = DynamoDBUserDao(this.urlUploadUsersPhoto);
    return await this.userDaoUploadUsersPhoto.uploadUsersPhotoToS3(content);
  }

  // Future<String> getUsersPhotoFromS3(Map<String, String> content) async {
  //   // String bucketName, String filename
  //   this.urlServiceGetUsersPhoto = UrlService(
  //       "https://${content['bucketName']}.s3.amazonaws.com/",
  //       "/users_photos/${content['filename']}");
  //   this.urlGetUsersPhoto = this.urlServiceGetUsersPhoto.createUrl();
  //   this.userDaoGetUsersPhoto = DynamoDBUserDao(this.urlGetUsersPhoto);
  //   return await this.userDaoGetUsersPhoto.getUsersPhotoFromS3();
  // }

  Future<String> getUsersPhotoFromS3(Map<String, String> content) async {
    this.urlServiceGetUsersPhoto = UrlService(
        "https://2rbfw9r283.execute-api.us-east-1.amazonaws.com/prod",
        "/users/photo",
        content);
    this.urlGetUsersPhoto = this.urlServiceGetUsersPhoto.createUrl();
    this.userDaoGetUsersPhoto = DynamoDBUserDao(this.urlGetUsersPhoto);
    return await this.userDaoGetUsersPhoto.getUsersPhotoFromS3();
  }
}

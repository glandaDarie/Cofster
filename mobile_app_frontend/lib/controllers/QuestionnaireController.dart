import 'package:coffee_orderer/services/urlService.dart';
import 'package:coffee_orderer/data_access/DynamoDBQuestionnaireDao.dart';
import 'package:coffee_orderer/models/question.dart';
import 'package:coffee_orderer/utils/localUserInformation.dart';
import 'package:coffee_orderer/controllers/UserController.dart';
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;

class QuestionnaireController {
  UrlService urlServiceGetQuestions;
  String urlGetQuestions;
  DynamoDBQuestionnaireDao userDaoGetQuestions;

  UrlService urlServicePostAnswers;
  String urlPostAnswers;
  DynamoDBQuestionnaireDao userDaoPostAnswers;

  UserController userController;
  QuestionnaireController() {
    userController = UserController();
  }

  Future<List<Question>> getAllQuestions() async {
    this.urlServiceGetQuestions = UrlService(
        "https://u7d7lbw2c3.execute-api.us-east-1.amazonaws.com/prod",
        "/questions",
        {"questionId": "09423213"});
    this.urlGetQuestions = this.urlServiceGetQuestions.createUrl();
    this.userDaoGetQuestions = DynamoDBQuestionnaireDao(this.urlGetQuestions);
    return await this.userDaoGetQuestions.getAllQuestions();
  }

  Future<List<String>> postQuestionsToGetPredictedFavouriteDrinks(
      Map<String, String> content) async {
    this.urlServicePostAnswers =
        UrlService("http://192.168.0.151:8001", "/prediction_drinks");
    this.urlPostAnswers = this.urlServicePostAnswers.createUrl();
    this.userDaoPostAnswers = DynamoDBQuestionnaireDao(this.urlPostAnswers);
    return await this
        .userDaoPostAnswers
        .postQuestionsToGetPredictedFavouriteDrinks(content);
  }

  Future<bool> drinksPresentInCache() async {
    return RegExp(r"drink-[1-5]")
        .hasMatch(await loadUserInformationFromCache());
  }

  Future<List<String>> loadDrinksFromCache() async {
    String cacheStr = await loadUserInformationFromCache();
    Map<String, String> cache = fromStringCachetoMapCache(cacheStr);
    return cache.values
        .map((String element) => element.replaceAll("-", " "))
        .toList();
  }

  Future<List<String>> loadDrinksFromDynamoDB() async {
    String username =
        await LoggedInService.getSharedPreferenceValue("<username>");
    String name = await LoggedInService.getSharedPreferenceValue("<nameUser>");
    return (await userController.getDrinksFromNameAndUsername(name, username))
        .cast<String>();
  }

  Future<List<String>> loadFavouriteDrinks() async {
    return await ((await drinksPresentInCache())
        ? loadDrinksFromCache()
        : loadDrinksFromDynamoDB());
  }

  Future<Map<String, List<String>>> loadFavouriteDrinksFrom() async {
    return await ((await drinksPresentInCache()))
        ? {"cache": await loadDrinksFromCache()}
        : {"db": await loadDrinksFromDynamoDB()};
  }

  Future<Map<String, List<String>>>
      loadFavoriteDrinksAndRemoveContentFromCache() async {
    Map<String, List<String>> favouriteDrinks =
        await this.loadFavouriteDrinksFrom();
    String cacheStr = await loadUserInformationFromCache();
    Map<String, String> cache = await fromStringCachetoMapCache(cacheStr);
    cache.removeWhere(
      (String key, String value) => RegExp(r'^drink-\d+$').hasMatch(key),
    );
    cache["name"] =
        await LoggedInService.getSharedPreferenceValue("<nameUser>");
    await storeUserInformationInCache(cache);
    return favouriteDrinks;
  }
}

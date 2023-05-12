import 'package:coffee_orderer/services/urlService.dart';
import 'package:coffee_orderer/data_access/DynamoDBQuestionnaireDao.dart';
import 'package:coffee_orderer/models/question.dart';

class QuestionnaireController {
  UrlService urlServiceGetQuestions;
  String urlGetQuestions;
  DynamoDBQuestionnaireDao userDaoGetQuestions;

  UrlService urlServicePostAnswers;
  String urlPostAnswers;
  DynamoDBQuestionnaireDao userDaoPostAnswers;

  QuestionnaireController() {}

  Future<List<Question>> getAllQuestions() async {
    this.urlServiceGetQuestions = UrlService(
        "https://1xihq64176.execute-api.us-east-1.amazonaws.com/prod",
        "/questions",
        {"questionId": "09423213"});
    this.urlGetQuestions = this.urlServiceGetQuestions.createUrl();
    this.userDaoGetQuestions = DynamoDBQuestionnaireDao(this.urlGetQuestions);
    return await this.userDaoGetQuestions.getAllQuestions();
  }

  Future<String> postQuestionsToGetPredictedFavouriteDrink(
      Map<String, String> content) async {
    this.urlServicePostAnswers = UrlService(
        "https://1xihq64176.execute-api.us-east-1.amazonaws.com/prod",
        "/questions");
    this.urlPostAnswers = this.urlServicePostAnswers.createUrl();
    this.userDaoPostAnswers = DynamoDBQuestionnaireDao(this.urlPostAnswers);
    return await this
        .userDaoPostAnswers
        .postQuestionsToGetPredictedFavouriteDrink(content);
  }
}

import 'package:coffee_orderer/services/urlService.dart';
import 'package:coffee_orderer/data_access/DynamoDBQuestionnaireDao.dart';
import 'package:coffee_orderer/models/question.dart';

class QuestionnaireController {
  UrlService urlServiceGetQuestions;
  String urlGetQuestions;
  DynamoDBQuestionnaireDao userDaoGetQuestions;

  QuestionnaireController() {
    this.urlServiceGetQuestions = UrlService(
        "https://1xihq64176.execute-api.us-east-1.amazonaws.com/prod",
        "/questions",
        {"questionId": "09423213"});
    this.urlGetQuestions = this.urlServiceGetQuestions.createUrl();
    this.userDaoGetQuestions = DynamoDBQuestionnaireDao(this.urlGetQuestions);
  }

  Future<List<Question>> getAllQuestions() async {
    return await this.userDaoGetQuestions.getAllQuestions();
  }
}

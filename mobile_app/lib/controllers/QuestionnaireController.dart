import 'package:coffee_orderer/services/urlService.dart';
import 'package:coffee_orderer/data_access/DynamoDBQuestionnaireDao.dart';

class QuestionnaireController {
  UrlService urlServiceGetQuestions;
  String urlGetQuestions;
  DynamoDBQuestionnaireDao userDaoGetQuestions;

  QuestionnaireController() {
    this.urlServiceGetQuestions = UrlService(
        "https://2rbfw9r283.execute-api.us-east-1.amazonaws.com/prod",
        "/questions");
    this.urlGetQuestions = this.urlServiceGetQuestions.createUrl();
    this.userDaoGetQuestions = DynamoDBQuestionnaireDao(this.urlGetQuestions);
  }
}

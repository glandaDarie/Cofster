import 'package:coffee_orderer/data_access/DynamoDBDrinksInformationDao.dart';
import 'package:coffee_orderer/models/information.dart';
import 'package:coffee_orderer/services/urlService.dart';

class DrinksInformationController {
  UrlService urlServiceGetRespectiveDrinkInformation;
  String urlGetRespectiveDrinkInformation;
  DynamoDBDrinksInformationDao urlDaoGetRespectiveDrinkInformation;

  Future<Information> getInformationFromRespectiveDrink(String drink) async {
    this.urlServiceGetRespectiveDrinkInformation = UrlService(
        " https://ood8852240.execute-api.us-east-1.amazonaws.com/prod",
        "/drink_information",
        {"drinkId": "100", "drink": drink});
    this.urlGetRespectiveDrinkInformation =
        this.urlServiceGetRespectiveDrinkInformation.createUrl();
    this.urlDaoGetRespectiveDrinkInformation =
        DynamoDBDrinksInformationDao(this.urlGetRespectiveDrinkInformation);
    return await this
        .urlDaoGetRespectiveDrinkInformation
        .getInformationFromRespectiveDrink();
  }
}

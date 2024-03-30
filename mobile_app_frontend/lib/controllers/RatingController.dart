import 'package:coffee_orderer/services/urlService.dart';
import 'package:coffee_orderer/data_access/DynamoDBDrinksRatingDao.dart';

class RatingController {
  UrlService _urlServiceUpdateRating;
  String _urlUpdateRating;
  DynamoDBDrinksRatingDao _drinkDaoUpdateRating;

  UrlService _urlServiceGetRating;
  String _urlGetRating;
  DynamoDBDrinksRatingDao _drinkDaoGetRating;

  Future<String> updateRatingResponseGivenDrink(
      String drinkName, String drinkRating) async {
    this._urlServiceUpdateRating = UrlService(
        "https://mjed8soas4.execute-api.us-east-1.amazonaws.com/prod",
        "/rating",
        {"drinksId": "100", "drink": drinkName, "drink_rating": drinkRating});
    this._urlUpdateRating = this._urlServiceUpdateRating.createUrl();
    this._drinkDaoUpdateRating = DynamoDBDrinksRatingDao(this._urlUpdateRating);
    return await this._drinkDaoUpdateRating.updateRatingResponseGivenDrink();
  }

  Future<String> getDrinkRating(String drinkName) async {
    this._urlServiceGetRating = UrlService(
        "https://mjed8soas4.execute-api.us-east-1.amazonaws.com/prod",
        "/rating",
        {"drinksId": "100", "drink": drinkName});
    this._urlGetRating = this._urlServiceGetRating.createUrl();
    this._drinkDaoGetRating = DynamoDBDrinksRatingDao(this._urlGetRating);
    return await this._drinkDaoGetRating.getDrinkRating();
  }
}

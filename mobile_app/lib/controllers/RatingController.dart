import 'package:coffee_orderer/services/urlService.dart';
import 'package:coffee_orderer/data_access/DynamoDBDrinksRatingDao.dart';

class RatingController {
  UrlService _urlServiceUpdateRating;
  String _urlUpdateRating;
  DynamoDBDrinksRatingDao _drinkDaoUpdateRating;

  Future<String> updateRatingResponseGivenDrink(
      String drink, String drink_rating) async {
    this._urlServiceUpdateRating = UrlService(
        "https://jh80rgn246.execute-api.us-east-1.amazonaws.com/prod",
        "/rating",
        {"drinksId": "100", "drink": drink, "drink_rating": drink_rating});
    this._urlUpdateRating = this._urlServiceUpdateRating.createUrl();
    this._drinkDaoUpdateRating = DynamoDBDrinksRatingDao(this._urlUpdateRating);
    return await this._drinkDaoUpdateRating.updateRatingResponseGivenDrink();
  }

  Future<String> getDrinkRating() async {
    return await "dummy";
  }
}

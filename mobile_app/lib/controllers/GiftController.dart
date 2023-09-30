import 'package:coffee_orderer/data_access/DynamoDBGiftsDao.dart'
    show DynamoDBGiftsDao;
import 'package:coffee_orderer/services/urlService.dart' show UrlService;
import 'package:coffee_orderer/models/gift.dart' show Gift;

class GiftController {
  UrlService _urlServiceGift;
  String _urlGift;
  DynamoDBGiftsDao _urlDaoGift;

  Future<List<Gift>> getUserGifts(String name, String username) async {
    this._urlServiceGift = UrlService(
        "https://t90ka4phb9.execute-api.us-east-1.amazonaws.com/prod",
        "/gifts/user/gift",
        {"name": name, "username": username});
    this._urlGift = this._urlServiceGift.createUrl();
    this._urlDaoGift = DynamoDBGiftsDao(this._urlGift);
    return await this._urlDaoGift.getUserGifts();
  }

  Future<String> createGift(String name, String username, String gift) async {
    this._urlServiceGift = UrlService(
        "https://t90ka4phb9.execute-api.us-east-1.amazonaws.com/prod",
        "/gifts/user/gift");
    this._urlGift = this._urlServiceGift.createUrl();
    this._urlDaoGift = DynamoDBGiftsDao(this._urlGift);
    return await this._urlDaoGift.createGift(name, username, gift);
  }

  Future<String> deleteUserGift(
      String name, String username, String gift) async {
    this._urlServiceGift = UrlService(
        "https://t90ka4phb9.execute-api.us-east-1.amazonaws.com/prod",
        "/gifts/user/gift");
    this._urlGift = this._urlServiceGift.createUrl();
    this._urlDaoGift = DynamoDBGiftsDao(this._urlGift);
    return await this._urlDaoGift.deleteUserGift(name, username, gift);
  }
}

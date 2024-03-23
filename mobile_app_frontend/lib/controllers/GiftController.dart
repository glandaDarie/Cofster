import 'package:coffee_orderer/data_access/DynamoDBGiftsDao.dart'
    show DynamoDBGiftsDao;
import 'package:coffee_orderer/services/giftService.dart' show GiftService;
import 'package:coffee_orderer/services/urlService.dart' show UrlService;
import 'package:coffee_orderer/utils/constants.dart' show ORDERS_TABLE;

class GiftController {
  UrlService _urlServiceGift;
  String _urlGift;
  DynamoDBGiftsDao _urlDaoGift;
  GiftService _giftService;

  GiftController() : this._giftService = GiftService(tableName: ORDERS_TABLE);

  Future<dynamic> getUserGifts() async {
    List<String> params = await this._giftService.loadGiftParams();
    this._urlServiceGift = UrlService(
        "https://t90ka4phb9.execute-api.us-east-1.amazonaws.com/prod",
        "/gifts/user/gift",
        {"name": params[0], "username": params[1]});
    this._urlGift = this._urlServiceGift.createUrl();
    this._urlDaoGift = DynamoDBGiftsDao(this._urlGift);
    return await this._urlDaoGift.getUserGifts();
  }

  Future<String> createGift(String gift) async {
    this._urlServiceGift = UrlService(
        "https://t90ka4phb9.execute-api.us-east-1.amazonaws.com/prod",
        "/gifts/user");
    this._urlGift = this._urlServiceGift.createUrl();
    this._urlDaoGift = DynamoDBGiftsDao(this._urlGift);
    return await this._giftService.createGift(gift, this._urlDaoGift);
  }

  Future<String> deleteUserGift(String gift) async {
    this._urlServiceGift = UrlService(
        "https://t90ka4phb9.execute-api.us-east-1.amazonaws.com/prod",
        "/gifts/user/gift");
    this._urlGift = this._urlServiceGift.createUrl();
    this._urlDaoGift = DynamoDBGiftsDao(this._urlGift);
    return await this._giftService.deleteUserGift(gift, this._urlDaoGift);
  }
}

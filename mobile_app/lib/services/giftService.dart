import 'package:coffee_orderer/data_access/DynamoDBGiftsDao.dart'
    show DynamoDBGiftsDao;
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;

class GiftService {
  Future<String> createGift(String gift, DynamoDBGiftsDao dao) async {
    List<String> giftParams = await this._loadGiftParams();
    return await dao.createGift(giftParams[0], giftParams[1], gift);
  }

  Future<String> deleteUserGift(String gift, DynamoDBGiftsDao dao) async {
    List<String> giftParams = await this._loadGiftParams();
    return await dao.deleteUserGift(giftParams[0], giftParams[1], gift);
  }

  Future<List<String>> _loadGiftParams() async {
    return [
      await LoggedInService.getSharedPreferenceValue("<nameUser>"),
      await LoggedInService.getSharedPreferenceValue("<username>")
    ];
  }
}

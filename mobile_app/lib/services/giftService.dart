import 'package:coffee_orderer/data_access/DynamoDBGiftsDao.dart'
    show DynamoDBGiftsDao;
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';

class GiftService {
  DatabaseReference databaseReference;
  GiftService({@required String tableName})
      : this.databaseReference =
            FirebaseDatabase.instance.ref().child(tableName);

  Future<String> createGift(String gift, DynamoDBGiftsDao dao) async {
    List<String> giftParams = await this.loadGiftParams();
    return await dao.createGift(giftParams[0], giftParams[1], gift);
  }

  Future<String> deleteUserGift(String gift, DynamoDBGiftsDao dao) async {
    List<String> giftParams = await this.loadGiftParams();
    return await dao.deleteUserGift(giftParams[0], giftParams[1], gift);
  }

  Future<List<String>> loadGiftParams() async {
    return [
      await LoggedInService.getSharedPreferenceValue("<nameUser>"),
      await LoggedInService.getSharedPreferenceValue("<username>")
    ];
  }

  bool orderDataChanged(Map<String, dynamic> orderData) {
    if (orderData == null) {
      return false;
    }
    return orderData["coffeeStatus"];
  }
}

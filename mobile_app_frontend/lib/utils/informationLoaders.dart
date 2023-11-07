import 'package:flutter/material.dart';
import 'package:coffee_orderer/utils/localUserInformation.dart'
    show loadUserInformationFromCache, fromStringCachetoMapCache;

class InformationLoaders {
  static Future<dynamic> getCoffeeCardInformationFromPreviousScreen(
      String key) async {
    String cacheStr = await loadUserInformationFromCache();
    String value = fromStringCachetoMapCache(cacheStr)[key];
    if (key == "cardCoffeeName" || key == "cardDescription") {
      value = value.replaceAll("-", " ");
    }
    if (key == "cardImgPath") {
      return AssetImage(value);
    }
    return value;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:coffee_orderer/utils/localUserInformation.dart';
import 'package:coffee_orderer/utils/toast.dart' show ToastUtils;

class RatingBarService {
  static RatingBar ratingBar(ValueNotifier<double> ratingBarNotifier,
      ValueNotifier<bool> placedOrderNotifier,
      [double intialRating = 0.0, double minRating = 1.0, int itemCount = 5]) {
    return RatingBar.builder(
        initialRating: intialRating,
        minRating: minRating,
        direction: Axis.horizontal,
        allowHalfRating: false,
        itemCount: itemCount,
        itemPadding: EdgeInsets.only(right: 30.0),
        itemSize: 50.0,
        itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
        onRatingUpdate: (double ratingBar) async {
          String cacheStr = await loadUserInformationFromCache();
          Map<String, String> cache = fromStringCachetoMapCache(cacheStr);
          ToastUtils.showToast(
              "You gave this ${cache['cardCoffeeName']} a rating of ${ratingBar}");
          ratingBarNotifier.value = ratingBar;
          placedOrderNotifier.value = false;
        });
  }
}

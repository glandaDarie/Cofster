import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:coffee_orderer/utils/localUserInformation.dart';
import 'package:coffee_orderer/controllers/RatingController.dart';

class RatingBarDrink {
  static RatingBar ratingBar(ValueNotifier<double> ratingBarNotifier,
      ValueNotifier<bool> placedOrderNotifier,
      [double intialRating = 0.0,
      double minRating = 1.0,
      double maxRating = 5.0,
      int itemCount = 5]) {
    RatingController _ratingController;
    return RatingBar.builder(
        initialRating: intialRating,
        minRating: minRating,
        maxRating: maxRating,
        direction: Axis.horizontal,
        allowHalfRating: true,
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
          _ratingController = RatingController();
          String response =
              await _ratingController.updateRatingResponseGivenDrink(
                  cache["cardCoffeeName"], ratingBar.toString());
          if (response.contains("Error")) {
            Fluttertoast.showToast(
                msg: "Response: ${response}",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Color.fromARGB(255, 102, 33, 12),
                textColor: Color.fromARGB(255, 220, 217, 216),
                fontSize: 20);
            return;
          }
          Fluttertoast.showToast(
              msg:
                  "You gave this ${cache['cardCoffeeName']} a rating of ${ratingBar}\nThank you for giving us feedback!",
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Color.fromARGB(255, 102, 33, 12),
              textColor: Color.fromARGB(255, 220, 217, 216),
              fontSize: 20);
          ratingBarNotifier.value = ratingBar;
          placedOrderNotifier.value = false;
        });
  }

  static void startRatingDisplayCountdown(
      BuildContext context, ValueNotifier<bool> placedOrderNotifier,
      {int time = 30}) {
    Future.delayed(Duration(seconds: time), () {
      placedOrderNotifier.value = true;
    });
  }
}

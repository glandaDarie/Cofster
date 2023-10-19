import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/detailsScreen/messageDialog.dart'
    show MessageDialog;
import 'package:coffee_orderer/controllers/GiftController.dart'
    show GiftController;
import 'package:coffee_orderer/utils/toast.dart' show ToastUtils;

FirebaseAnimatedList FirebaseOrderAnimatedList(
  DatabaseReference databaseReference,
  BuildContext context, {
  bool deleteGift = null,
  String giftName = null,
}) {
  return FirebaseAnimatedList(
    query: databaseReference,
    shrinkWrap: true,
    itemBuilder: (BuildContext contextAnimatedList,
        DataSnapshot snapshotAnimatedList,
        Animation<double> animationAnimatedList,
        dynamic indexAnimatedList) {
      dynamic key = snapshotAnimatedList.key;
      dynamic value = snapshotAnimatedList.value;
      if (key == "coffeeStatus" && value == 1) {
        Future.delayed(
          Duration.zero,
          () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return MessageDialog(
                  message: "Drink is ready",
                );
              },
            );
          },
        );
        if (deleteGift != null && giftName != null) {
          if (deleteGift) {
            GiftController giftController = GiftController();
            giftController.deleteUserGift(giftName).then(
              (String response) {
                if (response != null) {
                  ToastUtils.showToast(response);
                  return;
                }
              },
            ).onError(
              (error, stackTrace) {
                ToastUtils.showToast("Error: ${error}");
              },
            );
          }
        }
      }
      return SizedBox.shrink();
    },
  );
}

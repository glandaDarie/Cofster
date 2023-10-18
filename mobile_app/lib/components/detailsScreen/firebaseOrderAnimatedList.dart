import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/detailsScreen/messageDialog.dart'
    show MessageDialog;

FirebaseAnimatedList FirebaseOrderAnimatedList(
  DatabaseReference databaseReference,
  BuildContext context,
) {
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
      }
      return SizedBox.shrink();
    },
  );
}

import 'package:coffee_orderer/controllers/PurchaseHistoryController.dart'
    show PurchaseHistoryController;
import 'package:coffee_orderer/services/paymentService.dart'
    show PaymentService;
import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/detailsScreen/drinkCustomSelector.dart'
    show customizeDrink;

void drinkCustomSelectorSheet(
  BuildContext detailsScreenContext,
  ValueNotifier<bool> placedOrderNotifier,
  PaymentService paymentService,
  PurchaseHistoryController purchaseHistoryController, {
  String previousScreenName = "MainPage",
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.white,
    isDismissible: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    context: detailsScreenContext,
    builder: (BuildContext context) {
      return customizeDrink(
        context,
        placedOrderNotifier,
        paymentService,
        purchaseHistoryController,
        previousScreenName: previousScreenName,
      );
    },
  );
}

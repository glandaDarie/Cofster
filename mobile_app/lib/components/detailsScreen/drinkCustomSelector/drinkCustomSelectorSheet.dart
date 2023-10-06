import 'package:coffee_orderer/controllers/PurchaseHistoryController.dart'
    show PurchaseHistoryController;
import 'package:coffee_orderer/services/paymentService.dart'
    show PaymentService;
import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/detailsScreen/drinkCustomSelector.dart'
    show customizeDrink;

void drinkCustomSelectorSheet(
  BuildContext context,
  ValueNotifier<bool> placedOrderNotifier,
  PaymentService paymentService,
  PurchaseHistoryController purchaseHistoryController,
) {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.white,
    isDismissible: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    context: context,
    builder: (BuildContext context) {
      return customizeDrink(
        context,
        placedOrderNotifier,
        paymentService,
        purchaseHistoryController,
      );
    },
  );
}

import 'package:coffee_orderer/services/orderService.dart' show OrderService;
import 'package:flutter/material.dart';
import 'package:coffee_orderer/services/paymentService.dart'
    show PaymentService;
import 'package:coffee_orderer/controllers/PurchaseHistoryController.dart'
    show PurchaseHistoryController;

// not merged with the rest of the code because of an unexpected bug happening to the extraIngredientUpdater
// (it returns back from the other function null without any reason whatsoever)
ElevatedButton OrderButton({
  @required BuildContext context,
  @required PaymentService paymentService,
  @required PurchaseHistoryController purchaseHistoryController,
  @required Map<String, dynamic> extraIngredientUpdater,
  @required ValueNotifier<bool> placedOrderNotifier,
  @required BuildContext providerContext,
  String textData = "Order",
  double textScaleFactor = 1.5,
  Color backgroundColor = const Color(0xFF473D3A),
  Color foregroundColor = Colors.white,
  double borderRadius = 25,
}) {
  return ElevatedButton(
    onPressed: () async {
      await OrderService(
        context,
        paymentService,
        purchaseHistoryController,
        extraIngredientUpdater,
        placedOrderNotifier,
      ).placeOrder();
    },
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        backgroundColor,
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ),
    child: Text(
      textData,
      textScaleFactor: textScaleFactor,
      style: TextStyle(fontFamily: 'varela', color: foregroundColor)
          .copyWith(fontWeight: FontWeight.w700),
    ),
  );
}

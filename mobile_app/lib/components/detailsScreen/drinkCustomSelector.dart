import 'package:coffee_orderer/components/detailsScreen/drinkCustomSelector/extraIngredients.dart'
    show extraIngredients;
import 'package:coffee_orderer/components/detailsScreen/drinkCustomSelector/boxCupSize.dart'
    show boxCupSize;
import 'package:coffee_orderer/controllers/PurchaseHistoryController.dart';
import 'package:coffee_orderer/services/orderService.dart' show OrderService;
import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/detailsScreen/boxQuantity.dart'
    show boxQuantity;
import 'package:coffee_orderer/components/detailsScreen/boxTemperature.dart'
    show boxTemperature;
import 'package:coffee_orderer/services/mergeNotifierService.dart';
import 'package:coffee_orderer/services/paymentService.dart'
    show PaymentService;
import 'package:coffee_orderer/services/notifierCustomSelectorSetupService.dart'
    show NotifierCustomSelectorSetupService;
import 'package:coffee_orderer/utils/extraIngredientChange.dart'
    show updateUIWithChangesOnExtraIngredients;

SizedBox customizeDrink(
    BuildContext context,
    ValueNotifier<bool> placedOrderNotifier,
    PaymentService paymentService,
    PurchaseHistoryController purchaseHistoryController) {
  Map<String, dynamic> extraIngredientUpdater;
  NotifierCustomSelectorSetupService notifierService =
      NotifierCustomSelectorSetupService(1, "M", false, 0, 1, 1);
  notifierService.attachAllListenersToNotifiers();
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.72,
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.cancel_sharp,
                      size: 40,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                boxTemperature(notifierService.hotSelectedNotifier),
                boxQuantity(notifierService.valueQuantityNotifier),
              ],
            ),
          ),
          ...boxCupSize(notifierService.selectedSizeNotifier),
          Column(
            children: extraIngredients(notifierService)
                .map((dynamic extraIngredient) => Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: extraIngredient,
                    ))
                .toList(),
          ),
          const SizedBox(height: 5.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, thickness: 0.3, color: Colors.black38),
          ),
          const SizedBox(height: 5.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total",
                      style: const TextStyle(
                              fontFamily: 'varela', color: Color(0xFF473D3A))
                          .copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.brown.shade500),
                      textScaleFactor: 1.6,
                    ),
                    ValueListenableBuilder(
                        valueListenable: notifierService.mergedNotifiers,
                        builder: (BuildContext context,
                            MergeNotifiers notifiers, Widget child) {
                          extraIngredientUpdater =
                              updateUIWithChangesOnExtraIngredients(
                            notifiers.selectedValue,
                            notifiers.sugarQuantity,
                            notifiers.iceQuantity,
                            notifiers.creamNotifier,
                            quantity: notifiers.quantity,
                          );
                          return Text(
                            "\$${extraIngredientUpdater['price']}",
                            style: TextStyle(
                                    fontFamily: 'varela',
                                    color: Color(0xFF473D3A))
                                .copyWith(fontWeight: FontWeight.w900),
                            textScaleFactor: 1.9,
                          );
                        }),
                  ],
                ),
                SizedBox(
                  height: 60,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () async {
                      OrderService(
                              context,
                              paymentService,
                              purchaseHistoryController,
                              extraIngredientUpdater,
                              placedOrderNotifier)
                          .placeOrder();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF473D3A)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    child: Text(
                      "Order",
                      textScaleFactor: 1.5,
                      style:
                          TextStyle(fontFamily: 'varela', color: Colors.white)
                              .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

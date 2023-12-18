import 'package:coffee_orderer/components/detailsScreen/drinkCustomSelector/extraIngredients.dart'
    show extraIngredients;
import 'package:coffee_orderer/components/detailsScreen/drinkCustomSelector/boxCupSize.dart'
    show boxCupSize;
import 'package:coffee_orderer/controllers/PurchaseHistoryController.dart'
    show PurchaseHistoryController;
import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/detailsScreen/boxQuantity.dart'
    show boxQuantity;
import 'package:coffee_orderer/components/detailsScreen/boxTemperature.dart'
    show boxTemperature;
import 'package:coffee_orderer/services/mergeNotifierService.dart'
    show MergeNotifiers;
import 'package:coffee_orderer/services/paymentService.dart'
    show PaymentService;
import 'package:coffee_orderer/services/notifierCustomSelectorSetupService.dart'
    show NotifierCustomSelectorSetupService;
import 'package:coffee_orderer/utils/extraIngredientChange.dart'
    show updateUIWithChangesOnExtraIngredients;
import 'package:coffee_orderer/utils/coffeeName.dart'
    show getCoffeeNameFromCache;
import 'package:coffee_orderer/models/ingredientUpdater.dart'
    show IngredientUpdater;
import 'package:coffee_orderer/components/detailsScreen/drinkCustomSelector/orderButton.dart'
    show OrderButton;
import 'package:coffee_orderer/utils/constants.dart'
    show
        DEFAULT_DRINK_QUANTITY,
        DEFAULT_DRINK_SIZE,
        DEFAULT_IS_DRINK_HOT,
        DEFAULT_SUGAR_CUBES_QUANTITY,
        DEFAULT_ICE_CUBES_QUANTITY,
        DEFAULT_CREAM;

FutureBuilder<String> customizeDrink(
  BuildContext context,
  ValueNotifier<bool> placedOrderNotifier,
  PaymentService paymentService,
  PurchaseHistoryController purchaseHistoryController, {
  String previousScreenName = "MainPage",
}) {
  Map<String, dynamic> extraIngredientUpdater = {};
  final IngredientUpdater ingredientUpdater =
      IngredientUpdater(extraIngredientUpdater);
  NotifierCustomSelectorSetupService notifierService =
      NotifierCustomSelectorSetupService(
    DEFAULT_DRINK_QUANTITY,
    DEFAULT_DRINK_SIZE,
    DEFAULT_IS_DRINK_HOT,
    DEFAULT_SUGAR_CUBES_QUANTITY,
    DEFAULT_ICE_CUBES_QUANTITY,
    DEFAULT_CREAM,
  );
  notifierService.attachAllListenersToNotifiers();
  return FutureBuilder<String>(
    future: getCoffeeNameFromCache(),
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator(
            color: Colors.brown, backgroundColor: Colors.white);
      } else if (snapshot.hasError) {
        return Text("Error when fetching the coffee price: ${snapshot.error}");
      } else {
        String coffeeName = snapshot.data;
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  child:
                      Divider(height: 1, thickness: 0.3, color: Colors.black38),
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
                                    fontFamily: 'varela',
                                    color: Color(0xFF473D3A))
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
                                coffeeName.replaceAll("-", " "),
                                notifiers.selectedValue,
                                notifiers.sugarQuantity,
                                notifiers.iceQuantity,
                                notifiers.creamNotifier,
                                quantity: notifiers.quantity,
                                previousScreenName: previousScreenName,
                              );
                              ingredientUpdater.ingredientUpdater =
                                  extraIngredientUpdater;
                              return Text(
                                "\$${extraIngredientUpdater['price']}",
                                style: TextStyle(
                                  fontFamily: 'varela',
                                  color: Color(0xFF473D3A),
                                ).copyWith(fontWeight: FontWeight.w900),
                                textScaleFactor: 1.9,
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width - 160,
                        child: OrderButton(
                          context: context,
                          paymentService: paymentService,
                          purchaseHistoryController: purchaseHistoryController,
                          ingredientUpdater: ingredientUpdater,
                          placedOrderNotifier: placedOrderNotifier,
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
    },
  );
}

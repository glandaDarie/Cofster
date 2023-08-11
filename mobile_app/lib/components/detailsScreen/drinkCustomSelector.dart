import 'package:coffee_orderer/models/information.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/detailsScreen/boxSizes.dart'
    show boxSizes;
import 'package:coffee_orderer/components/detailsScreen/boxQuantity.dart'
    show boxQuantity;
import 'package:coffee_orderer/components/detailsScreen/boxTemperature.dart'
    show boxTemperature;
import 'package:coffee_orderer/components/detailsScreen/boxExtraIngredient.dart'
    show ExtraIngredientWidget, ExtraIngredientWidgetBinary;
import 'package:coffee_orderer/utils/boxProperties.dart'
    show sizes, additionalTopings;
import 'package:coffee_orderer/services/mergeNotifierService.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/localUserInformation.dart';
import 'package:coffee_orderer/services/paymentService.dart'
    show PaymentService;
import 'package:coffee_orderer/utils/appAssets.dart' show AppAssets;
import 'package:coffee_orderer/services/notificationService.dart'
    show NotificationService;
import 'package:coffee_orderer/utils/constants.dart' show DEFAULT_PRICE;
import 'package:coffee_orderer/controllers/OrderInformationController.dart'
    show OrderInformationController;
import 'package:coffee_orderer/enums/orderStatusTypes.dart'
    show CoffeeOrderState;
import 'package:coffee_orderer/services/timeOrdererService.dart'
    show timeOfOrder;
import 'package:coffee_orderer/controllers/DrinksInformationController.dart'
    show DrinksInformationController;
import 'package:coffee_orderer/services/updateProviderService.dart'
    show UpdateProvider;
import 'package:provider/provider.dart';

SizedBox customizeDrink(BuildContext context,
    ValueNotifier<bool> placedOrderNotifier, PaymentService paymentService) {
  int _quantityCount = 1;
  double _price;
  ValueNotifier<int> valueQuantityNotifier = ValueNotifier<int>(1);
  ValueNotifier<String> selectedSizeNotifier = ValueNotifier<String>("M");
  ValueNotifier<bool> hotSelectedNotifier = ValueNotifier<bool>(false);
  ValueNotifier<int> sugarQuantityNotifier = ValueNotifier<int>(0);
  ValueNotifier<int> iceQuantityNotifier = ValueNotifier<int>(1);
  ValueNotifier<int> creamNotifier = ValueNotifier<int>(1);

  ValueNotifierService<MergeNotifiers> combinedValueNotifier =
      ValueNotifierService<MergeNotifiers>(MergeNotifiers(
          valueQuantityNotifier.value,
          selectedSizeNotifier.value,
          sugarQuantityNotifier.value,
          iceQuantityNotifier.value,
          creamNotifier.value));

  valueQuantityNotifier.addListener(() {
    combinedValueNotifier.value = MergeNotifiers(
        valueQuantityNotifier.value,
        selectedSizeNotifier.value,
        sugarQuantityNotifier.value,
        iceQuantityNotifier.value,
        creamNotifier.value);
  });
  selectedSizeNotifier.addListener(() {
    combinedValueNotifier.value = MergeNotifiers(
        valueQuantityNotifier.value,
        selectedSizeNotifier.value,
        sugarQuantityNotifier.value,
        iceQuantityNotifier.value,
        creamNotifier.value);
  });
  sugarQuantityNotifier.addListener(() {
    combinedValueNotifier.value = MergeNotifiers(
        valueQuantityNotifier.value,
        selectedSizeNotifier.value,
        sugarQuantityNotifier.value,
        iceQuantityNotifier.value,
        creamNotifier.value);
  });
  iceQuantityNotifier.addListener(() {
    combinedValueNotifier.value = MergeNotifiers(
        valueQuantityNotifier.value,
        selectedSizeNotifier.value,
        sugarQuantityNotifier.value,
        iceQuantityNotifier.value,
        creamNotifier.value);
  });
  creamNotifier.addListener(() {
    combinedValueNotifier.value = MergeNotifiers(
        valueQuantityNotifier.value,
        selectedSizeNotifier.value,
        sugarQuantityNotifier.value,
        iceQuantityNotifier.value,
        creamNotifier.value);
  });

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
                boxTemperature(hotSelectedNotifier),
                boxQuantity(valueQuantityNotifier),
              ],
            ),
          ),
          const SizedBox(height: 5.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, thickness: 0.3, color: Colors.black38),
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: boxSizes(selectedSizeNotifier),
          ),
          const SizedBox(height: 5.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, thickness: 0.3, color: Colors.black38),
          ),
          const SizedBox(height: 5.0),
          Column(
            children: [
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ExtraIngredientWidget(
                    sugarQuantityNotifier,
                    "Sugar",
                    "cubes",
                    AssetImage(AppAssets.extraIngredeints.IMAGE_SUGAR)
                        .assetName),
              ),
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ExtraIngredientWidget(
                    iceQuantityNotifier,
                    "Ice",
                    "cubes",
                    AssetImage(AppAssets.extraIngredeints.IMAGE_ICE).assetName),
              ),
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ExtraIngredientWidgetBinary(
                    creamNotifier,
                    "Cream",
                    AssetImage(AppAssets.extraIngredeints.IMAGE_CREAM)
                        .assetName),
              ),
            ],
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
                        valueListenable: combinedValueNotifier,
                        builder: (BuildContext context,
                            MergeNotifiers notifiers, Widget child) {
                          final int quantityCount = notifiers.quantity;
                          final String selectedValue = notifiers.selectedValue;
                          final int sugarCubes = notifiers.sugarQuantity;
                          final int iceCubes = notifiers.iceQuantity;
                          final int hasCream = notifiers.creamNotifier;
                          _quantityCount = quantityCount;
                          _price = DEFAULT_PRICE;
                          _price = (_price *
                                  quantityCount *
                                  sizes[selectedValue]) +
                              ((sugarCubes - 1) * additionalTopings["sugar"]) +
                              ((iceCubes - 1) * additionalTopings["ice"]) +
                              (hasCream == 1 ? additionalTopings["cream"] : 0);
                          return Text("\$${_price.toStringAsFixed(2)}",
                              style: TextStyle(
                                      fontFamily: 'varela',
                                      color: Color(0xFF473D3A))
                                  .copyWith(fontWeight: FontWeight.w900),
                              textScaleFactor: 1.9);
                        }),
                  ],
                ),
                SizedBox(
                  height: 60,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () async {
                      String cacheStr = await loadUserInformationFromCache();
                      Map<String, String> cache =
                          fromStringCachetoMapCache(cacheStr);
                      String paymentResponse = await paymentService.makePayment(
                          context,
                          (_price * 100).toInt().toStringAsFixed(0),
                          cache["cardCoffeeName"],
                          "USD",
                          numberOfCoffeeDrinks: _quantityCount);
                      if (paymentResponse != "success") {
                        Fluttertoast.showToast(
                            msg: paymentResponse,
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Color.fromARGB(255, 71, 66, 65),
                            textColor: Color.fromARGB(255, 220, 217, 216),
                            fontSize: 16);
                        return;
                      }
                      // dummy time for testing, this will be estimated using a neural network or some calculations
                      String userName =
                          cache.containsKey("name") ? cache["name"] : "Guest";
                      String drinkPlural = _quantityCount == 1
                          ? cache["cardCoffeeName"]
                          : "${cache['cardCoffeeName']}s";
                      String title =
                          "${_quantityCount == 1 ? "Order is" : "Orders are"} in progress!";
                      String body =
                          "$userName, your $_quantityCount $drinkPlural ${_quantityCount == 1 ? "is" : "are"} in preparation. Please put a coffee cup near the machine.";
                      NotificationService().showNotification(
                        title: title,
                        body: body,
                      );
                      DrinksInformationController drinkInformationController =
                          DrinksInformationController();
                      Information information = await drinkInformationController
                          .getInformationFromRespectiveDrink(
                              cache["cardCoffeeName"]);
                      int preparationTime;
                      try {
                        preparationTime = int.parse(
                            information.preparationTime.split(" ")[0]);
                      } catch (error) {
                        Fluttertoast.showToast(
                            msg: error,
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Color.fromARGB(255, 71, 66, 65),
                            textColor: Color.fromARGB(255, 220, 217, 216),
                            fontSize: 16);
                        return;
                      }
                      String postOrderResponse =
                          await OrderInformationController
                              .postOrderToOrdersInformation("Orders", {
                        "coffeeName": cache["cardCoffeeName"],
                        "coffeePrice": "${_price}\$",
                        "quantity": _quantityCount,
                        "communication": "broadcast",
                        "coffeeStatus": CoffeeOrderState.ORDER_PLACED.index,
                        "coffeeOrderTime": timeOfOrder(),
                        "coffeeFinishTimeEstimation": timeOfOrder(
                            secondsDelay: preparationTime * _quantityCount)
                      });
                      if (postOrderResponse != null) {
                        Fluttertoast.showToast(
                            msg: postOrderResponse,
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Color.fromARGB(255, 71, 66, 65),
                            textColor: Color.fromARGB(255, 220, 217, 216),
                            fontSize: 16);
                        return;
                      }

                      Provider.of<UpdateProvider>(context, listen: false)
                          .triggerUpdate();

                      // CommunicationSubscriberService communicationSubService = FirebaseCommunicationSubscriberService().publish(content);
                      // this should run on a separated thread and also make it globally to appear on any of the windows

                      Future.delayed(Duration(seconds: 30), () {
                        placedOrderNotifier.value = true;
                      });
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

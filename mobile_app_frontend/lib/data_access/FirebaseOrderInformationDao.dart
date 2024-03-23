import 'package:firebase_database/firebase_database.dart';
import 'package:coffee_orderer/services/passwordGeneratorService.dart'
    show generateNewPassword;
import 'package:coffee_orderer/models/orderInformation.dart'
    show OrderInformation;
import 'package:coffee_orderer/providers/orderIDProvider.dart'
    show OrderIDProvider;
import 'package:coffee_orderer/utils/constants.dart' show ORDERS_TABLE;

class FirebaseOrderInformationDao {
  FirebaseOrderInformationDao();

  static Future<List<OrderInformation>> getAllOrdersInformation(
      String endpoint) async {
    DataSnapshot dataSnapshot;
    List<Map<String, dynamic>> ordersList = [];
    try {
      DatabaseReference reference =
          FirebaseDatabase.instance.ref().child(endpoint);
      dataSnapshot = await reference.get();
      assert(dataSnapshot.exists, "Snapshot does not exist");
      if (dataSnapshot.value is Map) {
        (dataSnapshot.value as Map).forEach((dynamic key, dynamic value) {
          if (value is Map) {
            ordersList.add({
              "key": key,
              ...value,
            });
          }
        });
      }
    } catch (error) {
      throw "Error when fetching the data from firebase: ${error}";
    }
    return ordersList
        .map(
          (Map<String, dynamic> order) => OrderInformation(
            keyId: order["key"],
            coffeeName: order["coffeeName"],
            customerName: order["customerName"],
            coffeePrice: order["coffeePrice"],
            recipeType: order["recipeType"],
            quantity: order["quantity"],
            communication: order["communication"],
            coffeeStatus: order["coffeeStatus"],
            coffeeOrderTime: order["coffeeOrderTime"],
            coffeeEstimationTime: order["coffeeFinishTimeEstimation"],
            coffeeCupSize: order.containsKey("coffeeCupSize")
                ? order["coffeeCupSize"]
                : null,
            coffeeTemperature: order.containsKey("coffeeTemperature")
                ? order["coffeeTemperature"]
                : null,
            numberOfSugarCubes: order.containsKey("numberOfSugarCubes")
                ? order["numberOfSugarCubes"]
                : null,
            numberOfIceCubes: order.containsKey("numberOfIceCubes")
                ? order["numberOfIceCubes"]
                : null,
            hasCream: order.containsKey("hasCream") ? order["hasCream"] : null,
          ),
        )
        .toList();
  }

  static Future<String> postOrderToOrdersInformation(
    String endpoint,
    Map<String, dynamic> content,
  ) async {
    String orderID = "id_${generateNewPassword(
      passwordLength: 9,
      strengthPasswordThreshold: 0.1,
      checkPassword: false,
      specialChar: false,
    )}";

    Map<String, dynamic> orderData = {
      "coffeeName": content["coffeeName"],
      "customerName": content["customerName"],
      "coffeePrice": content["coffeePrice"],
      "recipeType": content["recipeType"],
      "quantity": content["quantity"],
      "communication": content["communication"],
      "coffeeStatus": content["coffeeStatus"],
      "coffeeOrderTime": content["coffeeOrderTime"],
      "coffeeFinishTimeEstimation": content["coffeeFinishTimeEstimation"],
    };

    OrderIDProvider.instance.orderID = orderID;
    print("Actual length: ${orderData.length}");
    try {
      DatabaseReference reference =
          FirebaseDatabase.instance.ref().child(ORDERS_TABLE).child(orderID);
      if (content.length > orderData.length) {
        // checks if the card is a flash card or normal card (the back of the card)
        orderData = {
          ...orderData,
          "coffeeCupSize": content["coffeeCupSize"],
          "coffeeTemperature": content["coffeeTemperature"],
          "numberOfSugarCubes": content["numberOfSugarCubes"],
          "numberOfIceCubes": content["numberOfIceCubes"],
          "hasCream": content["hasCream"]
        };
      }
      await reference.set(orderData);
    } catch (error) {
      return "Error when inserting data into firebase: ${error}";
    }
    return null;
  }
}

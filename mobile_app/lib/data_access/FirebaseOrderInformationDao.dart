import 'package:firebase_database/firebase_database.dart';
import 'package:coffee_orderer/services/passwordGeneratorService.dart'
    show generateNewPassword;
import 'package:coffee_orderer/models/orderInformation.dart'
    show OrderInformation;

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
        .map((Map<String, dynamic> order) => OrderInformation(
              order["key"],
              order["coffeeName"],
              order["coffeePrice"],
              order["quantity"],
              order["communication"],
              order["coffeeStatus"],
              order["coffeeOrderTime"],
              order["coffeeFinishTimeEstimation"],
              order.containsKey("coffeeCupSize")
                  ? order["coffeeCupSize"]
                  : null,
              order.containsKey("coffeeTemperature")
                  ? order["coffeeTemperature"]
                  : null,
              order.containsKey("numberOfSugarCubes")
                  ? order["numberOfSugarCubes"]
                  : null,
              order.containsKey("numberOfIceCubes")
                  ? order["numberOfIceCubes"]
                  : null,
              order.containsKey("hasCream") ? order["hasCream"] : null,
            ))
        .toList();
  }

  static Future<String> postOrderToOrdersInformation(
      String endpoint, Map<String, dynamic> content) async {
    try {
      DatabaseReference reference = FirebaseDatabase.instance
          .ref()
          .child("Orders")
          .child("id_${generateNewPassword(
            passwordLength: 9,
            strengthPasswordThreshold: 0.1,
            checkPassword: false,
            specialChar: false,
          )}");
      Map<String, dynamic> orderData = {
        "coffeeName": content["coffeeName"],
        "coffeePrice": content["coffeePrice"],
        "quantity": content["quantity"],
        "communication": content["communication"],
        "coffeeStatus": content["coffeeStatus"],
        "coffeeOrderTime": content["coffeeOrderTime"],
        "coffeeFinishTimeEstimation": content["coffeeFinishTimeEstimation"],
      };
      if (content.length > 7) {
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

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
            ))
        .toList();
  }

  static Future<String> postOrderToOrdersInformation(
      String endpoint, Map<String, dynamic> content) async {
    print("content: ${content}");
    print("endpoint: ${endpoint}");
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
      await reference.set({
        "coffeeName": content["coffeeName"],
        "coffeePrice": content["coffeePrice"],
        "quantity": content["quantity"],
        "communication": content["communication"],
        "coffeeStatus": content["coffeeStatus"],
        "coffeeOrderTime": content["coffeeOrderTime"],
        "coffeeFinishTimeEstimation": content["coffeeFinishTimeEstimation"],
      });
    } catch (error) {
      return "Error when inserting data into firebase: ${error}";
    }
    return null;
  }
}

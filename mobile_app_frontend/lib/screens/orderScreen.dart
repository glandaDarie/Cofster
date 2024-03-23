import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/models/orderInformation.dart'
    show OrderInformation;
import 'package:coffee_orderer/utils/displayContentCards.dart'
    show displayContentCards;
import 'package:coffee_orderer/utils/constants.dart' show ORDERS_TABLE;

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<dynamic> _orderList;
  Map<String, bool> _isFlippedMap;

  _OrderPageState() {
    this._orderList = null;
    _isFlippedMap = Map.fromEntries(
      List.generate(
        100,
        (int index) => MapEntry("isFlipped${index}", false),
      ),
    );
  }

  void _flipCard(int index) {
    setState(() {
      this._isFlippedMap["isFlipped${index}"] =
          !this._isFlippedMap["isFlipped${index}"];
    });
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        this._isFlippedMap["isFlipped${index}"] = false;
      });
    });
  }

  bool _isCardFlipped(int index) {
    return this._isFlippedMap["isFlipped${index}"];
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseReference reference =
        FirebaseDatabase.instance.ref().child(ORDERS_TABLE);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          ORDERS_TABLE,
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        backgroundColor: Colors.brown.shade700,
      ),
      body: FirebaseAnimatedList(
        query: reference,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          String coffeeInfromation = snapshot.value.toString();
          String parsedCoffeeInformation = coffeeInfromation
              .replaceAll(
                  RegExp(r"{|}"
                      "|coffeeCupSize: "
                      "|coffeeFinishTimeEstimation: "
                      "|coffeeName: "
                      "|coffeeOrderTime: "
                      "|coffeePrice: "
                      "|coffeeStatus: "
                      "|communication: "
                      "|customerName: "
                      "|hasCream: "
                      "|numberOfIceCubes: "
                      "|numberOfSugarCubes: "
                      "|quantity: "
                      "|recipeType: "),
                  "")
              .trim();
          this._orderList = parsedCoffeeInformation.split(",");
          return displayContentCards(
              OrderInformation(
                coffeeName: this._orderList[0],
                quantity: int.tryParse(this._orderList[1]),
                recipeType: this._orderList[2],
                coffeeEstimationTime: this._orderList[3],
                coffeePrice: this._orderList[4],
                customerName: this._orderList[5],
                hasCream: this._orderList[6] == "true" ? true : false,
                numberOfIceCubes: int.tryParse(this._orderList[7]),
                coffeeCupSize: this._orderList[8],
                numberOfSugarCubes: int.tryParse(this._orderList[9]),
                coffeeStatus: int.tryParse(this._orderList[10]),
                communication: this._orderList[11],
                coffeeOrderTime: this._orderList[12],
              ),
              cardFlipParams: [_flipCard, _isCardFlipped, index]);
        },
      ),
    );
  }
}

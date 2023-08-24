import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/services/updateProviderService.dart'
    show UpdateProvider;
import 'package:provider/provider.dart';
import 'package:coffee_orderer/utils/labelConversionHandler.dart' show classes;
import 'package:coffee_orderer/enums/coffeeTypes.dart' show CoffeeType;
import 'package:coffee_orderer/components/orderScreen/frontOfCard.dart'
    show buildFrontCardContent;
import 'package:coffee_orderer/components/orderScreen/backOfCard.dart'
    show buildBackCardContent;
import 'package:coffee_orderer/utils/coffeeNameToClassConvertor.dart'
    show coffeeNameToClassKey;

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
    final reference = FirebaseDatabase.instance.ref().child("Orders");
    return Consumer<UpdateProvider>(
      builder:
          (BuildContext context, UpdateProvider updateProvider, Widget child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "            Orders",
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
                      RegExp(
                          "{|}|coffeeCupSize: |coffeeFinishTimeEstimation: |coffeeName: |coffeeOrderTime: |coffeePrice: |coffeeStatus: |coffeeTemperature: |communication: |hasCream: |numberOfIceCubes: |numberOfSugarCubes: |quantity: "),
                      "")
                  .trim();
              this._orderList = parsedCoffeeInformation.split(",");
              this._orderList[2] =
                  coffeeNameToClassKey(this._orderList[2]).toLowerCase();
              CoffeeType coffeeType = CoffeeType.values.firstWhere(
                  (CoffeeType type) =>
                      type.index == classes[this._orderList[2]],
                  orElse: () => null);
              this._orderList[2] = this._orderList[2][0].toUpperCase() +
                  this._orderList[2].substring(1);
              return GestureDetector(
                onTap: () {
                  _flipCard(index);
                },
                child: Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.brown.shade400,
                    ),
                    child: _isCardFlipped(index)
                        ? buildBackCardContent()
                        : buildFrontCardContent(this._orderList, coffeeType)),
              );
            },
          ),
        );
      },
    );
  }
}

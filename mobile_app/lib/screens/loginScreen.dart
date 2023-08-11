import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/services/updateProviderService.dart'
    show UpdateProvider;
import 'package:provider/provider.dart';
import 'package:coffee_orderer/utils/labelConversionHandler.dart' show classes;
import 'package:coffee_orderer/utils/cardProperties.dart' show coffeeImagePaths;
import 'package:coffee_orderer/enums/coffeeTypes.dart' show CoffeeType;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> _orderList;
  var g;
  var k;

  _HomeState() {
    this._orderList = null;
  }

  @override
  Widget build(BuildContext context) {
    final reference = FirebaseDatabase.instance.ref().child('Orders');
    return Consumer<UpdateProvider>(
      builder:
          (BuildContext context, UpdateProvider updateProvider, Widget child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              '                   Orders',
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
              String v = snapshot.value.toString();
              g = v.replaceAll(
                  RegExp(
                      "{|}|coffeeFinishTimeEstimation: |coffeeName: |coffeeOrderTime: |coffeePrice: |coffeeStatus: |communication: |quantity: "),
                  "");
              g.trim();
              this._orderList = g.split(',');
              CoffeeType coffeeType = CoffeeType.values.firstWhere(
                  (CoffeeType type) =>
                      type.index == classes[this._orderList[0].toLowerCase()],
                  orElse: () => null);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    k = snapshot.key;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.brown.shade400,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40),
                          image: DecorationImage(
                            image: AssetImage(coffeeImagePaths[coffeeType]),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${this._orderList[0]}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Quantity: ${this._orderList[1]}\nEstimated Order: ${this._orderList[2]}\nCoffee Status: ${this._orderList[3]}\nPrice: ${this._orderList[5]}\nOrder Placed: ${this._orderList[6]}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

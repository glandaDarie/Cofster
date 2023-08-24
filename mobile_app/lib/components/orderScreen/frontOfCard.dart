import 'package:flutter/material.dart';
import 'package:coffee_orderer/utils/cardProperties.dart' show coffeeImagePaths;
import 'package:coffee_orderer/enums/coffeeTypes.dart' show CoffeeType;

Row buildFrontCardContent(List<dynamic> orderList, CoffeeType coffeeType) {
  return Row(
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
              "${orderList[2]}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Price: ${orderList[10]}\nQuantity: ${orderList[3]}\nSize: ${orderList[5]}\nCoffee Status: ${orderList[8]}\nOrder Placed: ${orderList[11]}\nEstimated Order: ${orderList[6]}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

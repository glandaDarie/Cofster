import 'package:flutter/material.dart';
import 'package:coffee_orderer/utils/cardProperties.dart' show coffeeImagePaths;
import 'package:coffee_orderer/enums/coffeeTypes.dart' show CoffeeType;

Row buildFrontCardContent(dynamic orderInformation, CoffeeType coffeeType,
    Text Function(dynamic) callbackDisplayText) {
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
      const SizedBox(width: 16),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${orderInformation.coffeeName}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            callbackDisplayText(orderInformation),
          ],
        ),
      ),
    ],
  );
}

Text displayText(Map<String, String> content) {
  return Text(
    content.entries.map((entry) => "${entry.key}: ${entry.value}").join('\n'),
    style: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
  );
}

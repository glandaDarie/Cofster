// import 'package:coffee_orderer/models/orderInformation.dart';
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
            // Text(
            //   "Price: ${orderInformation.coffeePrice}\n"
            //   "Quantity: ${orderInformation.quantity}\n"
            //   "Size: ${orderInformation.coffeeCupSize}\n"
            //   "Coffee Status: ${CoffeeOrderState.values[orderInformation.coffeeStatus].toString().split('.').last.split('_').join(' ')}\n"
            //   "Order Placed: ${orderInformation.coffeeOrderTime}\n"
            //   "Estimated Order: ${orderInformation.coffeeEstimationTime}",
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 16,
            //   ),
            // ),
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

// Row buildFrontCardContent(List<dynamic> orderList, CoffeeType coffeeType) {
//   return Row(
//     children: [
//       Container(
//         width: 80,
//         height: 80,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(40),
//           image: DecorationImage(
//             image: AssetImage(coffeeImagePaths[coffeeType]),
//             fit: BoxFit.contain,
//           ),
//         ),
//       ),
//       const SizedBox(width: 16),
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "${orderList[2]}",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Price: ${orderList[10]}\n"
//               "Quantity: ${orderList[3]}\n"
//               "Size: ${orderList[5]}\n"
//               "Coffee Status: ${CoffeeOrderState.values[int.parse(orderList[8])].toString().split('.').last.split('_').join(' ')}\n"
//               "Order Placed: ${orderList[11]}\n"
//               "Estimated Order: ${orderList[6]}",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }

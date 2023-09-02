import 'package:coffee_orderer/models/orderInformation.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/utils/cardProperties.dart' show coffeeImagePaths;
import 'package:coffee_orderer/enums/coffeeTypes.dart' show CoffeeType;

Row buildBackCardContent(
    OrderInformation orderInformation, CoffeeType coffeeType) {
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
              "${orderInformation.coffeeName}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Additional information",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "     Temperature: ${orderInformation.coffeeTemperature}\n"
              "     Cream: ${orderInformation.hasCream ? 'Yes' : 'No'}\n"
              "     Sugar cubes: ${orderInformation.numberOfSugarCubes}\n"
              "     Ice cubes: ${orderInformation.numberOfIceCubes}",
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

// Row buildBackCardContent(List<dynamic> orderList, CoffeeType coffeeType) {
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
//       SizedBox(width: 16),
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
//             SizedBox(height: 15),
//             Text(
//               "Additional information",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontStyle: FontStyle.italic,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               "     Temperature: ${orderList[0]}\n"
//               "     Cream: ${orderList[1].trim() == 'true' ? 'Yes' : 'No'}\n"
//               "     Sugar cubes: ${orderList[7]}\n"
//               "     Ice cubes: ${orderList[4]}",
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

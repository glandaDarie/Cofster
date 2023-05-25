import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/detailsScreen/boxSizes.dart'
    show boxSizes;
import 'package:coffee_orderer/components/detailsScreen/boxQuantity.dart'
    show boxQuantity;
import 'package:coffee_orderer/components/detailsScreen/boxTemperature.dart'
    show boxTemperature;
import 'package:coffee_orderer/components/detailsScreen/boxExtraIngredient.dart'
    show ExtraIngredientWidget, ExtraIngredientWidgetBinary;

SizedBox customizeDrink(BuildContext context) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.72,
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.cancel_sharp,
                      size: 40,
                    ))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                boxTemperature(),
                boxQuantity(),
              ],
            ),
          ),
          const SizedBox(height: 5.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, thickness: 0.3, color: Colors.black38),
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: boxSizes(),
          ),
          const SizedBox(height: 5.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, thickness: 0.3, color: Colors.black38),
          ),
          const SizedBox(height: 5.0),
          Column(
            children: [
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ExtraIngredientWidget(
                  "Sugar",
                  "cubes",
                  AssetImage("assets/images/sugar.png").assetName,
                ),
              ),
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ExtraIngredientWidget(
                  "Ice",
                  "cubes",
                  AssetImage("assets/images/ice.png").assetName,
                ),
              ),
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ExtraIngredientWidgetBinary(
                  "Cream",
                  AssetImage("assets/images/cream.png").assetName,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Divider(height: 1, thickness: 0.3, color: Colors.black38),
          ),
          const SizedBox(height: 5.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            margin: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total",
                      style: const TextStyle(
                              fontFamily: 'varela', color: Color(0xFF473D3A))
                          .copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.brown.shade500),
                      textScaleFactor: 1.6,
                    ),
                    Text(
                      "\$9.50",
                      style: TextStyle(
                              fontFamily: 'varela', color: Color(0xFF473D3A))
                          .copyWith(fontWeight: FontWeight.w900),
                      textScaleFactor: 1.9,
                    ),
                  ],
                ),
                SizedBox(
                  height: 60,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF473D3A)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                    child: Text(
                      "Add to Orders",
                      textScaleFactor: 1.5,
                      style:
                          TextStyle(fontFamily: 'varela', color: Colors.white)
                              .copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:coffee_orderer/models/card.dart' show CoffeeCard;

Padding coffeeCardFavouriteDrink(CoffeeCard card) {
  return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Container(
        height: 100.0,
        width: 225.0,
        child: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(height: 295.0),
                Positioned(
                  top: 75.0,
                  child: Container(
                    padding: EdgeInsets.only(left: 10.0, right: 20.0),
                    height: 200.0,
                    width: 225.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(75.0),
                      color: Color(0xFF473D3A),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 48.0),
                        Center(
                          child: Text(
                            card.shopName + "\'s",
                            style: TextStyle(
                              fontFamily: "nunito",
                              fontSize: 8.0,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Center(
                          child: Text(
                            card.coffeeName,
                            style: TextStyle(
                              fontFamily: "varela",
                              fontSize: 34.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Center(
                          child: Text(
                            card.price,
                            style: TextStyle(
                              fontFamily: "varela",
                              fontSize: 28.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 68.0,
                  top: 35.0,
                  child: Container(
                    height: 85.0,
                    width: 85.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(card.imgPath), fit: BoxFit.contain),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ));
}

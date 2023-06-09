import 'package:coffee_orderer/patterns/CoffeeCardSingleton.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/screens/detailsScreen.dart';
import 'package:coffee_orderer/models/card.dart' show CoffeeCard;
import 'package:coffee_orderer/controllers/CoffeeCardController.dart'
    show CoffeeCardController;
import 'package:coffee_orderer/utils/localUserInformation.dart';
import 'package:fluttertoast/fluttertoast.dart';

Padding coffeeCard(CoffeeCard card,
    [void Function(CoffeeCard, ValueNotifier<bool>) callbackSetFavorite,
    List<CoffeeCard> Function() callbackCoffeCards]) {
  return Padding(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Container(
          height: 300.0,
          width: 225.0,
          child: Column(
            children: <Widget>[
              Stack(children: [
                Container(height: 335.0),
                Positioned(
                    top: 75.0,
                    child: Container(
                        padding: EdgeInsets.only(left: 10.0, right: 20.0),
                        height: 260.0,
                        width: 225.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Color(0xFFDAB68C)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 60.0,
                              ),
                              Center(
                                child: Text(
                                  card.shopName + "\'s",
                                  style: TextStyle(
                                      fontFamily: "nunito",
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(height: 3.0),
                              Center(
                                  child: Text(
                                card.coffeeName,
                                style: TextStyle(
                                    fontFamily: "varela",
                                    fontSize: 32.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                              SizedBox(height: 10.0),
                              Text(
                                card.description,
                                style: TextStyle(
                                    fontFamily: "nunito",
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 10.0),
                              InkWell(
                                onTap: () {
                                  CoffeeCardSingleton coffeeCardInstance =
                                      CoffeeCardSingleton(card.context);
                                  List<CoffeeCard> coffeeCardObjects =
                                      coffeeCardInstance.getCoffeeCardObjects();
                                  for (CoffeeCard coffeeCardObject
                                      in coffeeCardObjects) {
                                    if (coffeeCardObject.coffeeName ==
                                        card.coffeeName) {
                                      callbackSetFavorite(coffeeCardObject,
                                          card.isFavoriteNotifier);
                                    }
                                  }
                                },
                                child: _hearIcon(card),
                              ),
                            ]))),
                Positioned(
                    left: 60.0,
                    top: 25.0,
                    child: Container(
                        height: 100.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(card.imgPath),
                                fit: BoxFit.contain))))
              ]),
              SizedBox(height: 20.0),
              InkWell(
                  onTap: () async {
                    bool cardIsFavorite = CoffeeCardController
                        .getParticularCoffeeCardIsFavoriteState(card);
                    if (cardIsFavorite == null) {
                      Fluttertoast.showToast(
                          msg: "That respective coffee does not exist",
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Color.fromARGB(255, 102, 33, 12),
                          textColor: Color.fromARGB(255, 220, 217, 216),
                          fontSize: 16);
                      return;
                    }
                    storeUserInformationInCache({
                      "cardCoffeeName": card.coffeeName.replaceAll(" ", "-"),
                      "cardImgPath": card.imgPath,
                      "cardDescription": card.description.replaceAll(" ", "-"),
                      "cardIsFavorite": cardIsFavorite.toString()
                    });
                    Navigator.of(card.context).push(
                        MaterialPageRoute(builder: (context) => DetailsPage()));
                  },
                  child: Container(
                      height: 50.0,
                      width: 225.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          color: Color(0xFF473D3A)),
                      child: Center(
                          child: Text("Order Now",
                              style: TextStyle(
                                  fontFamily: "nunito",
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)))))
            ],
          )));
}

Row _hearIcon(CoffeeCard card) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(
        card.price,
        style: TextStyle(
          fontFamily: "varela",
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          color: Color(0xFF473D3A),
        ),
      ),
      Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
        ),
        child: ValueListenableBuilder<bool>(
          valueListenable: card.isFavoriteNotifier,
          builder: (context, isFavorite, child) {
            return Center(
              child: Icon(
                Icons.favorite,
                color: isFavorite ? Colors.red : Colors.grey,
                size: 15.0,
              ),
            );
          },
        ),
      ),
    ],
  );
}

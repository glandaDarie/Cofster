import 'package:coffee_orderer/controllers/DrinksInformationController.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/utils/localUserInformation.dart';
import 'package:coffee_orderer/components/detailsScreen/drinkCustomSelector.dart'
    show customizeDrink;
import '../components/detailsScreen/ratingBar.dart';
import 'package:coffee_orderer/models/information.dart';
import 'package:coffee_orderer/controllers/IngredientController.dart'
    show IngredientController;
import 'package:coffee_orderer/controllers/RatingController.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool hotSelected;
  ValueNotifier<bool> hotSelectedNotifier;
  ValueNotifier<bool> placedOrderNotifier;
  ValueNotifier<double> ratingBarNotifier;
  DrinksInformationController drinkInformationController;
  IngredientController ingredientsController;
  RatingController ratingController;
  List<String> _ingredients;
  String _preparationTime;
  List<String> _nutritionInfo;

  _DetailsPageState() {
    this.hotSelectedNotifier = ValueNotifier<bool>(false);
    this.placedOrderNotifier = ValueNotifier<bool>(false);
    this.ratingBarNotifier = ValueNotifier<double>(0.0);
    this.drinkInformationController = DrinksInformationController();
    this.ingredientsController = IngredientController();
    this.ratingController = RatingController();
    this._ingredients = [];
    this._preparationTime = null;
    this._nutritionInfo = [];
  }

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> _getCoffeeCardInformationFromPreviousScreen(
      String key) async {
    String cacheStr = await loadUserInformationFromCache();
    String value = fromStringCachetoMapCache(cacheStr)[key];
    if (key == "cardCoffeeName" || key == "cardDescription") {
      value = value.replaceAll("-", " ");
    }
    if (key == "cardImgPath") {
      return AssetImage(value);
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<dynamic>(
      future: _getCoffeeCardInformationFromPreviousScreen("cardCoffeeName"),
      builder: (BuildContext context,
          AsyncSnapshot<dynamic> snapshotPreviousScreenData) {
        if (snapshotPreviousScreenData.connectionState ==
            ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
                color: Colors.brown, backgroundColor: Colors.white),
          );
        } else if (snapshotPreviousScreenData.hasError) {
          return Center(
            child: Text(
                "Error (snapshotPreviousScreenData): ${snapshotPreviousScreenData.error}"),
          );
        } else if (snapshotPreviousScreenData.hasData) {
          dynamic coffeeName =
              snapshotPreviousScreenData.data.replaceAll(" ", "");
          return FutureBuilder<Information>(
              future: this
                  .drinkInformationController
                  .getInformationFromRespectiveDrink(coffeeName),
              builder: (BuildContext context,
                  AsyncSnapshot<Information> snapshotInformationDrink) {
                if (snapshotInformationDrink.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                        color: Colors.brown, backgroundColor: Colors.white),
                  );
                } else if (snapshotInformationDrink.hasError) {
                  return Center(
                    child: Text(
                        "Error (snapshotInformationDrink): ${snapshotInformationDrink.error}"),
                  );
                } else if (snapshotInformationDrink.hasData) {
                  this._ingredients = snapshotInformationDrink.data.ingredients;
                  this._preparationTime =
                      snapshotInformationDrink.data.preparationTime;
                  this._nutritionInfo =
                      snapshotInformationDrink.data.nutritionInformation;
                  return Scaffold(
                      body: ListView(children: [
                    Stack(
                      children: <Widget>[
                        Container(
                            height: MediaQuery.of(context).size.height - 20.0,
                            width: MediaQuery.of(context).size.width,
                            color: Color(0xFFDAB68C)),
                        Positioned(
                            top: MediaQuery.of(context).size.height / 2,
                            child: Container(
                                height: MediaQuery.of(context).size.height / 2 -
                                    20.0,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(40.0),
                                        topLeft: Radius.circular(40.0)),
                                    color: Colors.white))),
                        Positioned(
                            top: MediaQuery.of(context).size.height / 2 + 25.0,
                            left: 15.0,
                            child: Container(
                                height:
                                    (MediaQuery.of(context).size.height / 2) -
                                        50.0,
                                width: MediaQuery.of(context).size.width,
                                child: ListView(children: [
                                  Text(
                                    "Preparation time",
                                    style: TextStyle(
                                        fontFamily: "nunito",
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF726B68)),
                                  ),
                                  SizedBox(height: 7.0),
                                  Text(
                                    "${this._preparationTime}",
                                    style: TextStyle(
                                        fontFamily: "nunito",
                                        fontSize: 14.0,
                                        color: Color(0xFFC6C4C4)),
                                  ),
                                  SizedBox(height: 10.0),
                                  ValueListenableBuilder(
                                      valueListenable: this.placedOrderNotifier,
                                      builder: (BuildContext context,
                                          bool placedOrder, Widget child) {
                                        Future.delayed(
                                            Duration(seconds: 30), () {});
                                        return Visibility(
                                            visible: placedOrder,
                                            child: Positioned(
                                                bottom: 25,
                                                right: 70,
                                                child: RatingBarDrink.ratingBar(
                                                    ratingBarNotifier,
                                                    placedOrderNotifier)));
                                      }),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 35.0),
                                    child: Container(
                                      height: 0.5,
                                      color: Color(0xFFC6C4C4),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    "Ingredients",
                                    style: TextStyle(
                                        fontFamily: "nunito",
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF726B68)),
                                  ),
                                  SizedBox(height: 20.0),
                                  Container(
                                      height: 110.0,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: this
                                            .ingredientsController
                                            .filterIngredientsGivenSelectedDrink(
                                                this._ingredients),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 35.0),
                                    child: Container(
                                      height: 0.5,
                                      color: Color(0xFFC6C4C4),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    "Nutrition Information",
                                    style: TextStyle(
                                        fontFamily: "nunito",
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF726B68)),
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(children: [
                                    Text(
                                      "Calories",
                                      style: TextStyle(
                                          fontFamily: "nunito",
                                          fontSize: 14.0,
                                          color: Color(0xFFD4D3D2)),
                                    ),
                                    SizedBox(width: 15.0),
                                    Text(
                                      this._nutritionInfo[1],
                                      style: TextStyle(
                                          fontFamily: "nunito",
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF716966)),
                                    ),
                                  ]),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Proteins",
                                        style: TextStyle(
                                            fontFamily: "nunito",
                                            fontSize: 14.0,
                                            color: Color(0xFFD4D3D2)),
                                      ),
                                      SizedBox(width: 15.0),
                                      Text(
                                        this._nutritionInfo[0],
                                        style: TextStyle(
                                            fontFamily: "nunito",
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF716966)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        "Caffeine",
                                        style: TextStyle(
                                            fontFamily: "nunito",
                                            fontSize: 14.0,
                                            color: Color(0xFFD4D3D2)),
                                      ),
                                      SizedBox(width: 15.0),
                                      Text(
                                        this._nutritionInfo[2],
                                        style: TextStyle(
                                            fontFamily: "nunito",
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF716966)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15.0),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 35.0),
                                    child: Container(
                                      height: 0.5,
                                      color: Color(0xFFC6C4C4),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Padding(
                                    padding: EdgeInsets.only(right: 25.0),
                                    child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            backgroundColor: Colors.white,
                                            isDismissible: true,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                top: Radius.circular(25),
                                              ),
                                            ),
                                            context: context,
                                            builder: (BuildContext context) {
                                              return customizeDrink(context,
                                                  this.placedOrderNotifier);
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 50.0,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(35.0),
                                              color: Color(0xFF473D3A)),
                                          child: Center(
                                            child: Text(
                                              "Create coffee drink",
                                              style: TextStyle(
                                                  fontFamily: "nunito",
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )),
                                  ),
                                  SizedBox(height: 20.0)
                                ]))),
                        Positioned(
                          top: MediaQuery.of(context).size.height / 8,
                          left: 135.0,
                          child: FutureBuilder<dynamic>(
                            future: _getCoffeeCardInformationFromPreviousScreen(
                                "cardImgPath"),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text("Error loading image");
                              } else {
                                return Container(
                                  height: 310.0,
                                  width: 310.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: snapshot.data,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Positioned(
                            top: 30.0,
                            left: 10.0,
                            child: Container(
                                height: 300.0,
                                width: 250.0,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          Container(
                                            width: 150.0,
                                            child: FutureBuilder<dynamic>(
                                              future:
                                                  _getCoffeeCardInformationFromPreviousScreen(
                                                      "cardCoffeeName"),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return CircularProgressIndicator();
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      "Error: ${snapshot.error}");
                                                } else {
                                                  return Text(
                                                    snapshot.data ?? "",
                                                    style: TextStyle(
                                                      fontFamily: "varela",
                                                      fontSize: 30.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 15.0),
                                          FutureBuilder<dynamic>(
                                            future:
                                                _getCoffeeCardInformationFromPreviousScreen(
                                                    "cardIsFavorite"),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<dynamic>
                                                    snapshot) {
                                              Color containerColor =
                                                  snapshot.data == "false"
                                                      ? Colors.grey
                                                      : Colors.red;
                                              return Container(
                                                height: 40.0,
                                                width: 40.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  color: Colors.white,
                                                ),
                                                child: Center(
                                                  child: Icon(Icons.favorite,
                                                      size: 18.0,
                                                      color: containerColor),
                                                ),
                                              );
                                            },
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 10.0),
                                      Container(
                                        width: 170.0,
                                        child: FutureBuilder<dynamic>(
                                          future:
                                              _getCoffeeCardInformationFromPreviousScreen(
                                                  "cardDescription"),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  "Error: ${snapshot.error}");
                                            } else {
                                              return Text(
                                                snapshot.data ?? "",
                                                style: TextStyle(
                                                    fontFamily: "nunito",
                                                    fontSize: 13.0,
                                                    color: Colors.white),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 20.0),
                                      Row(children: [
                                        Container(
                                            height: 60.0,
                                            width: 60.0,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                color: Color(0xFF473D3A)),
                                            child: FutureBuilder<String>(
                                              future: this
                                                  .ratingController
                                                  .getDrinkRating(coffeeName),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<String>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            color: Colors.brown,
                                                            backgroundColor:
                                                                Colors.white),
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                    "Error: ${snapshot.error}",
                                                    style: TextStyle(
                                                      fontFamily: "nunito",
                                                      fontSize: 13.0,
                                                      color: Colors.white,
                                                    ),
                                                  );
                                                } else {
                                                  String rating =
                                                      snapshot.data ?? "0.0";
                                                  return Center(
                                                      child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        "${rating}",
                                                        style: TextStyle(
                                                          fontFamily: "nunito",
                                                          fontSize: 13.0,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Text("/5",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'nunito',
                                                            fontSize: 13.0,
                                                            color: Color(
                                                                0xFF7C7573),
                                                          ))
                                                    ],
                                                  ));
                                                }
                                              },
                                            )),
                                        SizedBox(width: 15.0),
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Stack(children: [
                                                Container(
                                                    height: 35.0, width: 80.0),
                                                Positioned(
                                                    left: 40.0,
                                                    child: Container(
                                                        height: 35.0,
                                                        width: 35.0,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        17.5),
                                                            border: Border.all(
                                                                color: Color(
                                                                    0xFFCEC7C4),
                                                                style: BorderStyle
                                                                    .solid,
                                                                width: 1.0),
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    "assets/images/man.jpg"),
                                                                fit: BoxFit
                                                                    .cover)))),
                                                Positioned(
                                                  left: 20.0,
                                                  child: Container(
                                                    height: 35.0,
                                                    width: 35.0,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(17.5),
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                "assets/images/model.jpg"),
                                                            fit: BoxFit.cover),
                                                        border: Border.all(
                                                            color: Color(
                                                                0xFFCEC7C4),
                                                            style: BorderStyle
                                                                .solid,
                                                            width: 1.0)),
                                                  ),
                                                ),
                                                Container(
                                                  height: 35.0,
                                                  width: 35.0,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              17.5),
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/coffee_americano.png"),
                                                          fit: BoxFit.cover),
                                                      border: Border.all(
                                                          color:
                                                              Color(0xFFCEC7C4),
                                                          style:
                                                              BorderStyle.solid,
                                                          width: 1.0)),
                                                ),
                                              ]),
                                              SizedBox(height: 3.0),
                                              Text(
                                                "+ 27 more",
                                                style: TextStyle(
                                                    fontFamily: "nunito",
                                                    fontSize: 12.0,
                                                    color: Colors.white),
                                              )
                                            ])
                                      ])
                                    ])))
                      ],
                    )
                  ]));
                } else {
                  return Center(
                    child: Text("No data available"),
                  );
                }
              });
        } else {
          return Center(
            child: Text("No data available"),
          );
        }
      },
    ));
  }
}

import 'dart:typed_data';
import 'package:coffee_orderer/controllers/UserController.dart';
import 'package:coffee_orderer/controllers/AuthController.dart';
import 'package:coffee_orderer/controllers/QuestionnaireController.dart';
import 'package:flutter/material.dart';
import '../utils/coffeeFunFact.dart';
import 'package:coffee_orderer/components/mainScreen/navigationBar.dart';
import 'package:coffee_orderer/components/mainScreen/popupFreeDrink.dart'
    show showPopup;
import 'package:coffee_orderer/components/mainScreen/coffeeCard.dart'
    show coffeeCard;
import 'package:coffee_orderer/utils/cardProperties.dart'
    show coffeeImagePaths, coffeeNames, coffeeDescription, coffeePrices;
import 'package:coffee_orderer/enums/coffeeTypes.dart' show CoffeeType;
import 'package:coffee_orderer/controllers/CoffeeCardFavouriteDrinksController.dart';
import 'package:coffee_orderer/models/card.dart' show CoffeeCard;
import 'package:coffee_orderer/services/notificationService.dart'
    show NotificationService;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserController userController;
  AuthController authController;
  QuestionnaireController questionnaireController;
  CoffeeCardFavouriteDrinksController coffeeCardController;
  NotificationService notificationService;
  List<String> _favouriteDrinks;
  int _navBarItemSelected;

  _HomePageState() {
    this.userController = UserController();
    this.authController = AuthController();
    this.questionnaireController = QuestionnaireController();
    this.coffeeCardController = CoffeeCardFavouriteDrinksController();
    this._favouriteDrinks = [];
    this._navBarItemSelected = 0;
  }

  @override
  void initState() {
    super.initState();
    // this.authController.loadUserPhoto();
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      this
          .questionnaireController
          .loadFavouriteDrinks()
          .then((List<String> favouriteDrinks) {
        setState(() {
          this._favouriteDrinks = List.from(favouriteDrinks);
          String favouriteDrink = this._favouriteDrinks.first;
          showPopup(context, favouriteDrink);
          NotificationService().showNotification(
              title: "New user reward",
              body:
                  "You won a free ${favouriteDrink.toLowerCase()} coffee. Enjoy!");
        });
      });
    });
  }

  callbackSetFavouriteDrinks(List<String> favouriteDrinks) {
    this._favouriteDrinks = List.from(favouriteDrinks);
  }

  callbackNavBar(int newNavBarItemSelected) {
    setState(() => this._navBarItemSelected = newNavBarItemSelected);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: this.questionnaireController.loadFavouriteDrinks(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
                  color: Colors.brown, backgroundColor: Colors.white));
        } else if (snapshot.hasError) {
          return Text("Error occured ${snapshot.error}");
        } else {
          this._favouriteDrinks = List.from(snapshot.data);
          return Scaffold(
            body: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.only(left: 10.0, top: 20.0),
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 50.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FutureBuilder<String>(
                          future: this.authController.loadName(),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                "Hello, ${snapshot.data}",
                                style: TextStyle(
                                    fontFamily: "Baskerville",
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..shader = LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 167, 155, 143),
                                          Color.fromARGB(255, 95, 76, 51),
                                          Color.fromARGB(255, 71, 54, 32)
                                        ],
                                      ).createShader(
                                          Rect.fromLTWH(0, 0, 100, 100))),
                              );
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 13.0),
                          child: FutureBuilder<Uint8List>(
                            future: this.authController.loadUserPhoto(),
                            builder: (BuildContext context,
                                AsyncSnapshot<Uint8List> snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  height: 60.0,
                                  width: 60.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    image: DecorationImage(
                                      image: MemoryImage(snapshot.data),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(right: 40.0),
                      child: Container(
                        child: FutureBuilder<String>(
                          future: generateFunFact(),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                "Fun fact: ${snapshot.data}.",
                                style: TextStyle(
                                  fontFamily: "nunito",
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0xFFB0AAA7),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 25.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Drinks made for you",
                          style: TextStyle(
                            fontFamily: "varela",
                            fontSize: 17.0,
                            color: Color(0xFF473D3A),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text(
                            "Drag to see all",
                            style: TextStyle(
                              fontFamily: "varela",
                              fontSize: 15.0,
                              color: Color(0xFFCEC7C4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      height: 310.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: this
                            .coffeeCardController
                            .filteredCoffeeCardsWithFavouriteDrinksFromClassifier(
                                this._favouriteDrinks),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Drinks available",
                          style: TextStyle(
                            fontFamily: "varela",
                            fontSize: 17.0,
                            color: Color(0xFF473D3A),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text(
                            "Drag to see all",
                            style: TextStyle(
                              fontFamily: "varela",
                              fontSize: 15.0,
                              color: Color(0xFFCEC7C4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      height: 410.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _coffeeCardList(),
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Explore nearby",
                          style: TextStyle(
                            fontFamily: "varela",
                            fontSize: 17.0,
                            color: Color(0xFF473D3A),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: Text(
                            "Drag to see all",
                            style: TextStyle(
                              fontFamily: "varela",
                              fontSize: 15.0,
                              color: Color(0xFFCEC7C4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      height: 125.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildImage("assets/images/coffee.jpg"),
                          _buildImage("assets/images/coffee2.jpg"),
                          _buildImage("assets/images/coffee3.jpg"),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.0),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child:
                      bottomNavigationBar(_navBarItemSelected, callbackNavBar),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Padding _buildImage(String imgPath) {
    return Padding(
        padding: EdgeInsets.only(right: 15.0),
        child: Container(
            height: 100.0,
            width: 175.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                    image: AssetImage(imgPath), fit: BoxFit.cover))));
  }

  List<Padding> _coffeeCardList() {
    return [
      coffeeCard(
        CoffeeCard(
            coffeeImagePaths[CoffeeType.cortado],
            coffeeNames[CoffeeType.cortado],
            "Cofster",
            coffeePrices[CoffeeType.cortado],
            coffeeDescription[CoffeeType.cortado],
            false,
            context),
      ),
      coffeeCard(
        CoffeeCard(
            coffeeImagePaths[CoffeeType.americano],
            coffeeNames[CoffeeType.americano],
            "Cofster",
            coffeePrices[CoffeeType.americano],
            coffeeDescription[CoffeeType.americano],
            false,
            context),
      ),
      coffeeCard(
        CoffeeCard(
            coffeeImagePaths[CoffeeType.cappuccino],
            coffeeNames[CoffeeType.cappuccino],
            "Cofster",
            coffeePrices[CoffeeType.cappuccino],
            coffeeDescription[CoffeeType.cappuccino],
            true,
            context),
      ),
      coffeeCard(
        CoffeeCard(
            coffeeImagePaths[CoffeeType.latteMachiatto],
            coffeeNames[CoffeeType.latteMachiatto],
            "Cofster",
            coffeePrices[CoffeeType.latteMachiatto],
            coffeeDescription[CoffeeType.latteMachiatto],
            true,
            context),
      ),
      coffeeCard(
        CoffeeCard(
            coffeeImagePaths[CoffeeType.flatWhite],
            coffeeNames[CoffeeType.flatWhite],
            "Cofster",
            coffeePrices[CoffeeType.flatWhite],
            coffeeDescription[CoffeeType.flatWhite],
            false,
            context),
      ),
      coffeeCard(
        CoffeeCard(
            coffeeImagePaths[CoffeeType.coldEspresso],
            coffeeNames[CoffeeType.coldEspresso],
            "Cofster",
            coffeePrices[CoffeeType.coldEspresso],
            coffeeDescription[CoffeeType.coldEspresso],
            false,
            context),
      ),
      coffeeCard(
        CoffeeCard(
            coffeeImagePaths[CoffeeType.mocha],
            coffeeNames[CoffeeType.mocha],
            "Cofster",
            coffeePrices[CoffeeType.mocha],
            coffeeDescription[CoffeeType.mocha],
            false,
            context),
      ),
      coffeeCard(
        CoffeeCard(
            coffeeImagePaths[CoffeeType.coldBrew],
            coffeeNames[CoffeeType.coldBrew],
            "Cofster",
            coffeePrices[CoffeeType.coldBrew],
            coffeeDescription[CoffeeType.coldBrew],
            false,
            context),
      ),
      coffeeCard(
        CoffeeCard(
            coffeeImagePaths[CoffeeType.coretto],
            coffeeNames[CoffeeType.coretto],
            "Cofster",
            coffeePrices[CoffeeType.coretto],
            coffeeDescription[CoffeeType.coretto],
            false,
            context),
      ),
      coffeeCard(
        CoffeeCard(
            coffeeImagePaths[CoffeeType.irishCoffee],
            coffeeNames[CoffeeType.irishCoffee],
            "Cofster",
            coffeePrices[CoffeeType.irishCoffee],
            coffeeDescription[CoffeeType.irishCoffee],
            false,
            context),
      ),
    ];
  }
}

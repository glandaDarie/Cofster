import 'dart:typed_data';
import 'package:coffee_orderer/controllers/UserController.dart';
import 'package:coffee_orderer/screens/detailsScreen.dart';
import 'package:coffee_orderer/controllers/AuthController.dart';
import 'package:coffee_orderer/controllers/QuestionnaireController.dart';
import 'package:flutter/material.dart';
import '../utils/coffeeFunFact.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String photo = null;
  UserController userController;
  AuthController authController;
  QuestionnaireController questionnaireController;
  List<String> _favouriteDrinks;

  _HomePageState() {
    this.userController = UserController();
    this.authController = AuthController();
    this.questionnaireController = QuestionnaireController();
    _favouriteDrinks = [];
  }

  @override
  void initState() {
    super.initState();
    this.authController.loadUserPhoto();
  }

  Future<void> loadFavouriteDrinks() async {
    List<String> data =
        await ((await this.questionnaireController.drinksPresentInCache())
            ? this.questionnaireController.loadDrinksFromCache()
            : this.questionnaireController.loadDrinksFromDynamoDB());
    setState(() {
      _favouriteDrinks = data;
      print("Favourite drinks = ${_favouriteDrinks}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.only(left: 10.0, top: 20.0),
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 50.0)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FutureBuilder<String>(
              future: this.authController.loadName(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
                          ).createShader(Rect.fromLTWH(0, 0, 100, 100))),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error : ${snapshot.error}");
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            Padding(
              padding: EdgeInsets.only(right: 13.0),
              child: FutureBuilder<Uint8List>(
                future: this.authController.loadUserPhoto(),
                builder:
                    (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
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
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
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
              "Taste made for you",
              style: TextStyle(
                  fontFamily: "varela",
                  fontSize: 17.0,
                  color: Color(0xFF473D3A)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                "Drag to see all",
                style: TextStyle(
                    fontFamily: "varela",
                    fontSize: 15.0,
                    color: Color(0xFFCEC7C4)),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.0),
        Container(
            height: 410.0,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              _coffeeListCard(
                  'assets/images/starbucks.png',
                  'Cortado',
                  'Cofster',
                  'Our dark, rich espresso balanced with steamed milk and a light layer of foam',
                  '\$4.99',
                  false),
              _coffeeListCard(
                  'assets/images/starbucks.png',
                  'Americano',
                  'Cofster',
                  'Rich, full-bodied espresso with bittersweet milk sauce and steamed milk',
                  '\$3.99',
                  false),
              _coffeeListCard(
                  'assets/images/starbucks.png',
                  'Cappuccino',
                  'Cofster',
                  'Rich, full-bodied espresso with bittersweet milk sauce and steamed milk',
                  '\$3.99',
                  true),
              _coffeeListCard(
                  'assets/images/starbucks.png',
                  'Machiatto',
                  'Cofster',
                  'Rich, full-bodied espresso with bittersweet milk sauce and steamed milk',
                  '\$3.99',
                  true),
              _coffeeListCard(
                  'assets/images/starbucks.png',
                  'Flat white',
                  'Cofster',
                  'Rich, full-bodied espresso with bittersweet milk sauce and steamed milk',
                  '\$3.99',
                  false),
              _coffeeListCard(
                  'assets/images/starbucks.png',
                  'Espresso',
                  'Cofster',
                  'Rich, full-bodied espresso with bittersweet milk sauce and steamed milk',
                  '\$3.99',
                  false),
              _coffeeListCard(
                  'assets/images/starbucks.png',
                  'Mocha',
                  'Cofster',
                  'Rich, full-bodied espresso with bittersweet milk sauce and steamed milk',
                  '\$3.99',
                  false),
              _coffeeListCard(
                  'assets/images/starbucks.png',
                  'Cold brew',
                  'Cofster',
                  'Rich, full-bodied espresso with bittersweet milk sauce and steamed milk',
                  '\$3.99',
                  false),
              _coffeeListCard(
                  'assets/images/starbucks.png',
                  'Coretto',
                  'Cofster',
                  'Rich, full-bodied espresso with bittersweet milk sauce and steamed milk',
                  '\$3.99',
                  false),
              _coffeeListCard(
                  'assets/images/starbucks.png',
                  'Irish coffee',
                  'Cofster',
                  'Rich, full-bodied espresso with bittersweet milk sauce and steamed milk',
                  '\$3.99',
                  false),
            ])),
        SizedBox(height: 15.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Explore nearby',
              style: TextStyle(
                  fontFamily: 'varela',
                  fontSize: 17.0,
                  color: Color(0xFF473D3A)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Text(
                'Drag to see all',
                style: TextStyle(
                    fontFamily: 'varela',
                    fontSize: 15.0,
                    color: Color(0xFFCEC7C4)),
              ),
            ),
          ],
        ),
        SizedBox(height: 15.0),
        Container(
            height: 125.0,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              _buildImage('assets/images/coffee.jpg'),
              _buildImage('assets/images/coffee2.jpg'),
              _buildImage('assets/images/coffee3.jpg')
            ])),
        SizedBox(height: 20.0)
      ],
    ));
  }

  _buildImage(String imgPath) {
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

  _coffeeListCard(String imgPath, String coffeeName, String shopName,
      String description, String price, bool isFavorite) {
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
                                    shopName + '\'s',
                                    style: TextStyle(
                                        fontFamily: 'nunito',
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 3.0),
                                Center(
                                    child: Text(
                                  coffeeName,
                                  style: TextStyle(
                                      fontFamily: 'varela',
                                      fontSize: 32.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )),
                                SizedBox(height: 10.0),
                                Text(
                                  description,
                                  style: TextStyle(
                                      fontFamily: 'nunito',
                                      fontSize: 14.0,
                                      // fontWeight: FontWeight.w300,
                                      color: Colors.white),
                                ),
                                SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      price,
                                      style: TextStyle(
                                          fontFamily: 'varela',
                                          fontSize: 25.0,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF3A4742)),
                                    ),
                                    Container(
                                        height: 40.0,
                                        width: 40.0,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            color: Colors.white),
                                        child: Center(
                                            child: Icon(Icons.favorite,
                                                color: isFavorite
                                                    ? Colors.red
                                                    : Colors.grey,
                                                size: 15.0)))
                                  ],
                                )
                              ]))),
                  Positioned(
                      left: 60.0,
                      top: 25.0,
                      child: Container(
                          height: 100.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(imgPath),
                                  fit: BoxFit.contain))))
                ]),
                SizedBox(height: 20.0),
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailsPage()));
                    },
                    child: Container(
                        height: 50.0,
                        width: 225.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: Color(0xFF473D3A)),
                        child: Center(
                            child: Text('Order Now',
                                style: TextStyle(
                                    fontFamily: 'nunito',
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)))))
              ],
            )));
  }
}

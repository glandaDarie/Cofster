import 'dart:typed_data';
import 'package:coffee_orderer/controllers/UserController.dart';
import 'package:coffee_orderer/controllers/AuthController.dart';
import 'package:coffee_orderer/controllers/QuestionnaireController.dart';
import 'package:coffee_orderer/models/swiper.dart';
import 'package:flutter/material.dart';
import '../utils/coffeeFunFact.dart';
// import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:coffee_orderer/components/mainScreen/navigationBar.dart';
import 'package:coffee_orderer/components/mainScreen/popupFreeDrink.dart'
    show showNotification;
import 'package:coffee_orderer/components/mainScreen/coffeeCard.dart'
    show coffeeCard;
import 'package:coffee_orderer/utils/labelConversionHandler.dart' show classes;
import 'package:coffee_orderer/utils/imagePaths.dart' show coffeeTypeImagePaths;
import 'package:coffee_orderer/components/mainScreen/coffeeSwiper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserController userController;
  AuthController authController;
  QuestionnaireController questionnaireController;
  List<String> _favouriteDrinks;
  int _navBarItemSelected;

  _HomePageState() {
    this.userController = UserController();
    this.authController = AuthController();
    this.questionnaireController = QuestionnaireController();
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
          showNotification(context, this._favouriteDrinks.first);
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

                    // NOW WORKING ON
                    Container(
                      height: 310.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: coffeeSwiperList(),
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
                    // TILL HERE

                    Container(
                      height: 410.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _filteredCoffeeCardList(),
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
        context,
        'assets/images/coffee_cortado.png',
        'Cortado',
        'Cofster',
        'Bold espresso balanced with steamed milk for a harmonious flavor',
        '\$4.99',
        false,
      ),
      coffeeCard(
        context,
        'assets/images/coffee_americano.png',
        'Americano',
        'Cofster',
        'Bold and robust espresso combined with hot water for a strong and smooth flavor',
        '\$3.99',
        false,
      ),
      coffeeCard(
        context,
        'assets/images/coffee_cappuccino.png',
        'Cappuccino',
        'Cofster',
        'Perfectly brewed espresso with silky steamed milk and frothy foam',
        '\$3.99',
        true,
      ),
      coffeeCard(
        context,
        'assets/images/coffee_latte_machiatto.png',
        'Machiatto',
        'Cofster',
        'Savor the beauty of rich latte gently layered with velvety steamed milk',
        '\$3.99',
        true,
      ),
      coffeeCard(
        context,
        'assets/images/coffee_flat_white.png',
        'Flat white',
        'Cofster',
        'Indulge in the simplicity of double shots of bold espresso harmoniously blended with creamy, velvety milk',
        '\$3.99',
        false,
      ),
      coffeeCard(
        context,
        'assets/images/coffee_espresso.png',
        'Espresso',
        'Cofster',
        'Embrace the essence of pure coffee perfection with a concentrated shot of intense espresso',
        '\$3.99',
        false,
      ),
      coffeeCard(
        context,
        'assets/images/coffee_mocha.png',
        'Mocha',
        'Cofster',
        'Delight in the irresistible fusion of decadent chocolate, robust espresso, and velvety steamed milk',
        '\$3.99',
        false,
      ),
      coffeeCard(
        context,
        'assets/images/coffee_cold_brew.png',
        'Cold brew',
        'Cofster',
        'Discover the refreshing side of coffee with our meticulously steeped, smooth and full-bodied cold brew',
        '\$3.99',
        false,
      ),
      coffeeCard(
        context,
        'assets/images/coffee_coretto.png',
        'Coretto',
        'Cofster',
        'Elevate your coffee experience with the enticing combination of espresso artistry and a splash of art',
        '\$3.99',
        false,
      ),
      coffeeCard(
        context,
        'assets/images/coffee_irish_coffee.png',
        'Irish coffee',
        'Cofster',
        'Embark on a journey to Ireland with the classic blend of rich, smooth coffee, a hint of brown sugar',
        '\$3.99',
        false,
      ),
    ];
  }

  List<Padding> coffeeSwiperList() {
    return [
      coffeeSwiper(CardSwiper(
        context,
        'assets/images/coffee_cortado.png',
        'Cortado',
        'Cofster',
        '\$4.99',
      )),
      coffeeSwiper(CardSwiper(context, 'assets/images/coffee_americano.png',
          'Americano', 'Cofster', '\$4.99'))
    ];
  }

  List<Padding> _filteredCoffeeCardList() {
    List<int> favouriteDrinkIndices = this
        ._favouriteDrinks
        .map((favouriteDrink) => classes[favouriteDrink.toLowerCase()])
        .toList();
    return _coffeeCardList()
        .asMap()
        .entries
        .where((entry) => favouriteDrinkIndices.contains(entry.key))
        .map((entry) => entry.value)
        .toList();
  }

  // FloatingNavbar _bottomNavigationBar(int selectedIndex, Function callback) {
  //   return FloatingNavbar(
  //     currentIndex: selectedIndex,
  //     onTap: (int index) {
  //       callback(index);
  //     },
  //     backgroundColor: Color(0xFF473D3A),
  //     items: [
  //       FloatingNavbarItem(title: "Home", icon: Icons.home),
  //       FloatingNavbarItem(title: "Profile", icon: Icons.person),
  //       FloatingNavbarItem(title: "Orders", icon: Icons.history),
  //       FloatingNavbarItem(title: "Settings", icon: Icons.settings)
  //     ],
  //   );
  // }
}

import 'dart:typed_data';
import 'package:coffee_orderer/controllers/CoffeeCardController.dart';
import 'package:coffee_orderer/controllers/UserController.dart';
import 'package:coffee_orderer/controllers/AuthController.dart';
import 'package:coffee_orderer/controllers/QuestionnaireController.dart';
import 'package:coffee_orderer/models/card.dart';
import 'package:flutter/material.dart';
import 'package:coffee_orderer/utils/coffeeFunFact.dart';
import 'package:coffee_orderer/components/mainScreen/navigationBar.dart';
import 'package:coffee_orderer/components/mainScreen/popupFreeDrink.dart'
    show showPopup;
import 'package:coffee_orderer/controllers/CoffeeCardFavouriteDrinksController.dart';
import 'package:coffee_orderer/services/notificationService.dart'
    show NotificationService;
import 'package:coffee_orderer/patterns/CoffeeCardSingleton.dart';
import 'package:coffee_orderer/services/speechToTextService.dart'
    show SpeechToTextService;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:coffee_orderer/screens/mapScreen.dart';
import 'package:coffee_orderer/components/mainScreen/userImage.dart'
    show buildUserImage;
import 'package:coffee_orderer/components/mainScreen/footerImage.dart'
    show buildFooterImage;
import 'package:coffee_orderer/utils/appAssets.dart' show FooterImages;
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserController userController;
  AuthController authController;
  QuestionnaireController questionnaireController;
  CoffeeCardController coffeeCardController;
  CoffeeCardFavouriteDrinksController coffeeCardFavouriteDrinksController;
  ValueNotifier<int> _navBarItemSelected;
  List<String> _favouriteDrinks;
  List<CoffeeCard> coffeeCardObjects;
  CoffeeCardSingleton coffeeCardSingleton;
  SpeechToTextService speechToTextService;
  String _rawTextFromSpeech;
  bool _speechState;
  bool _listeningState;

  _HomePageState() {
    this.userController = UserController();
    this.authController = AuthController();
    this.questionnaireController = QuestionnaireController();
    this.coffeeCardFavouriteDrinksController =
        CoffeeCardFavouriteDrinksController();
    this._navBarItemSelected = ValueNotifier<int>(0);
    this._favouriteDrinks = [];
    this.coffeeCardObjects = [];
    this.speechToTextService = SpeechToTextService(
        _onRerenderUI, _onSetTextToSpeechResult, _onGetSpeechResult);
    this._rawTextFromSpeech = "";
    this._speechState = false;
    this._listeningState = false;
  }

  @override
  void initState() {
    super.initState();
    this.coffeeCardController = CoffeeCardController(context, _onTapHeartLogo);
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      this
          .questionnaireController
          .loadFavouriteDrinksFrom()
          .then((Map<String, List<String>> favouriteDrinks) {
        if (!mounted) return;
        setState(() {
          this._favouriteDrinks = favouriteDrinks.values.first;
          String loadedFrom = favouriteDrinks.keys.first;
          String favouriteDrink = this._favouriteDrinks.first;
          if (loadedFrom == "db") {
            return;
          }
          showPopup(context, favouriteDrink);
          NotificationService().showNotification(
            title: "New user reward",
            body:
                "You won a free ${favouriteDrink.toLowerCase()} coffee. Enjoy!",
          );
        });
      });
    });
  }

  void _onSpeechStateChanged(bool newSpeechStatus) {
    this._speechState = !newSpeechStatus;
  }

  void _onRerenderUI() {
    setState(() {});
  }

  void _onSetTextToSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      this._rawTextFromSpeech = result.recognizedWords;
      // debugging
      // print(this._rawTextFromSpeech);
    });
  }

  String _onGetSpeechResult() {
    return this._rawTextFromSpeech;
  }

  void _onSelectedIndicesNavBar(int newNavBarItemSelected) {
    this._navBarItemSelected.value = newNavBarItemSelected;
  }

  void _onTapHeartLogo(CoffeeCard coffeeCard, ValueNotifier<bool> isFavorite) {
    coffeeCard.isFavoriteNotifier.value = !isFavorite.value;
  }

  dynamic _onToggleListeningState(bool newListeningState) {
    this._listeningState = !newListeningState;
    return this._listeningState;
  }

  @override
  Widget build(BuildContext context) {
    this.coffeeCardSingleton = CoffeeCardSingleton(context);
    return FutureBuilder<Map<String, List<String>>>(
      future: this
          .questionnaireController
          .loadFavoriteDrinksAndRemoveContentFromCache(),
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, List<String>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child: CircularProgressIndicator(
                  color: Colors.brown, backgroundColor: Colors.white));
        } else if (snapshot.hasError) {
          return Text("Error occured ${snapshot.error}");
        } else {
          Map<String, List<String>> favouriteDrinksMap = snapshot.data;
          this._favouriteDrinks = List.from(favouriteDrinksMap.values.first);
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
                        FutureBuilder<dynamic>(
                          future: () async {
                            dynamic nameFromPreferences =
                                await LoggedInService.getSharedPreferenceValue(
                                    "<nameUser>");
                            return nameFromPreferences ??
                                this.authController.loadName();
                          }(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
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
                              return CircularProgressIndicator(
                                  color: Colors.brown,
                                  backgroundColor: Colors.white);
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 13.0),
                          child: FutureBuilder<Uint8List>(
                            future: this.authController.loadUserPhoto(),
                            builder: (BuildContext context,
                                AsyncSnapshot<Uint8List> snapshot) {
                              return buildUserImage(snapshot);
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
                              return CircularProgressIndicator(
                                  color: Colors.brown,
                                  backgroundColor: Colors.white);
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
                            .coffeeCardFavouriteDrinksController
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
                        children: this.coffeeCardController.getCoffeeCards(),
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
                          InkWell(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GoogleMapPage(
                                        coffeeStoreName: "Camera din Fata"),
                                  ),
                                );
                              },
                              child: buildFooterImage(
                                  FooterImages.COFFEE_IMAGE_1)),
                          InkWell(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GoogleMapPage(
                                            coffeeStoreName: "Cafe D'Arte")));
                              },
                              child: buildFooterImage(
                                  FooterImages.COFFEE_IMAGE_2)),
                          InkWell(
                              onTap: () async {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => GoogleMapPage(
                                            coffeeStoreName: "La Fabrique")));
                              },
                              child: buildFooterImage(
                                  FooterImages.COFFEE_IMAGE_3)),
                        ],
                      ),
                    ),
                    SizedBox(height: 50.0)
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: bottomNavigationBar(
                    this._navBarItemSelected,
                    _onSelectedIndicesNavBar,
                    this._speechState,
                    _onSpeechStateChanged,
                    this._listeningState,
                    _onToggleListeningState,
                    orderCount: this
                        .coffeeCardSingleton
                        .getNumberOfSetFavoriteFromCoffeeCardObjects(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

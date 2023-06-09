import 'package:coffee_orderer/controllers/CoffeeCardController.dart';
import 'package:coffee_orderer/services/speechToTextService.dart';
import 'package:coffee_orderer/utils/localUserInformation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:coffee_orderer/screens/detailsScreen.dart';
import '../models/card.dart';

class VoiceDialogController {
  static dynamic pressIconMicFromPopup([dynamic data = null]) async {
    BuildContext context;
    SpeechToTextService speechToTextService;
    void Function(bool) callbackSpeechStatus;
    bool speechStatus;
    ValueNotifier<bool> speechStatusValueNotifier;
    bool listening;
    bool initializedSpeech;
    String speechResult = "";
    if (data is List) {
      if (data.length > 4) {
        context = data[0];
        speechToTextService = data[1];
        callbackSpeechStatus = data[2];
        speechStatus = data[3];
        speechStatusValueNotifier = data[4];
        callbackSpeechStatus(speechStatus);
        speechStatusValueNotifier.value = !speechStatus;
      } else {
        context = data[0];
        speechToTextService = data[1];
        listening = data[2];
        initializedSpeech = data[3];
      }
    }
    if (listening) {
      if (!initializedSpeech) {
        await speechToTextService.init();
        initializedSpeech = !initializedSpeech;
      }
      await speechToTextService.startListening();
    } else {
      await speechToTextService.stopListening();
      initializedSpeech = !initializedSpeech;
      speechResult = speechToTextService.callbackGetSpeechResult();
      Fluttertoast.showToast(
          msg: "Speech to text result: ${speechResult}",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Color.fromARGB(255, 102, 33, 12),
          textColor: Color.fromARGB(255, 220, 217, 216),
          fontSize: 16);
      fillCacheWithDataFromSpeechResult(speechResult);
      moveToDetailsScreen(context);
    }
    return initializedSpeech;
  }

  static void fillCacheWithDataFromSpeechResult(String speechResult) {
    CoffeeCardController coffeeCardController = CoffeeCardController();
    double threshold = 0.7;
    CoffeeCard card = coffeeCardController
        .getParticularCoffeeCardGivenTheNameOfTheCoffeeFromSpeech(
            speechResult, threshold);
    if (card == null) {
      Fluttertoast.showToast(
          msg:
              "There is no coffee card in the list of coffee cards that has that name",
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
      "cardIsFavorite": card.isFavoriteNotifier.value.toString()
    });
  }

  static void moveToDetailsScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DetailsPage()));
  }
}

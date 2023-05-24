import 'package:coffee_orderer/services/speechToTextService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VoiceDialogController {
  static dynamic pressIconMicFromPopup([dynamic data = null]) async {
    SpeechToTextService speechToTextService;
    void Function(bool) callbackSpeechStatus;
    bool speechStatus;
    ValueNotifier<bool> speechStatusValueNotifier;
    bool listening;
    bool initializedSpeech;
    if (data is List) {
      if (data.length > 3) {
        speechToTextService = data[0];
        callbackSpeechStatus = data[1];
        speechStatus = data[2];
        speechStatusValueNotifier = data[3];
        callbackSpeechStatus(speechStatus);
        speechStatusValueNotifier.value = !speechStatus;
      } else {
        speechToTextService = data[0];
        listening = data[1];
        initializedSpeech = data[2];
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
      String speechResult = speechToTextService.callbackGetSpeechResult();
      Fluttertoast.showToast(
          msg: "Speech result: ${speechResult}",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Color.fromARGB(255, 102, 33, 12),
          textColor: Color.fromARGB(255, 220, 217, 216),
          fontSize: 16);
    }
    return initializedSpeech;
  }
}

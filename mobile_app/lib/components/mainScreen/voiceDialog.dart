import 'package:flutter/foundation.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:flutter/material.dart';
import '../../services/speechToTextService.dart';

SpeechToTextService speechToTextService = SpeechToTextService();

dynamic onPressFromPopup([dynamic data = null]) async {
  void Function(bool) callbackSpeechStatus;
  bool speechStatus;
  ValueNotifier<bool> speechStatusValueNotifier;
  bool listeningState;
  if (data is List) {
    if (data.length > 1) {
      callbackSpeechStatus = data[0];
      speechStatus = data[1];
      speechStatusValueNotifier = data[2];
      callbackSpeechStatus(speechStatus);
      speechStatusValueNotifier.value = !speechStatus;
    } else {
      listeningState = data[0];
    }
  }
  print("Listening state is: ${listeningState}");
  if (listeningState) {
    await speechToTextService.init();
    await speechToTextService.startListening();
  } else {
    await speechToTextService.stopListening();
  }
}

dynamic voiceDialog(
    BuildContext context,
    bool speechStatus,
    ValueNotifier<bool> speechStatusValueNotifier,
    void Function(bool) callbackSpeechStatus,
    bool startListening,
    dynamic Function(bool) callbackToggleListeningState) {
  ValueNotifier<bool> listeningStateValueNotifier =
      ValueNotifier(startListening);
  Dialogs.materialDialog(
      color: Colors.white,
      msg: "Order the drink here please",
      msgStyle: TextStyle(
          color: Colors.brown, fontSize: 18.0, fontWeight: FontWeight.bold),
      title: "Tell us the drink that you want to order",
      titleStyle: TextStyle(
          color: Colors.brown, fontSize: 12.0, fontWeight: FontWeight.bold),
      context: context,
      barrierDismissible: true,
      actions: [
        Column(
          children: [
            Container(
                width: 160,
                height: 160,
                child: ValueListenableBuilder<bool>(
                    valueListenable: listeningStateValueNotifier,
                    builder: (BuildContext context, bool listeningState,
                        Widget child) {
                      return IconButton(
                          onPressed: () async {
                            dynamic listeningState =
                                callbackToggleListeningState(startListening);
                            listeningStateValueNotifier =
                                ValueNotifier<bool>(listeningState);
                            await onPressFromPopup([listeningState]);
                          },
                          icon: Icon(
                            speechStatus ? Icons.mic : Icons.mic_off,
                            color: Color.fromARGB(255, 69, 45, 36),
                            size: 100,
                          ));
                    })

                // child: IconButton(
                //   onPressed: () async {
                //     dynamic listeningState =
                //         callbackToggleListeningState(startListening);
                //     listeningStateValueNotifier =
                //         ValueNotifier<bool>(listeningState);
                //     await onPressFromPopup([listeningState]);
                //   },
                //   icon: Icon(
                //     speechStatus ? Icons.mic : Icons.mic_off,
                //     color: Color.fromARGB(255, 69, 45, 36),
                //     size: 100,
                //   ),
                // ),
                ),
          ],
        ),
      ],
      onClose: (dynamic data) async {
        await onPressFromPopup(
            [callbackSpeechStatus, speechStatus, speechStatusValueNotifier]);
      });
}

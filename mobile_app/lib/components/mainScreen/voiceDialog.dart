import 'package:material_dialogs/material_dialogs.dart';
import 'package:flutter/material.dart';
import '../../services/speechToTextService.dart';

dynamic onPressFromPopup([dynamic data = null]) async {
  void Function(bool) callbackSpeechStatus;
  bool speechStatus;
  ValueNotifier<bool> speechStatusValueNotifier;
  if (data != null) {
    callbackSpeechStatus = data[0];
    speechStatus = data[1];
    speechStatusValueNotifier = data[2];
  }
  callbackSpeechStatus(speechStatus);
  speechStatusValueNotifier.value = !speechStatus;
  SpeechToTextService speechToTextService = SpeechToTextService();
  await speechToTextService.init();
  print("ENTERED HERE (1)");
  await speechToTextService.startListening();
  print("ENTERED HERE (2)");
  await speechToTextService.stopListening();
  print("ENTERED HERE (3)");
}

dynamic voiceDialog(
    BuildContext context,
    bool speechStatus,
    ValueNotifier<bool> speechStatusValueNotifier,
    void Function(bool) callbackSpeechStatus) {
  Dialogs.materialDialog(
      color: Colors.white,
      msg: "Order the drink here please",
      title: "Tell us the drink that you want to order",
      context: context,
      barrierDismissible: true,
      actions: [
        Column(
          children: [
            Container(
              width: 140,
              height: 140,
              child: IconButton(
                onPressed: () async {
                  // callbackSpeechStatus(speechStatus);
                  // speechStatusValueNotifier.value = !speechStatus;
                  // Navigator.pop(context);
                  await onPressFromPopup();
                },
                icon: Icon(
                  speechStatus ? Icons.mic : Icons.mic_off,
                  color: Color.fromARGB(255, 69, 45, 36),
                  size: 100,
                ),
              ),
            ),
          ],
        ),
      ],
      onClose: (dynamic data) async {
        await onPressFromPopup(
            [callbackSpeechStatus, speechStatus, speechStatusValueNotifier]);
      });
}

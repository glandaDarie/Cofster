import 'package:coffee_orderer/controllers/VoiceDialogController.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:flutter/material.dart';
import '../../services/speechToTextService.dart';

dynamic voiceDialog(
    BuildContext context,
    bool speechStatus,
    ValueNotifier<bool> speechStatusValueNotifier,
    void Function(bool) callbackSpeechStatus,
    bool startListening,
    dynamic Function(bool) callbackToggleListeningState) {
  ValueNotifier<bool> listeningStateValueNotifier =
      ValueNotifier(startListening);
  dynamic listeningState = startListening;
  bool initializedSpeech = false;
  Dialogs.materialDialog(
      color: Colors.white,
      title: "Order the drink here please",
      titleStyle: TextStyle(
          color: Colors.brown, fontSize: 16.0, fontWeight: FontWeight.bold),
      msg: "Tell us the drink that you want to order",
      msgStyle: TextStyle(
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
                    builder: (BuildContext context, bool _listeningState,
                        Widget child) {
                      return IconButton(
                          onPressed: () async {
                            listeningState =
                                callbackToggleListeningState(listeningState);
                            listeningStateValueNotifier =
                                ValueNotifier<bool>(listeningState);
                            initializedSpeech = await VoiceDialogController
                                .pressIconMicFromPopup([
                              SpeechToTextService(),
                              listeningState,
                              initializedSpeech
                            ]);
                          },
                          icon: Icon(
                            Icons.mic,
                            color: Color.fromARGB(255, 69, 45, 36),
                            size: 100,
                          ));
                    })),
          ],
        ),
      ],
      onClose: (dynamic data) async {
        await VoiceDialogController.pressIconMicFromPopup([
          SpeechToTextService(),
          callbackSpeechStatus,
          speechStatus,
          speechStatusValueNotifier
        ]);
      });
}

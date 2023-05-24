import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class SpeechToTextService {
  static SpeechToTextService _instance;

  stt.SpeechToText speechToText;
  bool _speechStatus;
  void Function() _callbackRerenderUI;
  void Function(SpeechRecognitionResult result) _callbackSetSpeechResult;
  String Function() callbackGetSpeechResult;

  factory SpeechToTextService(
      [void Function() callbackRerenderUI,
      void Function(SpeechRecognitionResult result) callbackSetSpeechResult,
      String Function() callbackGetSpeechResult]) {
    if (_instance == null) {
      _instance = SpeechToTextService._internal(
          callbackRerenderUI, callbackSetSpeechResult, callbackGetSpeechResult);
    }
    return _instance;
  }

  SpeechToTextService._internal(
      void Function() callbackRerenderUI,
      void Function(SpeechRecognitionResult result) callbackSetSpeechResult,
      String Function() callbackGetSpeechResult) {
    this.speechToText = stt.SpeechToText();
    this._speechStatus = false;
    this._callbackRerenderUI = callbackRerenderUI;
    this._callbackSetSpeechResult = callbackSetSpeechResult;
    this.callbackGetSpeechResult = callbackGetSpeechResult;
  }

  Future<void> init() async {
    try {
      this._speechStatus = await speechToText.initialize();
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Speech cannot be intialized, error: ${e}",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Color.fromARGB(255, 102, 33, 12),
          textColor: Color.fromARGB(255, 220, 217, 216),
          fontSize: 16);
      return;
    }
    this._callbackRerenderUI();
  }

  bool getSpeechStatus() {
    return this._speechStatus;
  }

  Future<void> stopListening() async {
    try {
      await speechToText.stop();
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Speech cannot be closed, error: ${e}",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Color.fromARGB(255, 102, 33, 12),
          textColor: Color.fromARGB(255, 220, 217, 216),
          fontSize: 16);
      return;
    }
    this._callbackRerenderUI();
  }

  Future<void> startListening() async {
    try {
      await speechToText.listen(onResult: this._callbackSetSpeechResult);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Cannot start listening to users voice, error: ${e}",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Color.fromARGB(255, 102, 33, 12),
          textColor: Color.fromARGB(255, 220, 217, 216),
          fontSize: 16);
      return;
    }
  }
}

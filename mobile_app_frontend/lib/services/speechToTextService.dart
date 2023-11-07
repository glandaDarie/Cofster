import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:coffee_orderer/utils/toast.dart' show ToastUtils;

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
      ToastUtils.showToast("Speech cannot be intialized, error: ${e}");
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
      ToastUtils.showToast("Speech cannot be closed, error: ${e}");
      return;
    }
    this._callbackRerenderUI();
  }

  Future<void> startListening() async {
    try {
      await speechToText.listen(onResult: this._callbackSetSpeechResult);
    } catch (e) {
      ToastUtils.showToast(
          "Cannot start listening to users voice, error: ${e}");
      return;
    }
  }
}

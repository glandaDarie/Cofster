import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextService {
  stt.SpeechToText speechToText;
  bool _speechEnabled;
  void Function() _callbackRerenderScreen;
  void Function(SpeechRecognitionResult result) _callbackSpeechResult;

  SpeechToTextService(void Function() callbackRerenderScreen,
      void callbackSpeechResult(SpeechRecognitionResult result)) {
    this.speechToText = stt.SpeechToText();
    this._speechEnabled = false;
    this._callbackRerenderScreen = callbackRerenderScreen;
    this._callbackSpeechResult = callbackSpeechResult;
  }

  void initSpeech() async {
    this._speechEnabled = await speechToText.initialize();
    this._callbackRerenderScreen();
  }

  void stopListening() async {
    await speechToText.stop();
    this._callbackRerenderScreen();
  }

  void startListening() async {
    await speechToText.listen(onResult: this._callbackSpeechResult);
    this._callbackRerenderScreen();
  }
}

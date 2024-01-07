import 'dart:async';
import 'package:coffee_orderer/utils/logger.dart';
import 'package:flutter/widgets.dart';

class DialogFormularTimerSingletonProvider extends ChangeNotifier {
  Timer timer;
  DateTime futureDateAndTime;
  Future<String> Function(String, {@required dynamic value})
      setSharedPreferenceValue;
  bool displayDialog;
  bool debug;

  static DialogFormularTimerSingletonProvider _instance;

  static DialogFormularTimerSingletonProvider getInstance({
    DateTime futureDateAndTime = null,
    bool debug = false,
    @required
        Future<String> Function(String, {@required dynamic value})
            setSharedPreferenceValue,
  }) {
    if (_instance == null) {
      _instance = DialogFormularTimerSingletonProvider._(
        futureDateAndTime: futureDateAndTime,
        setSharedPreferenceValue: setSharedPreferenceValue,
        debug: debug,
      );
    }
    return _instance;
  }

  DialogFormularTimerSingletonProvider._({
    DateTime futureDateAndTime = null,
    @required
        Future<String> Function(String, {@required dynamic value})
            setSharedPreferenceValue,
    bool debug = false,
  })  : this.futureDateAndTime = futureDateAndTime,
        this.timer = null,
        this.setSharedPreferenceValue = setSharedPreferenceValue,
        this.debug = debug,
        this.displayDialog = false;

  void setTimer({
    int days = 0,
    int hours = 0,
    int minutes = 0,
    int seconds = 0,
    int milliseconds = 0,
    int microseconds = 0,
  }) async {
    int numberOfArgumentsPassed = 0;
    numberOfArgumentsPassed += (days != 0) ? 1 : 0;
    numberOfArgumentsPassed += (hours != 0) ? 1 : 0;
    numberOfArgumentsPassed += (minutes != 0) ? 1 : 0;
    numberOfArgumentsPassed += (seconds != 0) ? 1 : 0;
    numberOfArgumentsPassed += (milliseconds != 0) ? 1 : 0;
    numberOfArgumentsPassed += (microseconds != 0) ? 1 : 0;

    if (numberOfArgumentsPassed < 1) {
      LOGGER.e("Error: Atleast one non-zero argument must be provided.");
      throw ArgumentError(
          "Error: Atleast one non-zero argument must be provided.");
    }

    int totalMicroseconds = days * Duration.microsecondsPerDay +
        hours * Duration.microsecondsPerHour +
        minutes * Duration.microsecondsPerMinute +
        seconds * Duration.microsecondsPerSecond +
        milliseconds * Duration.microsecondsPerMillisecond +
        microseconds;

    this.futureDateAndTime = DateTime.now().add(
      Duration(microseconds: totalMicroseconds),
    );
    await setSharedPreferenceValue("<elapsedTime>",
        value: this.futureDateAndTime.toString());
    const Duration periodicDuration = Duration(seconds: 1);
    if (this.timer != null) {
      this.timer.cancel();
    }
    this.timer = new Timer.periodic(
      periodicDuration,
      (Timer timer) {
        DateTime currentDateAndTime = DateTime.now();
        if (debug) {
          LOGGER.i(
              "Current date and time: ${currentDateAndTime.toString()} Future date and time: ${futureDateAndTime.toString()}");
        }
        if (this.futureDateAndTime.isBefore(currentDateAndTime) ||
            this.futureDateAndTime.isAtSameMomentAs(currentDateAndTime)) {
          this.displayDialog = true;
          notifyListeners();
          resetTimer();
        }
      },
    );
    notifyListeners();
  }

  void resetTimer() async {
    this.timer.cancel();
    this.futureDateAndTime = null;
    await setSharedPreferenceValue("<elapsedTime>",
        value: this.futureDateAndTime.toString());
    displayDialog = false;
  }
}

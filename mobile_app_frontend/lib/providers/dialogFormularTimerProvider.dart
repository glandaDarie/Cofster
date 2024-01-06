import 'dart:async';
import 'package:coffee_orderer/utils/logger.dart';
import 'package:flutter/widgets.dart';
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;

class DialogFormularTimerProvider extends ChangeNotifier {
  Timer timer;
  DateTime previousDateAndTime;
  bool debug;
  bool displayDialog;

  static DialogFormularTimerProvider _instance;

  static DialogFormularTimerProvider getInstance({
    DateTime previousDateAndTime = null,
    bool debug = false,
  }) {
    if (_instance == null) {
      _instance = DialogFormularTimerProvider._(
        previousDateAndTime: previousDateAndTime,
        debug: debug,
      );
    }
    return _instance;
  }

  DialogFormularTimerProvider._({
    DateTime previousDateAndTime = null,
    bool debug = false,
  })  : this.previousDateAndTime = previousDateAndTime,
        this.timer = null,
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

    if (numberOfArgumentsPassed != 1) {
      LOGGER.e("Error: Exactly one non-zero argument must be provided.");
      throw ArgumentError(
          "Error: Exactly one non-zero argument must be provided.");
    }

    int totalMicroseconds = days * Duration.microsecondsPerDay +
        hours * Duration.microsecondsPerHour +
        minutes * Duration.microsecondsPerMinute +
        seconds * Duration.microsecondsPerSecond +
        milliseconds * Duration.microsecondsPerMillisecond +
        microseconds;

    this.previousDateAndTime = DateTime.now().add(
      Duration(microseconds: totalMicroseconds),
    );
    await LoggedInService.setSharedPreferenceValue("<elapsedTime>",
        value: this.previousDateAndTime.toString());
    const Duration periodicDuration = Duration(seconds: 1);
    if (this.timer != null) {
      this.timer.cancel();
    }
    this.timer = new Timer.periodic(
      periodicDuration,
      (Timer timer) {
        DateTime currentDateAndTime = DateTime.now();
        if (this.previousDateAndTime.isBefore(currentDateAndTime) ||
            this.previousDateAndTime.isAtSameMomentAs(currentDateAndTime)) {
          this.displayDialog = true;
          notifyListeners();
          resetTimer();
        }
      },
    );
    notifyListeners();
  }

  void resetTimer() async {
    timer.cancel();
    this.previousDateAndTime = null;
    await LoggedInService.setSharedPreferenceValue("<elapsedTime>",
        value: this.previousDateAndTime.toString());
    displayDialog = false;
  }
}

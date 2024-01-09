import 'dart:async';
import 'package:coffee_orderer/utils/logger.dart';
import 'package:flutter/widgets.dart';

class DialogFormularTimerSingletonProvider extends ChangeNotifier {
  Timer timer;
  DateTime futureDateAndTime;
  String sharedPreferenceKey;
  Future<String> Function(String, {@required dynamic value})
      onSetSharedPreferenceValue;
  Future<dynamic> Function(String) onGetSharedPreferenceValue;
  bool displayDialog;
  bool debug;

  static DialogFormularTimerSingletonProvider _instance;

  static DialogFormularTimerSingletonProvider getInstance({
    final DateTime futureDateAndTime = null,
    @required final String sharedPreferenceKey,
    @required
        final Future<String> Function(String, {@required dynamic value})
            onSetSharedPreferenceValue,
    @required final Future<String> Function(String) onGetSharedPreferenceValue,
    final bool debug = false,
  }) {
    if (_instance == null) {
      _instance = DialogFormularTimerSingletonProvider._(
        futureDateAndTime: futureDateAndTime,
        sharedPreferenceKey: sharedPreferenceKey,
        onSetSharedPreferenceValue: onSetSharedPreferenceValue,
        onGetSharedPreferenceValue: onGetSharedPreferenceValue,
        debug: debug,
      );
    }
    return _instance;
  }

  DialogFormularTimerSingletonProvider._({
    final DateTime futureDateAndTime = null,
    @required final String sharedPreferenceKey,
    @required
        final Future<String> Function(String, {@required dynamic value})
            onSetSharedPreferenceValue,
    @required final Future<String> Function(String) onGetSharedPreferenceValue,
    final bool debug = false,
  })  : this.futureDateAndTime = futureDateAndTime,
        this.timer = null,
        this.onSetSharedPreferenceValue = onSetSharedPreferenceValue,
        this.onGetSharedPreferenceValue = onGetSharedPreferenceValue,
        this.debug = debug,
        this.displayDialog = false;

  void startTimer({
    final int days = 0,
    final int hours = 0,
    final int minutes = 0,
    final int seconds = 0,
    final int milliseconds = 0,
    final int microseconds = 0,
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

    final int totalMicroseconds = days * Duration.microsecondsPerDay +
        hours * Duration.microsecondsPerHour +
        minutes * Duration.microsecondsPerMinute +
        seconds * Duration.microsecondsPerSecond +
        milliseconds * Duration.microsecondsPerMillisecond +
        microseconds;

    final dynamic sharedPreferenceValue =
        await this.onGetSharedPreferenceValue(this.sharedPreferenceKey);
    if (sharedPreferenceValue == null) {
      // set the future date so it works also when you close the screen
      this.futureDateAndTime = DateTime.now().add(
        Duration(microseconds: totalMicroseconds),
      );
      await this.onSetSharedPreferenceValue(this.sharedPreferenceKey,
          value: this.futureDateAndTime.toString());
    } else {
      // load from sharedPreference if time is set there
      this.futureDateAndTime = DateTime.tryParse(sharedPreferenceValue);
    }

    const Duration periodicDuration = Duration(seconds: 1);
    if (this.timer != null) {
      this.timer.cancel();
    }
    this.timer = new Timer.periodic(
      periodicDuration,
      (final Timer timer) {
        DateTime currentDateAndTime = DateTime.now();
        if (this.debug) {
          LOGGER.i(
              "Current date and time: ${currentDateAndTime.toString()} Future date and time: ${futureDateAndTime.toString()}");
        }
        if (this.futureDateAndTime.isBefore(currentDateAndTime) ||
            this.futureDateAndTime.isAtSameMomentAs(currentDateAndTime)) {
          this.displayDialog = true;
          notifyListeners();
          this._resetTimer();
        }
      },
    );
    notifyListeners();
  }

  void _resetTimer() async {
    this.futureDateAndTime = null;
    await this
        .onSetSharedPreferenceValue(this.sharedPreferenceKey, value: null);
    this.displayDialog = false;
    this.timer.cancel();
  }
}

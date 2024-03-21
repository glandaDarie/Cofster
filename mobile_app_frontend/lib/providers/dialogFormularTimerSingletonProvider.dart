import 'dart:async';
import 'package:coffee_orderer/utils/logger.dart';
import 'package:flutter/widgets.dart';

class DialogFormularTimerSingletonProvider extends ChangeNotifier {
  Timer timer;
  DateTime futureDateAndTime;
  String sharedPreferenceKey;
  Future<String> Function(String, {String value}) onSetSharedPreferenceValue;
  Future<dynamic> Function(String) onGetSharedPreferenceValue;
  bool displayDialog;
  bool debug;

  static DialogFormularTimerSingletonProvider _instance;

  static DialogFormularTimerSingletonProvider getInstance({
    final DateTime futureDateAndTime = null,
    @required final String sharedPreferenceKey,
    @required
        final Future<String> Function(String, {String value})
            onSetSharedPreferenceValue,
    @required final Future<dynamic> Function(String) onGetSharedPreferenceValue,
    final bool debug = false,
  }) {
    if (_instance == null) {
      _instance = DialogFormularTimerSingletonProvider(
        futureDateAndTime: futureDateAndTime,
        sharedPreferenceKey: sharedPreferenceKey,
        onSetSharedPreferenceValue: onSetSharedPreferenceValue,
        onGetSharedPreferenceValue: onGetSharedPreferenceValue,
        debug: debug,
      );
    }
    return _instance;
  }

  DialogFormularTimerSingletonProvider({
    final DateTime futureDateAndTime = null,
    @required final String sharedPreferenceKey,
    @required
        final Future<String> Function(String, {String value})
            onSetSharedPreferenceValue,
    @required final Future<dynamic> Function(String) onGetSharedPreferenceValue,
    final bool debug = false,
  })  : this.timer = null,
        this.debug = debug,
        this.futureDateAndTime = futureDateAndTime,
        this.sharedPreferenceKey = sharedPreferenceKey,
        this.onSetSharedPreferenceValue = onSetSharedPreferenceValue,
        this.onGetSharedPreferenceValue = onGetSharedPreferenceValue,
        this.displayDialog = false;

  void startTimer({
    @required final int periodicChangeCheckTime,
    @required final int microseconds,
  }) async {
    final dynamic sharedPreferenceValue =
        await this.onGetSharedPreferenceValue(this.sharedPreferenceKey);
    if (sharedPreferenceValue == null) {
      // set the future date so it works also when you close the screen
      this.futureDateAndTime = DateTime.now().add(
        Duration(microseconds: microseconds),
      );
      await this.onSetSharedPreferenceValue(this.sharedPreferenceKey,
          value: this.futureDateAndTime.toString());
    } else {
      // load from sharedPreference if time is set there
      this.futureDateAndTime = DateTime.tryParse(sharedPreferenceValue);
    }

    final Duration periodicChangeCheck =
        Duration(seconds: periodicChangeCheckTime);
    if (this.timer != null) {
      this.timer.cancel();
    }
    this.timer = new Timer.periodic(
      periodicChangeCheck,
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
          Future.delayed(Duration(milliseconds: 500), () {
            this._resetTimer();
          });
        }
      },
    );
  }

  void _resetTimer() async {
    this.futureDateAndTime = null;
    await this
        .onSetSharedPreferenceValue(this.sharedPreferenceKey, value: null);
    this.displayDialog = false;
    this.timer.cancel();
  }
}

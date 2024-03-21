import 'dart:async';
import 'package:coffee_orderer/utils/logger.dart';
import 'package:flutter/widgets.dart';

class DialogFormularTimerSingletonProvider extends ChangeNotifier {
  Timer timer;
  DateTime futureDateAndTime;
  String sharedPreferenceKey;
  Future<String> Function(String, {String value}) onSetSharedPreferenceValue;
  Future<String> Function(String) onSetDefaultSharedPreferenceValue;
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
    @required
        final Future<String> Function(String) onSetDefaultSharedPreferenceValue,
    @required final Future<dynamic> Function(String) onGetSharedPreferenceValue,
    final bool debug = false,
  }) {
    if (_instance == null) {
      _instance = DialogFormularTimerSingletonProvider(
        futureDateAndTime: futureDateAndTime,
        sharedPreferenceKey: sharedPreferenceKey,
        onSetDefaultSharedPreferenceValue: onSetDefaultSharedPreferenceValue,
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
    @required
        final Future<String> Function(String) onSetDefaultSharedPreferenceValue,
    @required final Future<dynamic> Function(String) onGetSharedPreferenceValue,
    final bool debug = false,
  })  : this.timer = null,
        this.debug = debug,
        this.futureDateAndTime = futureDateAndTime,
        this.sharedPreferenceKey = sharedPreferenceKey,
        this.onSetDefaultSharedPreferenceValue =
            onSetDefaultSharedPreferenceValue,
        this.onSetSharedPreferenceValue = onSetSharedPreferenceValue,
        this.onGetSharedPreferenceValue = onGetSharedPreferenceValue,
        this.displayDialog = false;

  void startTimer({
    @required final int periodicChangeCheckTime,
    @required final int microseconds,
  }) async {
    this.futureDateAndTime = DateTime.now().add(
      Duration(microseconds: microseconds),
    );
    await this.onSetSharedPreferenceValue(this.sharedPreferenceKey,
        value: this.futureDateAndTime.toString());

    final Duration periodicChangeCheck =
        Duration(seconds: periodicChangeCheckTime);
    if (this.timer != null) {
      this.timer.cancel();
    }
    this.timer = new Timer.periodic(
      periodicChangeCheck,
      (final Timer timer) async {
        DateTime currentDateAndTime = DateTime.now();
        if (this.debug) {
          LOGGER.i(
              "Current date and time: ${currentDateAndTime.toString()} Future date and time: ${futureDateAndTime.toString()}");
        }
        if (this.futureDateAndTime.isBefore(currentDateAndTime) ||
            this.futureDateAndTime.isAtSameMomentAs(currentDateAndTime)) {
          this.displayDialog = true;
          notifyListeners();
          Future.delayed(Duration(milliseconds: 500), () async {
            await this._resetTimer();
          });
        }
      },
    );
  }

  void _resetTimer() async {
    this.futureDateAndTime = null;
    String onSetDefaultSharedPreferenceResponse =
        await this.onSetDefaultSharedPreferenceValue(this.sharedPreferenceKey);
    if (onSetDefaultSharedPreferenceResponse != null) {
      LOGGER.e(onSetDefaultSharedPreferenceResponse);
      return;
    }
    this.displayDialog = false;
    this.timer.cancel();
  }
}

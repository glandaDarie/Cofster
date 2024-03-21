import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_orderer/providers/dialogFormularTimerSingletonProvider.dart'
    show DialogFormularTimerSingletonProvider;
import 'package:coffee_orderer/utils/logger.dart' show LOGGER;

class LlmFavoriteDrinkFormularPopup {
  static void startPopupDisplayCountdown({
    @required BuildContext context,
    @required int periodicChangeCheckTime,
    final int days = 0,
    final int hours = 0,
    final int minutes = 0,
    final int seconds = 0,
    final int milliseconds = 0,
    final int microseconds = 0,
  }) {
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

    context.read<DialogFormularTimerSingletonProvider>().startTimer(
          periodicChangeCheckTime: periodicChangeCheckTime,
          microseconds: totalMicroseconds,
        );
  }
}

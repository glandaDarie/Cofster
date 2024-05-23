import 'package:coffee_orderer/models/card.dart' show CoffeeCard;
import 'package:flutter/material.dart';
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;
import 'package:coffee_orderer/providers/dialogFormularTimerSingletonProvider.dart'
    show DialogFormularTimerSingletonProvider;
import 'package:coffee_orderer/utils/constants.dart'
    show
        DIALOG_FORMULAR_TIMER_SECONDS,
        DIALOG_FORMULAR_PERIODIC_CHANGE_CHECK_TIME;

class MainScreenCallbacks {
  bool speechState;
  ValueNotifier<int> navBarItemSelected;
  bool listeningState;
  MainScreenCallbacks({
    @required this.speechState,
    @required this.navBarItemSelected,
    @required this.listeningState,
  });

  void onSpeechStateChanged(bool newSpeechStatus) {
    this.speechState = !newSpeechStatus;
  }

  void onSelectedIndicesNavBar(int newNavBarItemSelected) {
    this.navBarItemSelected.value = newNavBarItemSelected;
  }

  void onTapHeartLogo(CoffeeCard coffeeCard, ValueNotifier<bool> isFavorite) {
    coffeeCard.isFavoriteNotifier.value = !isFavorite.value;
  }

  dynamic onToggleListeningState(bool newListeningState) {
    this.listeningState = !newListeningState;
    return this.listeningState;
  }

  Future<void> onSetDialogFormular(
      {@required final String sharedPreferenceKey}) async {
    final dynamic elapsedTime =
        await LoggedInService.getSharedPreferenceValue(sharedPreferenceKey);
    if (elapsedTime == "Key not found") {
      await LoggedInService.setSharedPreferenceValue(
        sharedPreferenceKey,
        value: null,
      );
    }
    final DialogFormularTimerSingletonProvider dialogFormularTimerProvider =
        DialogFormularTimerSingletonProvider.getInstance(
      futureDateAndTime:
          elapsedTime != null ? DateTime.tryParse(elapsedTime) : null,
      sharedPreferenceKey: sharedPreferenceKey,
      onSetSharedPreferenceValue: (String key, {@required dynamic value}) =>
          LoggedInService.setSharedPreferenceValue(
        sharedPreferenceKey,
        value: null,
      ),
      onGetSharedPreferenceValue: (String key) =>
          LoggedInService.getSharedPreferenceValue(sharedPreferenceKey),
      debug: true,
    );
    // in prod it should be 30 minutes
    dialogFormularTimerProvider.startTimer(
      periodicChangeCheckTime: DIALOG_FORMULAR_PERIODIC_CHANGE_CHECK_TIME,
      microseconds: DIALOG_FORMULAR_TIMER_SECONDS * 1000 * 1000,
    ); // in development and when presenting 10 seconds
  }
}

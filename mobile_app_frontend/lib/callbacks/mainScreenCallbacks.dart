import 'package:coffee_orderer/models/card.dart' show CoffeeCard;
import 'package:flutter/material.dart';
import 'package:coffee_orderer/services/loggedInService.dart'
    show LoggedInService;
import 'package:coffee_orderer/providers/dialogFormularTimerSingletonProvider.dart'
    show DialogFormularTimerSingletonProvider;

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

  // work on the actual implementation here
  Future<void> onSetDialogFormular(
      {@required final String sharedPreferenceKey}) async {
    // final String sharedPreferenceKey = "<elapsedTime>";
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
    dialogFormularTimerProvider.startTimer(seconds: 10); // dev environment
  }
}

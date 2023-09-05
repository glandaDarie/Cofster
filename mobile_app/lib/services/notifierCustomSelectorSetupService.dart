import 'package:flutter/material.dart';
import 'package:coffee_orderer/services/mergeNotifierService.dart'
    show ValueNotifierService;
import 'package:coffee_orderer/services/mergeNotifierService.dart'
    show MergeNotifiers;
import 'package:coffee_orderer/notifiers/userSelectionNotifier.dart'
    show UserSelectionNotifier;

class NotifierCustomSelectorSetupService {
  ValueNotifier<int> valueQuantityNotifier;
  ValueNotifier<String> selectedSizeNotifier;
  ValueNotifier<bool> hotSelectedNotifier;
  ValueNotifier<int> sugarQuantityNotifier;
  ValueNotifier<int> iceQuantityNotifier;
  ValueNotifier<int> creamNotifier;
  ValueNotifierService<MergeNotifiers> mergedNotifiers;

  NotifierCustomSelectorSetupService(int quantity, String size, bool hot,
      int quantitySugarCubes, int quantityIceCubes, int cream) {
    this.valueQuantityNotifier = ValueNotifier<int>(quantity);
    this.selectedSizeNotifier = ValueNotifier<String>(size);
    this.hotSelectedNotifier = ValueNotifier<bool>(hot);
    this.sugarQuantityNotifier = ValueNotifier<int>(quantitySugarCubes);
    this.iceQuantityNotifier = ValueNotifier<int>(quantityIceCubes);
    this.creamNotifier = ValueNotifier<int>(cream);
    this.mergedNotifiers = null;
  }

  ValueNotifierService<MergeNotifiers> _combinedNotifiers() {
    return ValueNotifierService<MergeNotifiers>(MergeNotifiers(
      this.valueQuantityNotifier.value,
      this.selectedSizeNotifier.value,
      this.sugarQuantityNotifier.value,
      this.iceQuantityNotifier.value,
      this.creamNotifier.value,
    ));
  }

  List<UserSelectionNotifier> _getUserSelectionNotifiers() {
    this.mergedNotifiers = _combinedNotifiers();
    return [
      UserSelectionNotifier(valueQuantityNotifier, this.mergedNotifiers),
      UserSelectionNotifier(selectedSizeNotifier, this.mergedNotifiers),
      UserSelectionNotifier(sugarQuantityNotifier, this.mergedNotifiers),
      UserSelectionNotifier(iceQuantityNotifier, this.mergedNotifiers),
      UserSelectionNotifier(creamNotifier, this.mergedNotifiers),
    ];
  }

  void attachAllListenersToNotifiers() {
    List<UserSelectionNotifier> listeners = _getUserSelectionNotifiers();
    for (UserSelectionNotifier listener in listeners) {
      listener.notifier.addListener(() {
        listener.combinedNotifier.value = MergeNotifiers(
          valueQuantityNotifier.value,
          selectedSizeNotifier.value,
          sugarQuantityNotifier.value,
          iceQuantityNotifier.value,
          creamNotifier.value,
        );
      });
    }
  }
}

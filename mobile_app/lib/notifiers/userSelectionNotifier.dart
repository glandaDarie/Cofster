import 'package:flutter/material.dart';
import 'package:coffee_orderer/services/mergeNotifierService.dart'
    show ValueNotifierService;
import 'package:coffee_orderer/services/mergeNotifierService.dart'
    show MergeNotifiers;

class UserSelectionNotifier {
  final ValueNotifier notifier;
  final ValueNotifierService<MergeNotifiers> combinedNotifier;

  UserSelectionNotifier(this.notifier, this.combinedNotifier);
}

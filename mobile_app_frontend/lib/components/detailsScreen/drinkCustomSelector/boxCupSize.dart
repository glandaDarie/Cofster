import 'package:flutter/material.dart';
import 'package:coffee_orderer/components/detailsScreen/boxSizes.dart'
    show boxSizes;

List<Widget> boxCupSize(ValueNotifier<String> selectedSizeNotifier) {
  List<Widget> boxDivider = _boxCupSizeOffsetHelper();
  return [
    ...boxDivider,
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: boxSizes(selectedSizeNotifier),
    ),
    ...boxDivider,
  ];
}

List<Widget> _boxCupSizeOffsetHelper() {
  return [
    const SizedBox(height: 5.0),
    const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, thickness: 0.3, color: Colors.black38),
    ),
    const SizedBox(height: 5.0),
  ];
}

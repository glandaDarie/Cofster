import 'package:coffee_orderer/services/notifierCustomSelectorSetupService.dart'
    show NotifierCustomSelectorSetupService;
import 'package:flutter/material.dart';
import 'package:coffee_orderer/utils/appAssets.dart' show AppAssets;
import 'package:coffee_orderer/components/detailsScreen/boxExtraIngredient.dart'
    show ExtraIngredientWidget, ExtraIngredientWidgetBinary;

List<dynamic> extraIngredients(
    NotifierCustomSelectorSetupService notifierService) {
  return [
    ExtraIngredientWidget(
      quantityNotifier: notifierService.sugarQuantityNotifier,
      title: "Sugar",
      measurement: "cubes",
      image: AssetImage(AppAssets.extraIngredeints.IMAGE_SUGAR).assetName,
    ),
    ExtraIngredientWidget(
      quantityNotifier: notifierService.iceQuantityNotifier,
      title: "Ice",
      measurement: "cubes",
      image: AssetImage(AppAssets.extraIngredeints.IMAGE_ICE).assetName,
    ),
    ExtraIngredientWidgetBinary(
      creamNotifier: notifierService.creamNotifier,
      title: "Cream",
      image: AssetImage(AppAssets.extraIngredeints.IMAGE_CREAM).assetName,
    ),
  ];
}

import 'package:share_plus/share_plus.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:coffee_orderer/controllers/MapController.dart'
    show MapController;

class InvitieAFriendService extends MapController {
  InvitieAFriendService(
      {String coffeeStoreName,
      void Function() onReloadUI,
      void Function(BitmapDescriptor) onSetSourceIcon,
      void Function(BitmapDescriptor) onSetDestinationIcon})
      : super(shopName: coffeeStoreName);
}

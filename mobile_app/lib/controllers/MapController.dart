import 'package:geolocator/geolocator.dart';
import 'package:coffee_orderer/utils/coffeeShopMapLocation.dart'
    show coordiantes;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapController {
  String shopName;
  MapController([String shopName = null]) {
    this.shopName = shopName;
  }

  Future<Position> getUsersCurrentLocation() async {
    PermissionStatus permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } else {
      throw Exception('Location permission not granted');
    }
  }

  LatLng getCoffeeShopCoordinatesForMap() {
    for (MapEntry<String, List<double>> entry in coordiantes.entries) {
      if (entry.key.trim() == this.shopName.trim()) {
        List<double> elementCoordinates = entry.value;
        return LatLng(elementCoordinates[0], elementCoordinates[1]);
      }
    }
    return null;
  }
}

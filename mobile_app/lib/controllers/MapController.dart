import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:coffee_orderer/utils/coffeeShopMapLocationProperties.dart'
    show coordinates, coffeeShopsImages;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:coffee_orderer/utils/apiKeys.dart' show googleMapsAPIKey;

class MapController {
  String shopName;
  void Function() _callbackSetState;
  void Function(BitmapDescriptor) _callbackSetSourceIcon;
  void Function(BitmapDescriptor) _callbackSetDestinationIcon;
  MapController(
      [String shopName = null,
      void Function() callbackSetState,
      void Function(BitmapDescriptor) callbackSetSourceIcon,
      void Function(BitmapDescriptor) callbackSetDestinationIcon]) {
    this.shopName = shopName;
    this._callbackSetState = callbackSetState;
    this._callbackSetSourceIcon = callbackSetSourceIcon;
    this._callbackSetDestinationIcon = callbackSetDestinationIcon;
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
    for (MapEntry<String, List<double>> entry in coordinates.entries) {
      if (entry.key.trim() == this.shopName.trim()) {
        List<double> elementCoordinates = entry.value;
        return LatLng(elementCoordinates[0], elementCoordinates[1]);
      }
    }
    return null;
  }

  Future<List<LatLng>> getPolylinePoints(
      LatLng sourceLocation, LatLng destinationLocation) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleMapsAPIKey,
        PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        PointLatLng(
            destinationLocation.latitude, destinationLocation.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      this._callbackSetState();
    }
    return polylineCoordinates;
  }

  String setCustomMarkerIcon(String name) {
    String msg = "success";
    for (MapEntry<String, String> entry in coffeeShopsImages.entries) {
      if (entry.key.trim() == name.trim()) {
        try {
          BitmapDescriptor.fromAssetImage(
                  ImageConfiguration.empty, "assets/images/home.jpg")
              .then((BitmapDescriptor sourceIcon) {
            this._callbackSetSourceIcon(sourceIcon);
          });
          BitmapDescriptor.fromAssetImage(
                  ImageConfiguration.empty, coffeeShopsImages[name])
              .then((BitmapDescriptor destinationIcon) {
            this._callbackSetDestinationIcon(destinationIcon);
            return true;
          });
        } catch (e) {
          msg = "Exception: ${e}";
        }
      }
    }
    return msg;
  }
}

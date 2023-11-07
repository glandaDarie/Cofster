import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:coffee_orderer/controllers/MapController.dart';
import 'dart:async';

class GoogleMapPage extends StatefulWidget {
  final String coffeeStoreName;

  const GoogleMapPage({Key key, @required this.coffeeStoreName})
      : super(key: key);

  @override
  _GoogleMapPageState createState() => _GoogleMapPageState(coffeeStoreName);
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  LatLng sourceLocation;
  LatLng destinationLocation;
  MapController mapController;
  String coffeeStoreName;
  List<LatLng> polylineCoordinates;
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  Completer<GoogleMapController> completerController;

  _GoogleMapPageState(String coffeeStoreName) {
    this.coffeeStoreName = coffeeStoreName;
    this.mapController = MapController(
        shopName: this.coffeeStoreName,
        callbackSetState: onReloadUI,
        callbackSetSourceIcon: onSetSourceIcon,
        callbackSetDestinationIcon: onSetDestinationIcon);
    this.sourceLocation = null;
    this.destinationLocation =
        this.mapController.getCoffeeShopCoordinatesForMap();
    this.sourceIcon = BitmapDescriptor.defaultMarker;
    this.destinationIcon = BitmapDescriptor.defaultMarker;
    this.completerController = Completer();
  }

  void onSetSourceIcon(BitmapDescriptor sourceIcon) {
    this.sourceIcon = sourceIcon;
  }

  void onSetDestinationIcon(BitmapDescriptor destinationIcon) {
    this.destinationIcon = destinationIcon;
  }

  void onReloadUI() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    completerController.future.then((GoogleMapController controller) {
      controller.dispose();
    });
    completerController = null;
  }

  @override
  Widget build(BuildContext context) {
    String response = this.mapController.setCustomMarkerIcon(coffeeStoreName);
    if (response != "success") {
      return Scaffold(
          body: Center(
        child: Text("${response}"),
      ));
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        body: FutureBuilder<Position>(
          future: this.mapController.getUsersCurrentLocation(),
          builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
            if (snapshot.hasData) {
              this.sourceLocation =
                  LatLng(snapshot.data.latitude, snapshot.data.longitude);
              return FutureBuilder<List<LatLng>>(
                future: this.mapController.getPolylinePoints(
                    this.sourceLocation, this.destinationLocation),
                builder: (BuildContext context,
                    AsyncSnapshot<List<LatLng>> snapshotPolyLines) {
                  if (snapshotPolyLines.hasData) {
                    polylineCoordinates = snapshotPolyLines.data;
                    return GoogleMap(
                      onMapCreated: (GoogleMapController googleMapController) {
                        completerController.complete(googleMapController);
                      },
                      initialCameraPosition: CameraPosition(
                        target: sourceLocation ?? LatLng(0, 0),
                        zoom: 14.5,
                      ),
                      polylines: {
                        Polyline(
                            polylineId: PolylineId("route"),
                            points: polylineCoordinates,
                            color: Colors.black54,
                            width: 5)
                      },
                      markers: {
                        Marker(
                            markerId: MarkerId("source"),
                            icon: this.sourceIcon,
                            position: this.sourceLocation),
                        Marker(
                            markerId: MarkerId("destination"),
                            icon: this.destinationIcon,
                            position: this.destinationLocation)
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    return Center(
                        child: CircularProgressIndicator(
                            color: Colors.brown,
                            backgroundColor: Colors.white));
                  }
                },
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return Center(
                  child: CircularProgressIndicator(
                      color: Colors.brown, backgroundColor: Colors.white));
            }
          },
        ),
      ),
    );
  }
}

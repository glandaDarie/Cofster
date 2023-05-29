// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:coffee_orderer/controllers/MapController.dart';

// class GoogleMapPage extends StatefulWidget {
//   final String coffeeStoreName;

//   const GoogleMapPage({Key key, @required this.coffeeStoreName})
//       : super(key: key);

//   @override
//   _GoogleMapPageState createState() => _GoogleMapPageState(coffeeStoreName);
// }

// class _GoogleMapPageState extends State<GoogleMapPage> {
//   LatLng sourceLocation;
//   LatLng destinationLocation;
//   MapController mapController;
//   String coffeeStoreName;

//   _GoogleMapPageState(String coffeeStoreName) {
//     this.coffeeStoreName = coffeeStoreName;
//     this.mapController = MapController(this.coffeeStoreName);
//     this.destinationLocation =
//         this.mapController.getCoffeeShopCoordinatesForMap();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<Position>(
//         future: this.mapController.getUsersCurrentLocation(),
//         builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
//           if (snapshot.hasData) {
//             sourceLocation =
//                 LatLng(snapshot.data.latitude, snapshot.data.longitude);
//           }
//           return GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: sourceLocation ?? LatLng(0, 0),
//               zoom: 13.5,
//             ),
//             markers: {
//               Marker(markerId: MarkerId("source"), position: sourceLocation),
//               Marker(
//                   markerId: MarkerId("destination"),
//                   position: this.destinationLocation)
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:coffee_orderer/controllers/MapController.dart';

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

  _GoogleMapPageState(String coffeeStoreName) {
    this.coffeeStoreName = coffeeStoreName;
    this.mapController = MapController(this.coffeeStoreName);
    this.destinationLocation =
        this.mapController.getCoffeeShopCoordinatesForMap();
  }

  @override
  Widget build(BuildContext context) {
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
              sourceLocation =
                  LatLng(snapshot.data.latitude, snapshot.data.longitude);
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: sourceLocation ?? LatLng(0, 0),
                  zoom: 10.5,
                ),
                markers: {
                  Marker(
                      markerId: MarkerId("source"), position: sourceLocation),
                  Marker(
                      markerId: MarkerId("destination"),
                      position: this.destinationLocation)
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

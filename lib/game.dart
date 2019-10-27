import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
//import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class Game extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Battleships", home: Scaffold(body: GameMap()));
  }
}

class GameMap extends StatefulWidget {
  State<GameMap> createState() => GameMapState();
}

class GameMapState extends State<GameMap> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  LatLng marker1 = new LatLng(-37.569792, 143.887614);
  Location location = new Location();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  static CameraPosition _kUni = CameraPosition(
    target: LatLng(-37.569792, 143.887614),
    zoom: 20,
  );

  void updateGoogleMap() async {
    GoogleMapController cont = await _controller.future;
    setState(() {
      CameraPosition newPosition = CameraPosition(
        target: LatLng(-37.569792, 143.887614),
        zoom: 15,
      );
      cont.animateCamera(CameraUpdate.newCameraPosition(newPosition));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
    });
  }

  _addmarker() {
    var markerIdVal = "1";
    final MarkerId markerId = MarkerId(markerIdVal);

    final Marker marker = Marker(
        markerId: markerId,
        position: marker1,
        infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        visible: true,
        onTap: () {});
    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  _moveToUser() async {    
    var pos = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        
        zoom: 15.0,
        )
        )
        );
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          mapType: MapType.hybrid,
          myLocationButtonEnabled: true,
          initialCameraPosition: _kUni,
          markers: Set<Marker>.of(markers.values),
        ),
        Positioned(
          bottom: 30,
          right: 10,
          child: FloatingActionButton(
              onPressed: _addmarker,              
              child: Icon(Icons.filter_tilt_shift,
                  color: Colors.white, size: 50.0)),
        )
      ],
    );
  }
}

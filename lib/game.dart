import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
//import 'package:geoflutterfire/geoflutterfire.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class Game extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: GameMap(),
    ));
  }
}

class GameMap extends StatefulWidget {
  State<GameMap> createState() => GameMapState();
}

class GameMapState extends State<GameMap> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  Map<String, double> userLocation;

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
    
    
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text("Battleships"),
          centerTitle: true,
          backgroundColor: Colors.green[600],
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 500,
                child: GoogleMap(
                    mapType: MapType.hybrid,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: _kUni,
                    onMapCreated: _onMapCreated),
              ),
            ],
          ),
        ));
  }
}

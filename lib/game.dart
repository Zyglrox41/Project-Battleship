import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_battleships/util/open_location_code.dart' as olc;
import 'package:project_battleships/util/creategrid.dart';
import 'dart:async';
import 'package:geoflutterfire/geoflutterfire.dart';
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
  // Google maps
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;

  // Firestore
  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();  

  // Positioning Variables
  LatLng marker1 = new LatLng(-37.626250, 143.891250);
  Location location = Location();
  StreamSubscription sub;
  Geolocator geolocator = Geolocator();
  Position userLocation;

  // Marker variables
  final Set<Marker> _onTapMarker = {};
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  BitmapDescriptor gridSquare, gridSquareSelected;
  List<LatLng> grid;

  var team = "blue";


  // Initiate before loading here
  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(96, 96)), 'android/assets/grid.png')
        .then((onValue) {
      gridSquare = onValue;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(96, 96)),
            'android/assets/gridselected.png')
        .then((onValue) {
      gridSquareSelected = onValue;
    });
  }

  // Override dispose to cancel the StreamSubscription object to prevent memory leaks/excess data etc
  @override
  void dispose(){
    sub.cancel();
    super.dispose();
  }

  static CameraPosition _kUni = CameraPosition(
    target: LatLng(-37.626250, 143.891250),
    zoom: 18,
  );

  void updateGoogleMap() async {
    var pos = await location.getLocation();
    GoogleMapController cont = await _controller.future;
    setState(() {
      CameraPosition newPosition = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 18,
      );
      cont.animateCamera(CameraUpdate.newCameraPosition(newPosition));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller.complete(controller);
    });
    _genGrid(); 
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

  void _onAddMarkerButtonPressed(LatLng latlng) {
    olc.encode(latlng.latitude, latlng.longitude);
  }

  _genGrid() {
    genPlusCodes();
    grid = latlngGrid();

    for (var i = 0; i < grid.length; ++i) {
      var markerIdVal = getPlusCode(i);
      MarkerId markerId = MarkerId(markerIdVal);
      Marker marker = Marker(
          markerId: markerId,
          position: grid[i],
          infoWindow: InfoWindow(title: markerIdVal),
          icon: gridSquare);
      setState(() {
        markers[markerId] = marker;
      });
    }
  }

  Future<DocumentReference> _addGeoPointOnGpsLocation() async {
    var pos = await location.getLocation();
    GeoFirePoint point =
        geo.point(latitude: pos.latitude, longitude: pos.longitude);
    return firestore
        .collection('structures')        
        .add({
          'team': team,
          'position': point.data, 
          'name': 'User Query',
          'pluscode':  olc.encode(pos.latitude, pos.longitude)
          });
  } 

  @override
  Widget build(BuildContext context) {    
    return new Stack(
      children: <Widget>[
        GoogleMap(
            onMapCreated: _onMapCreated,
            mapType: MapType.satellite,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kUni,
            zoomGesturesEnabled: false,
            rotateGesturesEnabled: false,
            markers: Set<Marker>.of(markers.values),
            onTap: (latlang) {
              if (_onTapMarker.length >= 1) {
                _onTapMarker.clear();
              }
              _onAddMarkerButtonPressed(latlang);
            }),
        Positioned(
          bottom: 10,
          right: 10,
          child: FloatingActionButton(
              heroTag: "PlaceMarkerButton",
              onPressed: _addmarker,
              child: Icon(Icons.filter_tilt_shift,
                  color: Colors.white, size: 50.0)),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: FloatingActionButton(
              heroTag: "GoToUserButton",
              onPressed: updateGoogleMap,
              child: Icon(Icons.pin_drop, color: Colors.white, size: 50.0)),
        ),
        Positioned(
          bottom: 10,
          left: 90,
          child: FloatingActionButton(
              heroTag: "QueryPositionButton",
              onPressed: _addGeoPointOnGpsLocation,
              child: Icon(Icons.add, color: Colors.white, size: 50.0)),
        )
      ],
    );
  }
}

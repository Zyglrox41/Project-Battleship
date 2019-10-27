import 'package:project_battleships/util/open_location_code.dart' as olc;
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Suffix pattern
var suffixList = ["22", "23", "24", "25", "32", "33", "34", "35"];

// Input prefix
var prefix = "4RJ59VFR+";

// List to store lat/long coords
List<LatLng> gridlist = new List();

List<String> plusCodes = new List();

void genPlusCodes(){  
   for(var i = 0;i<suffixList.length;i++){
     // Decode plus codes into lat/long and add them to the list
     plusCodes.add(prefix + suffixList[i]);
  }
}

List latlngGrid(){
   for(var i = 0;i<suffixList.length;i++){
     // Decode plus codes into lat/long and add them to the list
     var lat = olc.decode(plusCodes[i]).center.latitude;
     var lng = olc.decode(plusCodes[i]).center.longitude;    
     gridlist.add(new LatLng(lat, lng));
  }
  return gridlist;
}

String getPlusCode(var i){
  return plusCodes[i];
}
 

import 'package:project_battleships/util/open_location_code.dart' as olc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Suffix pattern
var suffixList = ["GG", "GH", "GJ", "GM", "GP", "GQ", "GR", "GV", "GW", "GX",
                  "FG", "FH", "FJ", "FM", "FP", "FQ", "FR", "FV", "FW", "FX",
                  "CG", "CH", "CJ", "CM", "CP", "CQ", "CR", "CV", "CW", "CX",
                  "9G", "9H", "9J", "9M", "9P", "9Q", "9R", "9V", "9W", "9X",
                  "8G", "8H", "8J", "8M", "8P", "8Q", "8R", "8V", "8W", "8X",
                  "7G", "7H", "7J", "7M", "7P", "7Q", "7R", "7V", "7W", "7X",
                  "6G", "6H", "6J", "6M", "6P", "6Q", "6R", "6V", "6W", "6X",
                  "5G", "5H", "5J", "5M", "5P", "5Q", "5R", "5V", "5W", "5X",
                  "4G", "4H", "4J", "4M", "4P", "4Q", "4R", "4V", "4W", "4X",
                  "3G", "3H", "3J", "3M", "3P", "3Q", "3R", "3V", "3W", "3X",
                  "2G", "2H", "2J", "2M", "2P", "2Q", "2R", "2V", "2W", "2X"
                  ];

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

 

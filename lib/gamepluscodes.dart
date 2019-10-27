import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PlusGame extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new WebView(
        initialUrl: 'https://plus.codes/4RJ5CVHQ+X29',
        javascriptMode: JavascriptMode.unrestricted,
        
    ));
  }
}

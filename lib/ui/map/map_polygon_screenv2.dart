import 'package:flutter/material.dart';
import 'package:siap/geodraw/geodraw.dart';
import 'package:latlong/latlong.dart';
class PolygonPage extends StatefulWidget {
  final int sectorCode;

  PolygonPage({this.sectorCode});
  @override
  State<StatefulWidget> createState() => MapPolygonScreenState();
}

class MapPolygonScreenState extends State<PolygonPage> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(children: <Widget>[
        PolygonPicker(
          sectorCode: widget.sectorCode,
          callback: (BuildContext context, List<LatLng> points) {
            print("Polygon;");
            for (final point in points) {
              print("$point");
            }
          },
        ),
        SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 10.0, left: 16.0),
              alignment: Alignment.topLeft,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                mini: true,
                heroTag: null,
                onPressed: () => Navigator.of(context).pop(),
                child: Icon(Icons.arrow_back),
              ),
            ),
          )
      ]),
    );
  }
}

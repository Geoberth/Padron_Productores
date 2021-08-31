import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:siap/geodraw/geodraw.dart';
import 'package:latlong/latlong.dart';
import 'package:siap/livemap/livemap.dart';
import 'package:siap/utils/settings.dart';
import 'package:siap/utils/ui_data.dart';

class MarkerPage extends StatefulWidget {
   final Map<String, dynamic> coords;
   MarkerPage({ this.coords});
  @override
  _MapScreenState createState() => _MapScreenState();
}
class _MapScreenState extends State<MarkerPage> { 
  LatLng _currentPosition;
  bool _isCamera = false;
  GeoDrawController controller;
  LatLng  positions;
   Map<String, dynamic> params = { "latitude": null,"longitude":null };
  @override
  Widget build(BuildContext context) {
  
    Responsive responsive = Responsive(context);
    if(widget.coords['latitude'] != null ){
      positions = new LatLng(
            double.parse(widget.coords['latitude']),
            double.parse(widget.coords['longitude']));
    }
      
    final height = responsive.ip(4.3);
   
    
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(children: <Widget>[
                    MarkerPicker(
                      initPosition: positions,
                      callback: (BuildContext context, LatLng point) {
                        setState(() {

                          _currentPosition = point;
                          _isCamera = true;
                        });
                        print("POINT: $_currentPosition ");
                        //Navigator.of(context).pop();
                      },
                    ),
                    Container(
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
                      //_buildCenterPin(constraints, height)
                  ]);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              constraints: BoxConstraints(
                minHeight: 200.0
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Text("Ubicación Geográfica", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                  SizedBox(height: 5.0),
                  Text("Establece el punto en el Mapa", style: TextStyle(color: Colors.grey, letterSpacing: 0.5, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20.0),
                  Container(
                    height: 50.0,
                    child: 
                    
                    (_isCamera == true ) 
                     ?
                     Column(children: <Widget>[
                      Text("Latitud: ${ _currentPosition?.latitude ?? ''}", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: responsive.ip(1.4), color: Colors.grey, letterSpacing: 0.5, fontWeight: FontWeight.bold)),
                      Text("Longitud: ${_currentPosition?.longitude ?? ''}", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: responsive.ip(1.4), color: Colors.grey, letterSpacing: 0.5, fontWeight: FontWeight.bold)),
                    ])
                      :
                      (positions?.latitude != null )?
                      Column(children: <Widget>[
                      Text("Latitud: ${ positions?.latitude ?? ''}", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: responsive.ip(1.4), color: Colors.grey, letterSpacing: 0.5, fontWeight: FontWeight.bold)),
                      Text("Longitud: ${ positions?.longitude ?? ''}", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: responsive.ip(1.4), color: Colors.grey, letterSpacing: 0.5, fontWeight: FontWeight.bold)),
                    ])
                    :SpinKitRotatingCircle(
                      color: Colors.black,
                      size: 20.0,
                    )
                    ,
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    height: UiData.heightMainButtons,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                      ),
                      color: Colors.black,
                      onPressed: (_isCamera == true) ?  _finish:(positions?.latitude != null )? _finish:null,
                      child: Text('ESTABLECER DIRECCIÓN', style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
   Widget _buildCenterPin(BoxConstraints constraints, double height) {
    return Positioned(
      top: constraints.maxHeight / 2 - height - 15,
      left: 0.0,
      right: 0.0,
      child: Column(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 250.0
            ),
            child: Container(
              height: height,
              width: height,
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: SpinKitRotatingCircle(
                color: Colors.black,
                size: 80.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              )
            )
          ),
          Container(
            width: 4.0,
            height: 15.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(4.0),
                bottomRight: Radius.circular(4.0)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 5.0, // has the effect of softening the shadow
                  spreadRadius: 1.0,
                  offset: Offset(
                    1.0, // horizontal, move right 10
                    1.0, // vertical, move down 10
                  ),
                )
              ]
            ),
          )
        ],
      ),
    );
  }
  _finish() {
    Navigator.of(context).pop(_currentPosition);
  }
}

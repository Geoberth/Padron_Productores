import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:siap/models/parcelas/parcelas_model.dart';
import 'package:siap/utils/settings.dart';
import 'package:siap/utils/ui_data.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controllerCompleter = Completer();
  GoogleMapController _controllerMap;
  Parcela ubicacionGeo;

  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(19.432608, -99.133209),
    zoom: 14.4746,
  );
      
  @override
  Widget build(BuildContext context) {
    Responsive responsive = Responsive(context);
    final height = responsive.ip(4.3);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: <Widget>[
                      GoogleMap(
                        mapType: MapType.hybrid,
                        initialCameraPosition: _initialPosition,
                        rotateGesturesEnabled: false,
                        tiltGesturesEnabled: false,
                        myLocationButtonEnabled: false,
                        myLocationEnabled: true,
                        onCameraMoveStarted: _onCameraMoveStarted,
                        onCameraMove: _onCameraMove,
                        onCameraIdle: _onCameraIdle,
                        onMapCreated: (GoogleMapController controller) {
                          _controllerMap = controller;
                          if(!_controllerCompleter.isCompleted){
                            _controllerCompleter.complete(controller);
                          }
                          _setCurrentLocation();
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10.0, right: 5.0),
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          mini: true,
                          heroTag: null,
                          onPressed: _setCurrentLocation,
                          child: Icon(Icons.gps_fixed),
                        ),
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
                      _buildCenterPin(constraints, height)
                    ],
                  );
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
                    child: (_isCameraMove == false) ?
                    Column(children: <Widget>[
                      Text("Latitude: ${_currentPosition?.latitude ?? ''}", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: responsive.ip(1.4), color: Colors.grey, letterSpacing: 0.5, fontWeight: FontWeight.bold)),
                      Text("Longitude: ${_currentPosition?.longitude ?? ''}", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: responsive.ip(1.4), color: Colors.grey, letterSpacing: 0.5, fontWeight: FontWeight.bold)),
                    ]) : SpinKitRotatingCircle(
                      color: Colors.black,
                      size: 20.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    height: UiData.heightMainButtons,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                      ),
                      color: Colors.black,
                      onPressed: (_isCameraMove == false) ? _finish: null,
                      child: Text('ESTABLECER DIRECCIÓN', style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
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

  bool _isCameraMove = false;
  LatLng _currentPosition;
  
  _onCameraMoveStarted() {
    print("OnCameraMoveStarted");
    setState(() {
      _currentPosition = null;
      _isCameraMove = true;
    });
  }

  _onCameraMove(CameraPosition cameraPosition) {
    print("OnCameraMove");
    _currentPosition = cameraPosition.target;
  }

  _onCameraIdle() {
    print("OnCameraIdle");
    setState(() {
      _isCameraMove = false;
      print(_currentPosition?.latitude);
    });
  }

  void _setCurrentLocation () async {
    Position location = await Geolocator().getCurrentPosition();
    _currentPosition = LatLng(location.latitude, location.longitude);
    _controllerMap.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(location.latitude, location.longitude), zoom: 14.0
    )));
  }

  _finish() {
    Navigator.of(context).pop(_currentPosition);
  }
}
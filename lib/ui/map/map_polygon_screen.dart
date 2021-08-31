import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:load/load.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/repository/home/home_repository.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/ui/home/home_screen.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/ui/widgets/fab_bottom_app_bar_item.dart';
import 'package:siap/utils/ui_data.dart';

class MapPolygonScreen extends StatefulWidget {
  final int sectorCode;

  MapPolygonScreen({this.sectorCode});
  @override
  State<StatefulWidget> createState() => MapPolygonScreenState();
}

class MapPolygonScreenState extends State<MapPolygonScreen> {
  UserModel _userModel = UserSingleton.instance.user;
  HomeRepository _homeRepository = HomeRepository();
  GoogleMapController _controllerMap;

  List<LatLng> latLngPoints = <LatLng>[];

  Map<PolygonId, Polygon> polygons = <PolygonId, Polygon>{};
  int _polygonIdCounter = 1;

  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.hybrid,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(19.432608, -99.133209),
              zoom: 10.0,
            ),
            polygons: Set<Polygon>.of(polygons.values),
            polylines: Set<Polyline>.of(polylines.values),
            onMapCreated: (GoogleMapController controller) {
              this._controllerMap = controller;
              _setCurrentLocation();
            },
            onTap: (_polygonIdCounter > 1) ? null : (LatLng latLng) => _addPolyline(latLng),
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
        ],
      ),
          /* Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Row(
              children: <Widget>[
                Expanded(child: FlatButton(
                  child: Text('Nuevo'),
                  onPressed: (_polylineIdCounter < 3) ? null : _addPolygon,
                )),
                Expanded(child: FlatButton(
                  child: Text('Limpiar'),
                  onPressed: (_polygonIdCounter == 1 && _polylineIdCounter == 1) ? null : _cleanMap,
                )),
                Expanded(child: FlatButton(
                  child: Text('Guardar'),
                  onPressed: (_polygonIdCounter != 2) ? null : _savePolygon,
                )),
              ],
            ),
          ) */
      bottomNavigationBar: FABBottomAppBar(
        centerItemText: "Guardar",
        centerTextStyle: TextStyle(color: (_polygonIdCounter != 2) ? Colors.grey : UiData.colorPrimary, fontWeight: FontWeight.bold),
        notchedShape: CircularNotchedRectangle(),
        items: [
          FABBottomAppBarItem(
            iconData: Icons.close,
            text: 'Limpiar',
            onPress: (_polygonIdCounter == 1 && _polylineIdCounter == 1) ? null : _cleanMap,
          ),
          FABBottomAppBarItem(
            iconData: Icons.add,
            text: 'Agregar',
            onPress: (_polylineIdCounter < 3) ? null : _addPolygon
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (_polygonIdCounter != 2) ? null : _savePolygon, 
        child: Icon(Icons.check, color: Colors.white),
        backgroundColor: (_polygonIdCounter != 2) ? Colors.grey.withOpacity(0.8) : Colors.green,
      ),
    );
  }

  void _setCurrentLocation () async {
    Position location = await Geolocator().getCurrentPosition();
    _controllerMap.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(location.latitude, location.longitude), zoom: 14.0
    )));
  }

  void _addPolyline(LatLng latLng) {
    latLngPoints.add(latLng);
    if(latLngPoints.length > 1) {
      final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
      _polylineIdCounter++;
      final PolylineId polylineId = PolylineId(polylineIdVal);

      final Polyline polyline = Polyline(
        polylineId: polylineId,
        consumeTapEvents: true,
        color: Colors.red,
        width: 3,
        points: latLngPoints,
        onTap: () {
          print("Click in polyline: $polylineId");
        },
      );

      setState(() {
        polylines[polylineId] = polyline;
      });
    }
  }

  void _addPolygon() {
    final int polygonCount = polygons.length;

    if (polygonCount == 1) {
      return;
    }

    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    print(_polygonIdCounter);
    _polygonIdCounter++;
    final PolygonId polygonId = PolygonId(polygonIdVal);

    final Polygon polygon = Polygon(
      polygonId: polygonId,
      consumeTapEvents: true,
      strokeColor: Colors.red,
      strokeWidth: 3,
      fillColor: Colors.red.withOpacity(0.5),
      points: latLngPoints,
    );

    setState(() {
      polylines = <PolylineId, Polyline>{};
      polygons[polygonId] = polygon;
    });
  }

  _cleanMap() {
    latLngPoints = <LatLng>[];
    _polygonIdCounter = 1;
    _polylineIdCounter = 1;
    setState(() {
      polygons = <PolygonId, Polygon>{};
      polylines = <PolylineId, Polyline>{};
    });
  }

  _savePolygon() async {
    try {
      showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
      List<Map<String, dynamic>> data = <Map<String, dynamic>>[];
      latLngPoints.map((latLng) {
        data.add({"lat": latLng.latitude, "lng": latLng.longitude});
      }).toList();
      await _homeRepository.addParcela(userId: _userModel.id, item: jsonEncode(data), categoryId: TipoParcela.poligono, plotId: widget.sectorCode);  
      Navigator.of(context).pop(true);
    }catch(error) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
        backgroundColor: Colors.red, leftBarIndicatorColor: Colors.red,
        isDismissible: true, duration: Duration(seconds: 8),
        icon: Icon(Icons.close,color: Colors.white,),
        titleText: Text("Mensaje",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
        messageText: Text(error.toString(), style: TextStyle(color: Colors.white)),
      )..show(context);
    }finally {
      hideLoadingDialog();
    }
  }

}
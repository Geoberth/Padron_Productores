/* import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapLocationScreen  extends StatelessWidget{
  final LatLng latLngParcela;
  final List<LatLng> poligono;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Marker marker;

  Map<PolygonId, Polygon> polygons = <PolygonId, Polygon>{};

  CameraPosition _initialPosition;

  MapLocationScreen({this.latLngParcela, this.poligono}) {
    if(latLngParcela != null) {
      _initializeMarker();
    } else {
      _initializePoligono();
    }
  }

  _initializeMarker() {
    MarkerId markerId = MarkerId("id_1");
    marker = Marker(
      markerId: markerId,
      position: latLngParcela,
    );
    markers[markerId] = marker;
    _initialPosition = CameraPosition(
      target: latLngParcela,
      zoom: 12.0,
    );
  }

  _initializePoligono() {
    _initialPosition = CameraPosition(
      target: poligono[0],
      zoom: 12.0,
    );

    PolygonId polygonId = PolygonId("id_1");

    final Polygon polygon = Polygon(
      polygonId: polygonId,
      consumeTapEvents: true,
      strokeColor: Colors.red,
      strokeWidth: 3,
      fillColor: Colors.red.withOpacity(0.5),
      points: poligono,
    );

    polygons[polygonId] = polygon;
  }
      
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _initialPosition,
            rotateGesturesEnabled: false,
            tiltGesturesEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            polygons: Set<Polygon>.of(polygons.values),
            markers: Set<Marker>.of(markers.values)
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
      )
    );
  }
} */

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:siap/models/geolocation-list/geolocation_model_list.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/ui/home/home_screen.dart';
import 'package:siap/utils/settings.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapLocationScreen extends StatefulWidget {
   Parcela parcela;
   MapLocationScreen({ @required this.parcela});
  @override
  _MapLocationScreen createState() => _MapLocationScreen();
}
class _MapLocationScreen extends  State<MapLocationScreen> {
  Parcela parcela;
  Produccion _produccion;
  bool isLoading=true;
  UserModel _user = UserSingleton.instance.user;

  final _key = UniqueKey();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  // Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  // Marker marker;

  // Map<PolygonId, Polygon> polygons = <PolygonId, Polygon>{};

  // CameraPosition _initialPosition;

  // LatLng latLngParcela;
  // List<LatLng> poligono = List<LatLng>();
 

  // _initializeMarker() {
  //   List<String> latLngAsList = parcela.item.split(",");
  //   latLngParcela = LatLng(double.parse(latLngAsList[0]), double.parse(latLngAsList[1]));

  //   MarkerId markerId = MarkerId("id_1");
  //   marker = Marker(
  //     markerId: markerId,
  //     position: latLngParcela,
  //   );
  //   markers[markerId] = marker;
  //   _initialPosition = CameraPosition(
  //     target: latLngParcela,
  //     zoom: 12.0,
  //   );
  // }

  // _initializePoligono() {
  //   final data = jsonDecode(parcela.item);
  //   data.forEach((v) {
  //     poligono.add(LatLng(v["lat"], v["lng"]));
  //   });

  //   _initialPosition = CameraPosition(
  //     target: poligono[0],
  //     zoom: 12.0,
  //   );

  //   PolygonId polygonId = PolygonId("id_1");

  //   final Polygon polygon = Polygon(
  //     polygonId: polygonId,
  //     consumeTapEvents: true,
  //     strokeColor: Colors.red,
  //     strokeWidth: 3,
  //     fillColor: Colors.red.withOpacity(0.5),
  //     points: poligono,
  //   );

  //   polygons[polygonId] = polygon;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        Stack(
          children: <Widget>[
            WebView(
              key: _key,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: Settings.mapUrl +
                  widget.parcela?.idUnico + '/typeUser/' +
                  _user.tipoPersona?.toString() +
                  '/'+_user.id?.toString() + '/' + widget.parcela.ogcFid.toString(),
              onPageFinished: (url) {
                setState(() {
                isLoading = false;
              });
              },
              //gestureNavigationEnabled: true,
            ),
            SafeArea(
              child: Container(
                margin: EdgeInsets.only(top: 10.0, left: 16.0),
                alignment: Alignment.topCenter,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  mini: true,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            )
          ],
        ),
        isLoading ? Center( child: CircularProgressIndicator(),)
                    : Stack(),
        // Positioned(
        //   bottom: 0.0,
        //   child: Container(
        //     padding: EdgeInsets.all(16.0),
        //     width: MediaQuery.of(context).size.width,
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.only(
        //             topLeft: Radius.circular(20.0),
        //             topRight: Radius.circular(20.0)),
        //         color: Colors.white),
        //     child: Column(
        //       mainAxisSize: MainAxisSize.min,
        //       children: <Widget>[
                
        //         // _buildNameUser(),
        //         // _buildCurp(),
        //         // _buildBussinesName(),
        //         // _buildRfc()
        //       ],
        //     ),
        //   ),
        // )
      ],
    ));
  }
  Widget _buildNameUser() {
     if (_user.tipoPersona == 1 ) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: Center(
                      child: Text("Nombre",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text("${_user.nombre } ${ _user.appaterno } ${(_user.apmaterno != null) ? _user.apmaterno : '' }")))
            ],
          ),
          Divider()
        ],
      );
    } else {
      return Container();
    }
  }
  Widget _buildCurp() {
  if (_user.tipoPersona == 1 ) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: Center(
                      child: Text("CURP",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text("${ _user.curp }")))
            ],
          ),
          Divider()
        ],
      );
   } else {
      return Container();
    }
  }
Widget _buildBussinesName() {
    if (_user.tipoPersona == 2) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: Center(
                      child: Text("Razón social",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text("${ _user.razonSocial }")))
            ],
          ),
          Divider()
        ],
      );
    } else {
      return Container();
    }
  }
  Widget _buildRfc() {
    if (_user.tipoPersona == 2) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: Center(
                      child: Text("RFC",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text("${ _user.rfc }")))
            ],
          ),
          Divider()
        ],
      );
    } else {
      return Container();
    }
  // }
  // Widget _buildPrincipalCultivoEspecie() {
  //   if (_produccion.mainCrop != null) {
  //     return Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: <Widget>[
  //         Row(
  //           children: <Widget>[
  //             Expanded(
  //                 child: Center(
  //                     child: Text("Principal cultivo / especie",
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(fontWeight: FontWeight.bold)))),
  //             Expanded(child: Center(child: Text(_produccion.mainCrop.name)))
  //           ],
  //         ),
  //         Divider()
  //       ],
  //     );
  //   } else {
  //     return Container();
  //   }
  // }

  // Widget _buildRegimenHidrico() {
  //   if (_produccion.waterRegime != null) {
  //     return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
  //       Row(
  //         children: <Widget>[
  //           Expanded(
  //               child: Center(
  //                   child: Text("Régimen Hídrico",
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(fontWeight: FontWeight.bold)))),
  //           Expanded(child: Center(child: Text(_produccion.waterRegime.name)))
  //         ],
  //       ),
  //       Divider()
  //     ]);
  //   } else {
  //     return Container();
  //   }
  // }

  // Widget _buildTipoCultivo() {
  //   if (_produccion.typeCrop != null) {
  //     return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
  //       Row(
  //         children: <Widget>[
  //           Expanded(
  //               child: Center(
  //                   child: Text("Tipo de cultivo",
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(fontWeight: FontWeight.bold)))),
  //           Expanded(child: Center(child: Text(_produccion.typeCrop.name)))
  //         ],
  //       ),
  //       Divider()
  //     ]);
  //   } else {
  //     return Container();
  //   }
  // }

  // Widget _buildPrincipalProducto() {
  //   if (_produccion.mainProduct != null) {
  //     return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
  //       Row(
  //         children: <Widget>[
  //           Expanded(
  //               child: Center(
  //                   child: Text("Principal producto",
  //                       textAlign: TextAlign.center,
  //                       style: TextStyle(fontWeight: FontWeight.bold)))),
  //           Expanded(child: Center(child: Text(_produccion.mainProduct.name)))
  //         ],
  //       ),
  //       Divider()
  //     ]);
  //   } else {
  //     return Container();
  //   }
  }
}

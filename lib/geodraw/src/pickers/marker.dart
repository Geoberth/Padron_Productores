import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:siap/geodraw/src/map-markers/map-markers.dart';
import 'package:siap/livemap/livemap.dart';
import 'package:siap/geodraw/geodraw.dart';
import '../types.dart';

class _MarkerPickerState extends State<MarkerPicker> {
  _MarkerPickerState({@required this.callback});

  final AddMarkerCallback callback;

  LiveMapController liveMapController;
  GeoDrawController controller;
  FloatingActionButton fab;
  FloatingActionButton basefab;
  StreamSubscription _changefeed;

  @override
  void initState() {
    liveMapController = LiveMapController(mapController: MapController(),initMap: widget?.initPosition);
    controller = GeoDrawController(liveMapController: liveMapController);
    
    // if(widget.initPosition?.latitude != null  ){
      
    //   Marker marker = Marker(
    //         height: 100.0,
    //         width: 80.0,
    //         point: widget.initPosition,
    //         builder: (context) => BubbleMarker(
    //               bubbleColor: Colors.green,
    //               bubbleContentWidgetBuilder: (BuildContext context) {
    //                 return IconButton(
    //                   icon: Icon(Icons.delete),
    //                   onPressed: () {
    //                     liveMapController.namedMarkers.forEach((key, value) {
    //   if(key != 'livemarker') liveMapController.removeMarker(name: key);

    // });
    //   if (callback == null) {
    //   callback(context, widget.initPosition);
    // }
    // currentMapAssetType = null;
    //                   }
                         
    //                 );
    //               },
    //             ));
    //    controller.addMarkerOnTap(callback: callback);
    //    controller.liveMapController.addMarker(marker: marker, name: 'initMap');
    //   controller.addMarker(context: context, point: widget.initPosition);
    // }
    basefab = FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        controller.addMarkerOnTap(callback: callback);
        setState(() => fab = FloatingActionButton(
              backgroundColor: Colors.transparent,
              child:  Icon(Icons.gps_fixed),
              onPressed: () => null,
            ));
      },
    );
    fab = basefab;
    liveMapController.onReady.then((_) {
      _changefeed = liveMapController.changeFeed.listen((change) {
        if (change.name == "updateMarkers") {
          resetFab();
        }
      });
    });
    super.initState();
  }

  void resetFab() {
    // if (liveMapController.markers.length >= 2) {
    //   liveMapController.removeMarkersItem(position: 2);
    // }else{}
    
    
    setState(() => fab = basefab);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: DrawerMap(controller: controller),
      floatingActionButton: fab,
    );
  }

  @override
  void dispose() {
    liveMapController.dispose();
    _changefeed.cancel();
    super.dispose();
  }
}

/// A marker picker
class MarkerPicker extends StatefulWidget {
  /// The callback is optional
  MarkerPicker({@required this.callback,this.initPosition});

  /// The callback will run after the polygon is added
  final AddMarkerCallback callback;
  final LatLng initPosition;
  @override
  _MarkerPickerState createState() => _MarkerPickerState(callback: callback);
}

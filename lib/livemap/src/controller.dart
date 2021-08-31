import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:pedantic/pedantic.dart';
import 'package:rxdart/rxdart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:map_controller/map_controller.dart';
import 'package:siap/geodraw/src/map-markers/map-markers.dart';
import 'position_stream.dart';

/// The map controller
class LiveMapController extends StatefulMapController {
  /// Provide a [MapController]
  LiveMapController(
      {@required this.mapController,
      this.positionStream,
      this.positionStreamEnabled,
      this.initMap
      })
      : assert(mapController != null),
        super(mapController: mapController) {
    positionStreamEnabled = (initMap?.latitude != null)? false : positionStreamEnabled ?? true;
    // get a new position stream
    if (positionStreamEnabled) {
      positionStream = positionStream ?? initPositionStream();
    }
  if(initMap?.latitude != null ){
    Position position = new Position(latitude: initMap.latitude,longitude: initMap.longitude);
    updateLiveGeoMarkerFromPosition(position: position ,iconType: true);
  }else {
     Position position = new Position(latitude: 19.432777,longitude: 	-99.133217 );
    updateLiveGeoMarkerFromPosition(position: position ,iconType: false);
  }
    // _liveMarker = Marker(
    //   point: LatLng(initMap.latitude, initMap.longitude),
    //   width: 80.0,
    //   height: 80.0,
    //   builder: bubbleMarker);

    // subscribe to position stream
    onReady.then((_) {
      if (positionStreamEnabled) {
        _subscribeToPositionStream();
      }
      // fire the map is ready callback
      if (!_livemapReadyCompleter.isCompleted) {
        _livemapReadyCompleter.complete();
      }
    });
  }

  /// The Flutter Map [MapController]
  @override
  MapController mapController;

  /// The Geolocator position stream
  Stream<Position> positionStream;

  /// Enable or not the position stream
  bool positionStreamEnabled;

  LatLng initMap ;

  StreamSubscription<Position> _positionStreamSubscription;
  final Completer<Null> _livemapReadyCompleter = Completer<Null>();
  final _subject = PublishSubject<StatefulMapControllerStateChange>();

  /// On ready callback: this is fired when the contoller is ready
  Future<Null> get onLiveMapReady => _livemapReadyCompleter.future;

  /// Dispose the position stream subscription
  void dispose() {
    _subject.close();
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription.cancel();
    }
  }

  /// Autocenter state
  bool autoCenter = true;
  
  Marker _liveMarker ;
   

  /// Enable or disable autocenter
  Future<void> toggleAutoCenter() async {
    autoCenter = !autoCenter;
    if (autoCenter) unawaited(centerOnLiveMarker());
    //print("TOGGLE AUTOCENTER TO $autoCenter");
   // notify("toggleAutoCenter", autoCenter, toggleAutoCenter);
  }

  /// Updates the livemarker on the map from a Geolocator position
  Future<void> updateLiveGeoMarkerFromPosition(
      {@required Position position, bool iconType }) async {
    if (position == null) throw ArgumentError("position must not be null");
    //print("UPDATING LIVE MARKER FROM POS $position");
    LatLng point = LatLng(position.latitude, position.longitude);
    try {
      await removeMarker(name: "livemarker");
    } catch (e) {
      print("WARNING: livemap: can not remove livemarker from map");
    }
    Marker liveMarker = Marker(
        point: point,
        width: 80.0,
        height: 80.0,
        builder: ( iconType)? _liveMarkerWidgetBuilder2:_liveMarkerWidgetBuilder);
    _liveMarker = liveMarker;
    if( iconType ){
      await addMarker(marker: _liveMarker, name: "initMap");
    }else{
      await addMarker(marker: _liveMarker, name: "livemarker");
    }
    
  }

  /// Center the map on the live marker
  Future<void> centerOnLiveMarker() async {
    mapController.move(_liveMarker.point, mapController.zoom);
  }

  /// Center the map on a [Position]
  Future<void> centerOnPosition(Position position) async {
    //print("CENTER ON $position");
    LatLng _newCenter = LatLng(position.latitude, position.longitude);
    mapController.move(_newCenter, mapController.zoom);
    unawaited(centerOnPoint(_newCenter));
   // notify("center", _newCenter, centerOnPosition);
  }
static Widget _liveMarkerWidgetBuilder2(BuildContext _) {
    print("__liveMarkerWidgetBuilder");
    return Container(
      child: ImageIcon(AssetImage("assets/img/red-circle.png"),color: Colors.red,size:35.0),
    );
  }
  static Widget _liveMarkerWidgetBuilder(BuildContext _) {
    print("__liveMarkerWidgetBuilder");
    
    return Container(
      child: const Icon(
        Icons.directions,
        color: Colors.black,
      ),
    );
  }
  
  /// Toggle live position stream updates
  void togglePositionStreamSubscription({Stream<Position> newPositionStream}) {
    positionStreamEnabled = !positionStreamEnabled;
    //print("TOGGLE POSITION STREAM TO $positionStreamEnabled");
    if (!positionStreamEnabled) {
      //print("=====> LIVE MAP DISABLED");
      _positionStreamSubscription.cancel();
    } else {
      //print("=====> LIVE MAP ENABLED");
      newPositionStream = newPositionStream ?? initPositionStream();
      positionStream = newPositionStream;
      _subscribeToPositionStream();
    }
    //notify("positionStream", positionStreamEnabled,
    //    togglePositionStreamSubscription);
  }

  void _subscribeToPositionStream() {
    print('SUBSCRIBE TO NEW POSITION STREAM');
    
    _positionStreamSubscription = positionStream.take(2).listen((Position position) {
      _positionStreamCallbackAction(position);
    });
    
  }

  void _positionStreamCallbackAction(Position position) {
    print("POSITION UPDATE $position");
    updateLiveGeoMarkerFromPosition(position: position);
    if (autoCenter) centerOnPosition(position);
   // notify("currentPosition", LatLng(position.latitude, position.longitude),
    //    _positionStreamCallbackAction);
  }
}

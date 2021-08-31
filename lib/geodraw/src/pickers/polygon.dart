import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:load/load.dart';
import 'package:siap/livemap/livemap.dart';
import 'package:siap/geodraw/geodraw.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/repository/home/home_repository.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/ui/home/home_screen.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/ui/widgets/fab_bottom_app_bar_item.dart';
import 'package:siap/utils/ui_data.dart';
import '../types.dart';

class _PolygonPickerState extends State<PolygonPicker> {
  _PolygonPickerState({@required this.callback, @required this.sectorCode});
  final int sectorCode;
  final AddMapAssetCallback callback;
   UserModel _userModel = UserSingleton.instance.user;
  HomeRepository _homeRepository = HomeRepository();
  LiveMapController liveMapController;
  GeoDrawController controller;
  Widget status = const Text("");
  FABBottomAppBar fab;
  FABBottomAppBar basefab;
  FABBottomAppBarItem remove;
  FABBottomAppBarItem add;
  bool savePoly;
  bool changeIcon;
  @override
  void initState() {
    savePoly = false;
    changeIcon = false;

    liveMapController = LiveMapController(mapController: MapController());
    controller = GeoDrawController(liveMapController: liveMapController);
   
    remove = FABBottomAppBarItem(
            iconData: Icons.close,
            text: 'Limpiar',
            onPress: _cleanMap,
          );
    add = FABBottomAppBarItem(
            iconData:  Icons.add ,
            text:  'Agregar',
            onPress:  _add , 
          );
        basefab = FABBottomAppBar(
        centerItemText: "Guardar",
       centerTextStyle: TextStyle(color: (savePoly ) ? Colors.grey : UiData.colorPrimary, fontWeight: FontWeight.bold),
        notchedShape: CircularNotchedRectangle(),
        items: [
          remove,
         add
        
        ],
      );
    // basefab = FloatingActionButton(
    //   child: Icon(Icons.add),
    //   onPressed: () {
    //     setState(() {
    //       status = const Text("Tap to add polygon points");
    //       fab = FloatingActionButton(
    //         backgroundColor: Colors.red,
    //         child: Icon(Icons.save, color: Colors.white),
    //         onPressed: () {
    //           controller.finishDrawing(context: context, callback: callback);
    //           resetFab();
    //           setState(() => status = const Text(""));
    //         },
    //       );
    //     });
    //     controller.addPolygonOnTap();
    //   },
    // );
    fab = basefab;
    super.initState();
  }
  finishDrawing(){
    print("CurrentSerie");
    
    setState(() {
       controller.finishDrawing(context: context, callback: callback);
     resetFab();
     savePoly = true;
    });
    
     
  }
  _cleanMap(){
    
    liveMapController.namedPolygons.forEach((key, value) {
                value.offsets.clear();
                value.points.clear();
                //print();
              });
  }
  _add(){
    // setState(() {
    //   add =  FABBottomAppBarItem(
    //         iconData: Icons.save,
    //         text: 'Agregar',
    //         onPress: () {

    //           controller.finishDrawing(context: context, callback: callback);
    //           resetFab();
    //           setState(() { 
    //             savePoly = true;
    //             status = const Text("");});
    //         }
    //       );
            
    // });
    setState(() {
       savePoly = true;
      changeIcon =true ;
    });
   
    controller.addPolygonOnTap();
    
  }
  void resetFab() => setState(() => fab = basefab);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        DrawerMap(controller: controller),
        Positioned(child: status, bottom: 25.0, left: 15.0)
      ]),
      bottomNavigationBar: fab ,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: (savePoly == false ) ? null : _savePolygon, 
        child: Icon(Icons.check, color: Colors.white),
        backgroundColor: (savePoly == false) ? Colors.grey.withOpacity(0.8)   :  Colors.green ,
      )
    );
  }
   _savePolygon() async {
    try {
     
      showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
      List<Map<String, dynamic>> data = <Map<String, dynamic>>[];
      if(controller.currentSerie.length == 0 ||controller.currentSerie.length  == null ) {
         Future.delayed(Duration(seconds: 1)).then((_) { hideLoadingDialog(); });
        Flushbar(
        flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
        backgroundColor: Colors.red, leftBarIndicatorColor: Colors.red,
        isDismissible: true, duration: Duration(seconds: 8),
        icon: Icon(Icons.close,color: Colors.white,),
        titleText: Text("Mensaje",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
        messageText: Text("Selecciona un poligono ", style: TextStyle(color: Colors.white)),
      )..show(context);
      }else
      {
        controller.currentSerie.map((latLng) {
        data.add({"lat": latLng.latitude, "lng": latLng.longitude});
        }).toList();
      
      await _homeRepository.addParcela(userId: _userModel.id, item: jsonEncode(data), categoryId: TipoParcela.poligono, plotId: widget.sectorCode);  
       finishDrawing();
      Navigator.of(context).pop(true);
       hideLoadingDialog();
      }
      
    }catch(error) {
      Future.delayed(Duration(seconds: 1)).then((_) { hideLoadingDialog(); });
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
        backgroundColor: Colors.red, leftBarIndicatorColor: Colors.red,
        isDismissible: true, duration: Duration(seconds: 8),
        icon: Icon(Icons.close,color: Colors.white,),
        titleText: Text("Mensaje",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
        messageText: Text(error.toString(), style: TextStyle(color: Colors.white)),
      )..show(context);
    }finally {
      
    }
  }
  @override
  void dispose() {
    liveMapController.dispose();
    super.dispose();
  }
}

/// A polygon picker
class PolygonPicker extends StatefulWidget {
  /// The callback is optional
  PolygonPicker({@required this.callback,@required this.sectorCode});
  final int sectorCode;
  /// The callback will run after the polygon is added
  final AddMapAssetCallback callback;

  @override
  _PolygonPickerState createState() => _PolygonPickerState(callback: callback,sectorCode: sectorCode);
}

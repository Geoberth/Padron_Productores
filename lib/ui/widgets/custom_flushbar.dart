import 'package:flushbar/flushbar.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

enum FlushbarType { SUCCESS, DANGER }

class CustomFlushbar extends Flushbar{

  final String title;
  final String message;
  final FlushbarType flushbarType;

  CustomFlushbar({ this.title, @required this.message, @required this.flushbarType });

  Flushbar topBar() {
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: (flushbarType == FlushbarType.SUCCESS) ? Colors.green : Colors.red,
      leftBarIndicatorColor: (flushbarType == FlushbarType.SUCCESS) ? Colors.green : Colors.red,
      isDismissible: true,
      duration: Duration(seconds: 8),
      icon: Icon(Icons.close,color: Colors.white,),
      titleText: Text(title ?? "Mensaje", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
      messageText: Text(message, style: TextStyle(color: Colors.white)),
    );
  }
}
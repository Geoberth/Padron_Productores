import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(6.0)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitDualRing(
              color: Colors.white,
              size: 60.0,
            )
          ],
        ),
      ),
    );
  }
}

class CustomLoadingLocation extends StatelessWidget {
  String message;
  String newMessage = "activa tu ubicación gps";
  
  CustomLoadingLocation({ @required this.message});
  
  @override
  Widget build(BuildContext context) {
//Future.delayed(Duration(seconds: 6)).then((_) {  newMessage = "Activa tu ubicación gps";});

    return Container(

      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6.0)
        ),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
             message,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(
             newMessage,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 25,
            ),

            SpinKitDualRing(
              color: Colors.white,
              size: 40.0,
            ),
            SizedBox(height: 50.0,)
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Settings {

  static final isProduction = false;
  // Generic app info
  static final appName    = "Siap";
  static final appVersion = (isProduction == true) ? "1.0.0" : "1.0.0 - TS-0.0.8";

  // Api and Base URL Info
  //http://63.142.246.25 
  ///siap-v4/api
  ///http://63.142.246.25/siap-v4/api/users/map/
  static final String baseUrl = (isProduction == true) ? "https://padron.agricultura.gob.mx" : "http://63.142.246.25";
  static final String apiSegment = (isProduction == true) ? "/api" : "/siap-v4/api";
  static final String mapUrl =  (isProduction == true) ? "https://padron.agricultura.gob.mx" : "http://63.142.246.25/siap-v4/api/webview/map/";
  static const int connectTimeout = 80000;
  static const int receiveTimeout = 115000;

 
}

class Responsive {

  double inch;

  Responsive(BuildContext context) {
    final size  = MediaQuery.of(context).size;
    inch = math.sqrt(math.pow(size.width, 2) + math.pow(size.height, 2));
  }

  double ip(double percent) {
    return inch * percent /100;
  }

}
import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:device_info/device_info.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:siap/models/device/device_model.dart';
import 'package:siap/models/pdf/pdf_model.dart';
import 'package:siap/utils/settings.dart';

class UtilsRepository {
  
  Future<PdfModel> filePicker(GlobalKey<ScaffoldState> _scaffoldKey, String fileExtension, {int maxMBfileSize = 1}) async {
    try {
      
      final File file = await FilePicker.getFile(type: FileType.CUSTOM, fileExtension: fileExtension);
      if(!validateFileSize(maxMBfileSize, file)) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(duration: Duration(seconds: 8), content: Text("El archivo no puede ser mayor a ${maxMBfileSize}MB"), backgroundColor: Colors.red,));
        return null;
      }
      if(!validateFileExtension(fileExtension, file)) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(duration: Duration(seconds: 8), content: Text("El tipo de archivo debe tener la extensión .$fileExtension"), backgroundColor: Colors.red,));
        
        return null;
      }
      if(fileExtension == 'zip'){
      final bytes =  file.readAsBytesSync();
      final archive = ZipDecoder().decodeBytes(bytes);
      int count = 0;
      for (var i = 0; i < archive.length; i++) {
        var ext = archive[i].name.split('.');
        print(ext[1]);
        if( ext[1] == 'dbf') count++;
        if( ext[1] == 'shp') count++;
        if( ext[1] == 'shx') count++;
      }
      if(count < 3 ){
        _scaffoldKey.currentState.showSnackBar(SnackBar(duration: Duration(seconds: 8), content: Text("El archivo Shape (.$fileExtension) es invalido "), backgroundColor: Colors.red,));
        count = 0;
        return null;
      }
         
      }
      Uint8List bytes = await file.readAsBytes();
      List<String> path = file.toString().split("/");
      String name = path[path.length-1];
      return PdfModel(base64: convert.base64Encode(bytes), name: name, fl: file);
    } catch (e) {
      print(e.toString());
    }
  }

  bool validateFileExtension(String fileExtension, File file) {
    List<String> path = file.toString().split(".");
    String fileFormat = path[path.length-1];
    fileFormat = fileFormat.split('"')[0];  // We sure to remove " character at the end of string if exist.
    fileFormat = fileFormat.split("'")[0];  // We sure to remove ' character at the end of string if exist.
    print(fileFormat);
    print(fileExtension);
    if(fileFormat != fileExtension) {
      return false;
    }
    return true;
  }
 
  bool validateFileSize(int maxMBfileSize, File file) {
    int fileSizeBytes = File(file.resolveSymbolicLinksSync()).lengthSync();
    double fileSizeMB = (fileSizeBytes / (1e+6));
    if(fileSizeMB > maxMBfileSize) {
      return false;
    }
    return true;
  }

  Future<Device> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Device device; 
    String pushToken = await getToken();
    if(Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      device = Device(
        token: pushToken,
        platform: "android",
        appVersion: Settings.appVersion,
        version: androidInfo.version.release
      );
    }else {      
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      device = Device(        
        token: pushToken,
        platform: "ios",
        appVersion: Settings.appVersion,
        version: iosInfo.systemVersion
      );
    }
    return device;
  }

  Future<String> getToken() {
    return Future.delayed(Duration(seconds: 1)).then((val) => "firebase-token-dummy-123");
    // return _firebaseMessaging.getToken();
  }

}
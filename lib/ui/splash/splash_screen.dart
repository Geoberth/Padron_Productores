
import 'package:flutter/material.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/repository/offline-catalogos/offline_repository.dart';
import 'package:siap/repository/register/register_repository.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/utils/ui_data.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  RegisterRepository _registerRepository = RegisterRepository();
  CatalogosRepositoryOffline _offlineRepository = CatalogosRepositoryOffline();
  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  _checkStatus() async {
    final bool isSigedIn = await _registerRepository.isSignedIn();

    if (isSigedIn) {
      UserModel user = await _registerRepository.getUser();
      UserSingleton.instance.user = user;
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pushNamedAndRemoveUntil(UiData.routeHome, (e) => false);
    } else {
    /* SharedPreferences statusLoadOffline = await SharedPreferences.getInstance();
      final value = statusLoadOffline.getString("loadOfflineData");
      print("value ");
      print( value );
      if(  value == null ){
        print("Loading");
        await _offlineRepository.getLocalidadPart0();
        await _offlineRepository.getLocalidadPart1();
        await _offlineRepository.getLocalidadPart2();
        await _offlineRepository.getLocalidadPart3();
        await _offlineRepository.getLocalidadPart4();
        await _offlineRepository.getLocalidadPart5();
        await _offlineRepository.loadOfflineData();
      }else if( value == '1'){}*/


      await Future.delayed(Duration(seconds: 4));
         Navigator.of(context).pushNamedAndRemoveUntil(UiData.routeRequirement, (e) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 5.0,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Image.asset(UiData.imgLogoSiap, height: size.width * 0.6)
            ),
          )
        ],
      ),
    );
  }
}
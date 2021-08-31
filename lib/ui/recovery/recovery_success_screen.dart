import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:siap/utils/ui_data.dart';


class RecoverySuccessScreen extends StatelessWidget {
  final Map<String, dynamic> message;
  RecoverySuccessScreen({@required this.message});

  @override
  Widget build(BuildContext context) {    
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  Image.asset(UiData.imgLogoSiap, width: size.width * 0.9),
                  SizedBox(height: 40.0),
                  Icon(FontAwesomeIcons.envelopeOpenText, color: Colors.black, size: 120.0),
                  SizedBox(height: 40.0),
                  Text(message["title"], style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  SizedBox(height: 40.0),
                  Text(message["subtitle"] ?? '', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  SizedBox(height: 40.0),
                  Container(
                    margin: EdgeInsets.only(bottom: 30.0, top: 10.0, left: 20.0, right: 20.0),
                    width: size.width,
                    height: UiData.heightMainButtons,
                    child: RaisedButton(
                      color: Colors.black,
                      onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(UiData.routeLogin, (e) => false),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                      ),
                      child: Text("Continuar", style: TextStyle(color: Colors.white)),
                    )
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}
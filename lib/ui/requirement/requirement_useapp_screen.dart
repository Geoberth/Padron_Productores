import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:siap/utils/ui_data.dart';

class RequirementAppScreen extends StatefulWidget {
  @override
  _RequirementScreenState createState() => _RequirementScreenState();
}

class _RequirementScreenState extends State<RequirementAppScreen> {
  ScrollController _hideButtonController;

  var _isVisible;

  @override
  initState(){
    super.initState();
    _isVisible = true;
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener((){
      if(_hideButtonController.position.userScrollDirection == ScrollDirection.reverse){
        if(_isVisible == true) {
          setState((){
            _isVisible = false;
          });
        }
      } else {
        if(_hideButtonController.position.userScrollDirection == ScrollDirection.forward){
          if(_isVisible == false) {
            setState((){
              _isVisible = true;
            });
          }
        }
      }});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height - 100.0,
          child: SingleChildScrollView(
            controller: _hideButtonController,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Image.asset(UiData.imgLogoSiap)
                    ),
                  ),
                  Stack(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Padrón georreferenciado de productores del sector agroalimentario", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0), textAlign: TextAlign.center),
                          SizedBox(height: 20.0),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 15.0, color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  text: "¡Recuerda! "
                                ),
                                TextSpan(
                                  text: "Para poderlo realizar debes de tener presente lo siguiente."
                                )
                              ]
                            ),
                          ),
                          SizedBox(height: 30.0),
                         // Text("Persona Física", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)),
                          SizedBox(height: 5.0),
                          Text("✔ Recuerda activar tu ubicación gps"),
                          Text("✔ CURP/RFC"),
                          Text("✔ Identificación oficial en PDF 1MB"),
                          Text("✔ Comprobante de domicilio en PDF 1MB"),
                          Text("✔ Documento legal de propiedad en PDF 1MB"),
                          Text("✔ Documento de arrendatario en PDF 1MB"),
                          Text("✔ Archivos de georreferencia"),
                          Text("✔ Correo electrónico"),
                          Text("✔ Número de teléfono celular"),
                          
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: FloatingActionButton.extended(
          backgroundColor: UiData.colorPrimary,
          onPressed:_routeLogin ,
          label: Text("Enterado", style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.check_circle_outline, color: Colors.white),
        ),
      ),
    );
  }
  _routeLogin()async {
    
      Navigator.of(context).pushNamedAndRemoveUntil(UiData.routeHome, (e) => false);
    
  }
}
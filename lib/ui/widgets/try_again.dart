import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:siap/utils/ui_data.dart';

class TryAgain extends StatelessWidget {
  final Function onPressed;

  TryAgain({@required this.onPressed});

  @override
  Widget build(BuildContext context) {    
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(FontAwesomeIcons.exclamationTriangle, size: 100, color: UiData.colorPrimary.withOpacity(0.5)),
            SizedBox(height: 80.0),
            Text("No fue posible obtener la información", textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            Text("Por favor verifica tu conexión e intenta nuevamente.", textAlign: TextAlign.center),
            SizedBox(height: 20.0),
            RaisedButton(
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)
              ),
              onPressed: onPressed,
              child: Text("Intentar nuevamente", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
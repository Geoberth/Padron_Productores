import 'package:flutter/material.dart';
import 'package:siap/utils/ui_data.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: UiData.colorAppBar,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 20.0,
                  height: 5.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.green
                  ),
                ),
              ],
            ),
            Flexible(child: Image.asset(UiData.imgLogoSiap, width: 250))
          ],
        )
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHeaderText(size),
                SizedBox(height: 40.0),
                _buildButtonTipoPersona("Soy persona Física", 1),
                _buildButtonTipoPersona("Soy persona Moral", 2)
              ],
            ),
          ),
        )
      ),
    );
  }

  Widget _buildHeaderText(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Bienvenido', maxLines: 2, style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        SizedBox(height: 10.0,),
        Text('Por favor selecciona el tipo de persona que se registrará.')
      ],
    );
  }

  Widget _buildButtonTipoPersona(String title, int tipoPersona) {
    String route = (tipoPersona == 1) ? UiData.routeFormFisica : UiData.routeFormMoral;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => Navigator.of(context).pushNamed(route, arguments: tipoPersona),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(UiData.borderRadiusButton)),
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9), borderRadius: BorderRadius.circular(UiData.borderRadiusButton)),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                border: new Border(right: new BorderSide(width: 1.0, color: Colors.white24))
              ),
              child: Icon(Icons.radio_button_checked, color: Colors.white),
            ),
            title: Text(title,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0)
          ),
        ),
      ),
    );
  }

}

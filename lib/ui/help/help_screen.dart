import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/utils/settings.dart';
import 'package:siap/utils/ui_data.dart';

class HelpScreen extends StatelessWidget {

  final UserModel _user = UserSingleton.instance.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        elevation: 0.0,
        backgroundColor: UiData.colorAppBar,
        title: Image.asset(UiData.imgLogoSiap, width: UiData.widthAppBarLogo),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: true,
            elevation: 0.0,
            backgroundColor: UiData.colorAppBar,
            expandedHeight: 110.0,
            flexibleSpace: FlexibleSpaceBar(                
              background: Card(
                margin: EdgeInsets.all(16.0),
                child: ListTile(
                  leading: Icon(FontAwesomeIcons.infoCircle, size: 35.0, color: Colors.green),
                  title: Text("Hola ${_user.nombre?.toLowerCase() ?? 'bienvenido'}", maxLines: 2, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("¿Cómo podemos ayudarte?"),
                )
              ),
            ),
          ),
          SliverList(delegate: SliverChildListDelegate([
            ListTile(
              onTap: () => Navigator.of(context).pushNamed(UiData.routeHelpDetail, arguments: {"title": "Datos de contacto", "option": 1}),
              title: Text("Datos de contacto", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              trailing: Icon(Icons.arrow_forward_ios, size: 14.0),
            ),
            ListTile(
              onTap: () => Navigator.of(context).pushNamed(UiData.routeHelpDetail, arguments: {"title": "PADRÓN DE PRODUCTORES", "option": 2}),
              title: Text("Aviso de privacidad", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              trailing: Icon(Icons.arrow_forward_ios, size: 14.0),
            ),
          ])
          )
        ]
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
        child: Text(Settings.appVersion, style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
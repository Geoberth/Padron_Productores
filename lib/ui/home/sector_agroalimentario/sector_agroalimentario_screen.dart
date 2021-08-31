import 'package:flutter/material.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/utils/ui_data.dart';

class SectorAgroalimentarioScreen extends StatelessWidget {
  final UserModel _user = UserSingleton.instance.user;

  @override
  Widget build(BuildContext context) {
    for (var prod in _user.produccion) {
      print(prod.toJson());
    }
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
      body: Container(
        margin: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Sector Agroalimentario", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              Text("Selecciona a que sector agroalimentario pertenecerá tu georreferencia"),
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index){
                    return Divider();
                  },
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => Navigator.of(context).pop(_user.produccion[index].foodIndustry.code),
                      title: Text(_user.produccion[index]?.foodIndustry?.name ?? "No disponible"),
                      trailing: Icon(Icons.arrow_forward_ios, size: 14.0,),
                    );
                  },
                  itemCount: _user.produccion.length,
                ),
              )
            ],
          ),
      ),
    );
  }
}
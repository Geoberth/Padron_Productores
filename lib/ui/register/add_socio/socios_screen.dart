import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:siap/blocs/register/add_socio/add_socio_bloc.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/utils/ui_data.dart';
import 'package:siap/validators/general_validator.dart';

class SociosScreen extends StatefulWidget {
  final List<GrupoPersonaMoral> socios;

  SociosScreen({@required this.socios});
  @override
  _SociosScreenState createState() => _SociosScreenState();
}

class _SociosScreenState extends State<SociosScreen> {
  AddSocioBloc _addSocioBloc;

  @override
  void initState() {
    _addSocioBloc = BlocProvider.of<AddSocioBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          elevation: 0.0,
          backgroundColor: UiData.colorAppBar,
          title: Image.asset(UiData.imgLogoSiap, width: UiData.widthAppBarLogo),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Mis socios", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                Text("Agrega la información de tus socios morales", textAlign: TextAlign.center),
                StreamBuilder<List<GrupoPersonaMoral>>(
                  stream: _addSocioBloc.socios,
                  builder: (context, snapshot) {
                    int socioIndex = 0;
                    return Column(
                      children: (snapshot.hasData) ?
                      snapshot.data.map((socio) {
                        socio.tempIndex = socioIndex;
                        socioIndex++;
                        return ListTile(
                          leading: Icon(Icons.check_circle, color: UiData.colorPrimary),
                          title: Text(socio.nombre ?? "N/D"),
                          subtitle: Text(socio.curp ?? "N/D"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              /* (socio.id != null) ?  */IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed(UiData.routeAddSocio, arguments: socio );
                                },
                                icon: Icon(Icons.edit, color: Colors.blueAccent),
                              ) /* : Container() */,
                              IconButton(
                                onPressed: () {
                                  List<GrupoPersonaMoral> sociosTemp = snapshot.data;
                                  sociosTemp.remove(socio);
                                  _addSocioBloc.changeSocios(sociosTemp);
                                },
                                icon: Icon(Icons.delete_forever, color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      }).toList() : 
                      [Container()],
                    );
                  }
                ),
                SizedBox(height: 40.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: UiData.heightMainButtons - 10,
                        child: RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                          ),
                          color: Colors.black,
                          icon: Icon(Icons.plus_one, color: Colors.white),
                          label: Flexible(child: Text("Agregar", maxLines: 2, style: TextStyle(color: Colors.white))),
                          onPressed: _addSocio
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Container(
                        height: UiData.heightMainButtons - 10,
                        child: RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                          ),
                          color: UiData.colorPrimary,
                          icon: Icon(Icons.check, color: Colors.white),
                          label: Flexible(child: Text("Finalizar", style: TextStyle(color: Colors.white))),
                          onPressed: _complete
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addSocio() async {
    await Navigator.of(context).pushNamed(UiData.routeAddSocio);
  }

  void _complete() {
    Navigator.of(context).pop();
  }

}
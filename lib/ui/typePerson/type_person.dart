import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siap/blocs/login/login_bloc.dart';
import 'package:siap/models/sector_agroalimentario/sector_agroalimentario_model.dart';
import 'package:siap/models/signin/signin_model.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/repository/auth/auth_repository.dart';
import 'package:siap/repository/register/register_repository.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/utils/ui_data.dart';

class TypePerson extends StatefulWidget {
  @override
  _RecoveryScreenState createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<TypePerson> {
  
  LoginBloc _loginBloc = LoginBloc();
  TextEditingController _curpEditingCtrl = TextEditingController();
  TextEditingController _rfcEditingCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int selectedTypePerson = _loginBloc.tipoPersonaCtrl.value;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                    Image.asset(UiData.imgLogoSiap, width: size.width * 0.9),
                    SizedBox(height: 40.0),
                    
                    SizedBox(height: 40.0),
                    Text('Sin conexión a internet', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    SizedBox(height: 40.0),
                    Text('Hemos detectado que no tiene conexión a internet. Si desea continuar con su registro, seleccione el tipo de persona, de lo contrario presione Cancelar.' ?? '', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    SizedBox(height: 40.0),
                   _buildTipoPersona(size),
                   Row(
                    children: <Widget>[
                      Container(
                        width: 100.0,
                        height: UiData.heightMainButtons,
                        child: RaisedButton(
                          color: Colors.black,
                          onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(UiData.routeLogin, (e) => false),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                          ),
                          child: Text("Cancelar", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      SizedBox(width: 15.0), 
                     Expanded(
                        child: Container(
                          height: UiData.heightMainButtons,
                          child: RaisedButton(
                            color: UiData.colorPrimary,
                            onPressed:()=> _toHome(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                            ),
                            child: Text("Continuar", style: TextStyle(color: Colors.white)),
                          )
                        ),
                      ),
                    ])
                    
                     
                  ],
              ),
            ),
        ),
          ),
      ),
    );
  }
  Widget _buildTipoPersona(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      width: size.width,
      child: InputDecorator(
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Tipo de persona",
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        child: StreamBuilder<int>(
          stream: _loginBloc.tipoPersona,
          builder: (context, snapshot) {
            return DropdownButton<int>(
              underline: Container(),
              isExpanded: true,
              value: snapshot.data,
              items: [
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text("Persona Física"),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text("Persona Moral"),
                ),
              ],
              onChanged: (val) {
                FocusScope.of(context).requestFocus(FocusNode());
                if(_loginBloc.tipoPersonaCtrl.value != val) {
                  _loginBloc.changeTipoPersona(val);
                  _loginBloc.changeCurp(null);
                  _loginBloc.changeRfc(null);
                  _curpEditingCtrl.text = "";
                  _rfcEditingCtrl.text = "";
                  setState(() {});
                }
              },
              hint: Text("Selecciona una opción", style: TextStyle(color: Colors.black),
              ),
            );
          }
        )
      )
    );
  }
  void _toHome() async {
    int tipoPersona = _loginBloc.tipoPersonaCtrl.value;
    if(tipoPersona == null ) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.elasticOut,
        backgroundColor: Colors.red,
        leftBarIndicatorColor: Colors.red,
        isDismissible: true,
        duration: Duration(seconds: 8),
        icon: Icon(Icons.close,color: Colors.white,),
        titleText: Text("Mensaje",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
        messageText: Text("Selecciona tu tipo de usuario", style: TextStyle(color: Colors.white)),
      )..show(context);
    }else{
      try {

        UserMobile userMobile = UserMobile(
            tipoPersona: tipoPersona,
            curp: _loginBloc.curpCtrl.value,
            rfc: _loginBloc.rfcCtrl.value
        );
      RegisterRepository registerRepository = RegisterRepository();
      if (userMobile.tipoPersona == 1) {
        UserModel userModel = UserModel(tipoPersona: userMobile.tipoPersona,
            validacion: 0,
            produccion: [],
            filesPersons: _loadFilesPerson(),
            filesFoodIndustry: _loadFilesFoodIndustry());
        registerRepository.setUser(json.encode(userModel));
        UserSingleton.instance.user = userModel;
        await _loadSectorAgroalimentario();
        Navigator.of(context).pushNamedAndRemoveUntil(
            UiData.routeRequirementApp, (e) => false);
      } else {
        UserModel userModel = UserModel(tipoPersona: userMobile.tipoPersona,
            validacion: 0,
            produccion: [],
            filesPersons: _loadFilesPersonMoral(),
            filesFoodIndustry: _loadFilesFoodIndustry());
        registerRepository.setUser(json.encode(userModel));
        UserSingleton.instance.user = userModel;
        await _loadSectorAgroalimentario();
        Navigator.of(context).pushNamedAndRemoveUntil(
            UiData.routeRequirementApp, (e) => false);
      }
    }catch(e){
    Flushbar(
    flushbarPosition: FlushbarPosition.TOP,
    forwardAnimationCurve: Curves.elasticOut,
    backgroundColor: Colors.red,
    leftBarIndicatorColor: Colors.red,
    isDismissible: true,
    duration: Duration(seconds: 8),
    icon: Icon(Icons.close,color: Colors.white,),
    titleText: Text("Mensaje",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
    messageText: Text(e.toString(), style: TextStyle(color: Colors.white)),
    )..show(context);
    }

  }
    
  }
  _loadFilesFoodIndustry(){

    var filesFood =  [
            {
                "id": 1,
                "code": 1,
                "name": "Agrícola",
                "doc": [
                    {
                        "id": 3,
                        "name": "Documento Legal de Propiedad",
                        "num_files": 0,
                         "is_required": 1,
                        "fileId": null,
                        "file": null,
                        "plots_id": null
                    },
                    {
                        "id": 4,
                        "name": "Documento Arrendatario",
                        "num_files": 0,
                         "is_required": 0,
                        "fileId": null,
                        "file": null,
                        "plots_id": null
                    }
                ]
            },
            {
                "id": 2,
                "code": 2,
                "name": "Pecuario",
                "doc": [
                    {
                        "id": 5,
                        "name": "Formato de Inscripción al Padrón Ganadero Nacional (UPP)",
                        "num_files": 0,
                         "is_required": 0,
                        "fileId": null,
                        "file": null,
                        "plots_id": null
                    }
                ]
            },
            {
                "id": 3,
                "code": 3,
                "name": "Pesquero",
                "doc": [
                    {
                        "id": 6,
                        "name": "Permiso de pesca",
                        "num_files": 0,
                         "is_required": 0,
                        "fileId": null,
                        "file": null,
                        "plots_id": null
                    }
                ]
            },
            {
                "id": 4,
                "code": 4,
                "name": "Acuícola",
                "doc": [
                    {
                        "id": 6,
                        "name": "Permiso de pesca",
                        "num_files": 0,
                         "is_required": 0,
                        "fileId": null,
                        "file": null,
                        "plots_id": null
                    }
                ]
            }
        ];
      final  List<FilesFoodIndustry> res = filesFood.isNotEmpty ? filesFood.map((c) => FilesFoodIndustry.fromJson(c)).toList() : [];
      return res;
  }
  _loadFilesPersonMoral(){
     var filesPerson  = [
            {
                "id": 2,
                "name": "Comprobante de domicilio",
                "num_files": 1,
                "fileId": null,
                "file": null
            },
            {
                "id": 7,
                "name": "RFC",
                "num_files": 0,
                "fileId": null,
                "file": null
            },
            {
                "id": 8,
                "name": "Acta Constitutiva",
                "num_files": 0,
                "fileId": null,
                "file": null
            }
     ];
    final  List<FilesPersons> res = filesPerson.isNotEmpty ? filesPerson.map((c) => FilesPersons.fromJson(c)).toList() : [];
     
    return res;
  }
  _loadFilesPerson(){
    var filesPerson  = [{
                "id": 1,
                "name": "Credencial de elector",
                "num_files": 1,
                "fileId": null,
                "file": null
            },
            {
                "id": 2,
                "name": "Comprobante de domicilio",
                "num_files": 1,
                "fileId": null,
                "file": null
            }
        ];
    final  List<FilesPersons> res = filesPerson.isNotEmpty ? filesPerson.map((c) => FilesPersons.fromJson(c)).toList() : [];
     
    return res;
  }
  
   _loadSectorAgroalimentario() async {
     //\
      var sector = {
        "code": 200,
        "msg": "Éxito",
        "data": [
          {
            "code": 4,
            "name": "Acuícola",
            "files_required": 0,
            "validation": [
              {
                "id": 1,
                "type": 1,
                "label": "Principal cultivo",
                "show": false
              },
              {
                "id": 2,
                "type": 1,
                "label": "Principal especie",
                "show": true
              },
              {
                "id": 3,
                "type": 2,
                "label": "Principal producto",
                "show": false
              },
              {
                "id": 4,
                "type": 3,
                "label": "Regimen hidrico",
                "show": false
              },
              {
                "id": 5,
                "type": 4,
                "label": "Tipos de cultivos",
                "show": false
              },
              {
                "id": 6,
                "type": 5,
                "label": "Superficie (Ha)",
                "show": false
              },
              {
                "id": 7,
                "type": 6,
                "label": "Volumen de la producción (Ton) / (L)",
                "show": true
              },
              {
                "id": 8,
                "type": 7,
                "label": "Precio (\$)",
                "show": true
              },
              {
                "id": 9,
                "type": 8,
                "label": "Valor de la producción (\$)",
                "show": true
              }
            ]
          },
          {
            "code": 1,
            "name": "Agrícola",
            "files_required": 1,
            "validation": [
              {
                "id": 1,
                "type": 1,
                "label": "Principal cultivo",
                "show": true
              },
              {
                "id": 2,
                "type": 1,
                "label": "Principal especie",
                "show": false
              },
              {
                "id": 3,
                "type": 2,
                "label": "Principal producto",
                "show": false
              },
              {
                "id": 4,
                "type": 3,
                "label": "Regimen hidrico",
                "show": true
              },
              {
                "id": 5,
                "type": 4,
                "label": "Tipos de cultivos",
                "show": true
              },
              {
                "id": 6,
                "type": 5,
                "label": "Superficie (Ha)",
                "show": true
              },
              {
                "id": 7,
                "type": 6,
                "label": "Volumen de la producción (Ton) / (L)",
                "show": true
              },
              {
                "id": 8,
                "type": 7,
                "label": "Precio (\$)",
                "show": true
              },
              {
                "id": 9,
                "type": 8,
                "label": "Valor de la producción (\$)",
                "show": true
              }
            ]
          },
          {
            "code": 2,
            "name": "Pecuario",
            "files_required": 0,
            "validation": [
              {
                "id": 1,
                "type": 1,
                "label": "Principal cultivo",
                "show": false
              },
              {
                "id": 2,
                "type": 1,
                "label": "Principal especie",
                "show": true
              },
              {
                "id": 3,
                "type": 2,
                "label": "Principal producto",
                "show": true
              },
              {
                "id": 4,
                "type": 3,
                "label": "Regimen hidrico",
                "show": false
              },
              {
                "id": 5,
                "type": 4,
                "label": "Tipos de cultivos",
                "show": false
              },
              {
                "id": 6,
                "type": 5,
                "label": "Superficie (Ha)",
                "show": false
              },
              {
                "id": 7,
                "type": 6,
                "label": "Volumen de la producción (Ton) / (L)",
                "show": true
              },
              {
                "id": 8,
                "type": 7,
                "label": "Precio (\$)",
                "show": true
              },
              {
                "id": 9,
                "type": 8,
                "label": "Valor de la producción (\$)",
                "show": true
              }
            ]
          },
          {
            "code": 3,
            "name": "Pesquero",
            "files_required": 0,
            "validation": [
              {
                "id": 1,
                "type": 1,
                "label": "Principal cultivo",
                "show": false
              },
              {
                "id": 2,
                "type": 1,
                "label": "Principal especie",
                "show": true
              },
              {
                "id": 3,
                "type": 2,
                "label": "Principal producto",
                "show": false
              },
              {
                "id": 4,
                "type": 3,
                "label": "Regimen hidrico",
                "show": false
              },
              {
                "id": 5,
                "type": 4,
                "label": "Tipos de cultivos",
                "show": false
              },
              {
                "id": 6,
                "type": 5,
                "label": "Superficie (Ha)",
                "show": false
              },
              {
                "id": 7,
                "type": 6,
                "label": "Volumen de la producción (Ton) / (L)",
                "show": true
              },
              {
                "id": 8,
                "type": 7,
                "label": "Precio (\$)",
                "show": true
              },
              {
                "id": 9,
                "type": 8,
                "label": "Valor de la producción (\$)",
                "show": true
              }
            ]
          }
        ]
      };
SharedPreferences sectorAgroalimentario = await SharedPreferences.getInstance();
   String sector2 = jsonEncode(SectorAgroalimentarioModel.fromJson(sector));
   sectorAgroalimentario.setString('sectorAgroalimentario', sector2 );
    }
  @override
  void dispose() {
    _loginBloc.close();
    super.dispose();
  }

}
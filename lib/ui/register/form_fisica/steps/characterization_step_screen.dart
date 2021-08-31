import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:load/load.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:siap/blocs/register/fisica/characterization_step/characterization_step_bloc.dart';
import 'package:siap/models/generic/generic_model.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/offlineDB/DBProvider.dart';
import 'package:siap/repository/catalogos/catalogos_repository.dart';
import 'package:siap/repository/connectivity/check_conectivity.dart';
import 'package:siap/repository/home/home_repository.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/ui/widgets/custom_flushbar.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/ui/widgets/platform_message.dart';
import 'package:siap/ui/widgets/rounded_dropdown.dart';
import 'package:siap/utils/ui_data.dart';
import 'package:siap/validators/general_validator.dart';

class CharacterizationStepScreen extends StatefulWidget {
  final TabController tabController;
  CharacterizationStepScreen({@required this.tabController});
  @override
  _CharacterizationStepScreenState createState() => _CharacterizationStepScreenState();
}

class _CharacterizationStepScreenState extends State<CharacterizationStepScreen>  with AutomaticKeepAliveClientMixin {
  UserModel _userModel = UserSingleton.instance.user;
  CharacterizationStepBloc _characterizationStepBloc;
  final _formKeyStep3 = GlobalKey<FormState>();
  CatalogosRepository _catalogosRepository = CatalogosRepository();
  List<GenericData<String>> _discapacidades = [];
  List<GenericData<int>> _regimenPropiedades = [];
  List<GenericData<String>> _tiposAsociaciones = [];
  List<GenericData<String>> _nivelEstudiosList = [];
  List<GenericData<String>> _lenguasIndigenas = [];
  List<GenericData<String>> _pueblosEtnias = [];
  HomeRepository _homeRepository = HomeRepository();
    CheckConectivity _checkConectivity = CheckConectivity();
  var maskFormatterFecha = new MaskTextInputFormatter(mask: '####/##/##', filter: { "#": RegExp(r'[0-9]') });
  
  @override
  initState() {
    _characterizationStepBloc = BlocProvider.of<CharacterizationStepBloc>(context);
    super.initState();
    _initData();
  }

  _initData() async {
    await showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
    if ( await _checkConectivity.checkConnectivity() ) {
      try {
        if(_userModel.tipoPersona == 1 ){
            if(_userModel.curp != null )
              await _homeRepository.getParcelas(  curp: _userModel.curp);
          }else {
            if( _userModel.rfc != null)
            await _homeRepository.getParcelas2(  rfc: _userModel.rfc);
        }
        _tiposAsociaciones = await _catalogosRepository.getAsociacionCampesina();
        _discapacidades = await _catalogosRepository.getDiscapacidades();
        _regimenPropiedades = await _catalogosRepository.getRegimenPropiedad();
        _nivelEstudiosList = await _catalogosRepository.getNivelEstudios();
        _lenguasIndigenas = await _catalogosRepository.getLenguasIndigenas();
        _pueblosEtnias = await _catalogosRepository.getPueblosEtnias();
        setState(() {});
        _initSimpleDataForm();
      } catch(e) {
        print("error Caracteriacion");
        print(e.toString());
        CustomFlushbar(
          message: "No fue posible obtener la información, intenta más tarde.",
          flushbarType: FlushbarType.DANGER,
        )..show(context);
      } finally {
        hideLoadingDialog();
      }
    }else{
      try {
        _tiposAsociaciones = await DBProvider.db.getAllPeasantAssociation();
        _discapacidades = await DBProvider.db.getAllDisability();
        _regimenPropiedades = await DBProvider.db.getAllPropertyRegime();
        _regimenPropiedades.sort((a,b)=> a.name.toString().compareTo(b.name.toString()));
        _nivelEstudiosList = await DBProvider.db.getAllEducationLevel();
        _lenguasIndigenas = await DBProvider.db.getAllIndigenousLanguaje();
        _pueblosEtnias = await DBProvider.db.getAllEthnicGroup();
        setState(() {});
        _initSimpleDataForm();
      } catch(e) {
        CustomFlushbar(
          message: "No fue posible obtener la información, intenta más tarde.",
          flushbarType: FlushbarType.DANGER,
        )..show(context);
      } finally {
        Future.delayed(Duration(seconds: 1)).then((_) { hideLoadingDialog(); });
      }
    }

  }

  _initSimpleDataForm() {
    if(_userModel.tipoAsociacion != null) {
      _characterizationStepBloc.changeTipoAsociacion(_userModel.tipoAsociacion);
    }
    if(_userModel.regimenPropiedad != null) {
      _characterizationStepBloc.changeRegimenPropiedad(_userModel.regimenPropiedad);
    }
    if(_userModel.cuentaConDiscapacidad != null) {
      _characterizationStepBloc.changeCuentaDiscapacidad(_userModel.cuentaConDiscapacidad);
    }
    if(_userModel.tipoDiscapacidad != null) {
      _characterizationStepBloc.changeTipoDiscapacidad(_userModel.tipoDiscapacidad);
    }
    if(_userModel.nivelDeEstudios != null) {
      _characterizationStepBloc.changeNivelEstudios(_userModel.nivelDeEstudios);
    }
    if(_userModel.hablaEspanol != null) {
      _characterizationStepBloc.changeHablaEspanol(_userModel.hablaEspanol);
    }
    if(_userModel.hablaLenguaIndigena != null) {
      _characterizationStepBloc.changeHablaLenguaIndigena(_userModel.hablaLenguaIndigena);
    }
    if(_userModel.lenguaIndigena != null) {
      _characterizationStepBloc.changeLenguaIndigena(_userModel.lenguaIndigena);
    }
    if(_userModel.declaratoriaIndigena != null) {
      _characterizationStepBloc.changeDeclaratoriaIndigena(_userModel.declaratoriaIndigena);
    }
    if(_userModel.grupoEtnico != null) {
      _characterizationStepBloc.changePuebloEtnia(_userModel.grupoEtnico);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(16.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Datos de caracterización	', maxLines: 2, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            SizedBox(height: 10.0,),
            Text('Ingresa los siguientes datos.'),
            Form(
              key: _formKeyStep3,
              child: Column(
                children: <Widget>[
                  _buildTipoAsociacion(size),
                  _buildRegimenPropiedad(size),
                  SizedBox(height: 15.0),
                  _buildDiscapacidad(size),
                  SizedBox(height: 15.0),
                  _buildTipoDiscapacidad(size),
                  SizedBox(height: 15.0),
                  _buildNivelEstudios(size),
                  SizedBox(height: 15.0),
                  _buildHablaEspanol(size),
                  SizedBox(height: 15.0),
                  _buildHablaLenguaIndigena(size),
                  SizedBox(height: 15.0),
                  _buildLenguaIndigena(size),
                  SizedBox(height: 15.0),
                  _buildDeclaratoriaIndigena(size),
                  _buildPuebloEtnia(size),
                  SizedBox(height: 40.0),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 100.0,
                        height: UiData.heightMainButtons,
                        child: RaisedButton(
                          color: Colors.black,
                          onPressed: () => widget.tabController.animateTo(1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                          ),
                          child: Text("Atrás", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      SizedBox(width: 15.0),
                      Expanded(
                        child: Container(
                          height: UiData.heightMainButtons,
                          child: RaisedButton(
                            color: UiData.colorPrimary,
                            onPressed: () => _submit(3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                            ),
                            child: Text("Siguiente", style: TextStyle(color: Colors.white))
                          )
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildTipoAsociacion(Size size) {
    return Column(
      children: <Widget>[
        SizedBox(height: 15.0),
        Text("Asociación Campesina u Organización de Productores", style: TextStyle(color: Colors.grey[600], fontSize: 12.0)),
        RoundedDropdown(
          labelText: "",
          margin: EdgeInsets.only(bottom: 15.0),
          child: StreamBuilder<String>(
            stream: _characterizationStepBloc.tipoAsociacion,
            builder: (context, snapshot) {
              return DropdownButton<String>(
                underline: Container(),
                isExpanded: true,
                hint: Text("Selecciona una opción"),
                value: snapshot.data,
                items: _tiposAsociaciones.map((tipoAsociacion) {
                  return DropdownMenuItem<String>(
                    value: tipoAsociacion.code,
                    child: Text(tipoAsociacion.name, style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)),
                  );
                }).toList(),
                onChanged: (val) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _characterizationStepBloc.changeTipoAsociacion(val);
                },
              );
            }
          ),
        )
      ],
    );
  }

  Widget _buildRegimenPropiedad(Size size) {
    return StreamBuilder<int>(
        stream: _characterizationStepBloc.regimenPropiedad,
        builder: (context, snapshot) {
          return DropdownButtonFormField<int>(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Régimen de propiedad \*",
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
            ),
            validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
            // underline: Container(),
            isExpanded: true,
            value: snapshot.data,
            items: _regimenPropiedades.map((regimenPropiedad) {
              return DropdownMenuItem<int>(
                value: regimenPropiedad.code,
                child: Text(regimenPropiedad.name),
              );
            }).toList(),
            onChanged: (val) {
              FocusScope.of(context).requestFocus(FocusNode());
              _characterizationStepBloc.changeRegimenPropiedad(val);
            },
          );
        }
    );
  }

  Widget _buildDiscapacidad(Size size) {
    return StreamBuilder<String>(
        stream: _characterizationStepBloc.cuentaDiscapacidad,
        builder: (context, snapshot) {
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Cuenta con discapacidad \*",
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
            validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
            // underline: Container(),
            isExpanded: true,
            value: snapshot.data,
            items: [
              DropdownMenuItem<String>(
                value: "SI",
                child: Text("SI"),
              ),
              DropdownMenuItem<String>(
                value: "NO",
                child: Text("NO"),
              ),
            ],
            onChanged: (val) {
              FocusScope.of(context).requestFocus(FocusNode());
              _characterizationStepBloc.changeTipoDiscapacidad(null);
              _characterizationStepBloc.changeCuentaDiscapacidad(val);
            }
          );
        }
    );
  }

  Widget _buildTipoDiscapacidad(Size size) {
    return StreamBuilder<String>(
      stream: _characterizationStepBloc.cuentaDiscapacidad,
      builder: (context, snapshot) {
        if(snapshot.data == "SI") {
          return StreamBuilder<String>(
              stream: _characterizationStepBloc.tipoDiscapacidad,
              builder: (context, snapshot) {
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Tipo de discapacidad",
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                   // underline: Container(),
                  isExpanded: true,
                  value: snapshot.data,
                  items: _discapacidades.map((discapacidad) {
                    return DropdownMenuItem<String>(
                      value: discapacidad.code,
                      child: Text(discapacidad.name),
                    );
                  }).toList(),
                  onChanged: (val) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _characterizationStepBloc.changeTipoDiscapacidad(val);
                  },
                );
              }
          );
        }
        return Container();
      }
    );
  }

  Widget _buildNivelEstudios(Size size) {
    return StreamBuilder<String>(
        stream: _characterizationStepBloc.nivelEstudios,
        builder: (context, snapshot) {
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nivel de estudios \*",
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
            validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
            // underline: Container(),
            isExpanded: true,
            value: snapshot.data,
            items: _nivelEstudiosList.map((nivelEstudios) {
              return DropdownMenuItem<String>(
                value: nivelEstudios.code,
                child: Text(nivelEstudios.name),
              );
            }).toList(),
            onChanged: (val) {
              FocusScope.of(context).requestFocus(FocusNode());
              _characterizationStepBloc.changeNivelEstudios(val);
            },
          );
        }
    );
  }

  Widget _buildHablaEspanol(Size size) {
    return StreamBuilder<String>(
        stream: _characterizationStepBloc.hablaEspanol,
        builder: (context, snapshot) {
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Habla español \*",
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
            validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
            // underline: Container(),
            isExpanded: true,
            value: snapshot.data,
            items: [
              DropdownMenuItem<String>(
                value: "SI",
                child: Text("SI"),
              ),
              DropdownMenuItem<String>(
                value: "NO",
                child: Text("NO"),
              ),
            ],
            onChanged: (val) {
              FocusScope.of(context).requestFocus(FocusNode());
              _characterizationStepBloc.changeHablaEspanol(val);
            }
          );
        }
    );
  }

  Widget _buildHablaLenguaIndigena(Size size) {
    return StreamBuilder<String>(
        stream: _characterizationStepBloc.hablaLenguaIndigena,
        builder: (context, snapshot) {
          return DropdownButtonFormField<String>(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Habla alguna lengua indígena \*",
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
            validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
            // underline: Container(),
            isExpanded: true,
            value: snapshot.data,
            items: [
              DropdownMenuItem<String>(
                value: "SI",
                child: Text("SI"),
              ),
              DropdownMenuItem<String>(
                value: "NO",
                child: Text("NO"),
              ),
            ],
            onChanged: (val) {
              FocusScope.of(context).requestFocus(FocusNode());
              _characterizationStepBloc.changeLenguaIndigena(null);
              _characterizationStepBloc.changeDeclaratoriaIndigena(null);
              _characterizationStepBloc.changeHablaLenguaIndigena(val);
            }
          );
        }
    );
  }

  Widget _buildLenguaIndigena(Size size) {
    return StreamBuilder<String>(
      stream: _characterizationStepBloc.hablaLenguaIndigena,
      builder: (context, snapshot) {
        if(snapshot.data == "SI") {
          return  StreamBuilder<String>(
              stream: _characterizationStepBloc.lenguaIndigena,
              builder: (context, snapshot) {
                return DropdownButtonFormField<String>(
                  //underline: Container(),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                     labelText: "Lengua indígena",
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  isExpanded: true,
                  validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                  //hint: Text("Selecciona una opción"),
                  value: snapshot.data,
                  items: _lenguasIndigenas.map((lenguaIndigena) {
                    return DropdownMenuItem<String>(
                      value: lenguaIndigena.code,
                      child: Text(lenguaIndigena.name),
                    );
                  }).toList(),
                  onChanged: (val) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _characterizationStepBloc.changeLenguaIndigena(val);
                  },
                );
              }
            );
          
        }
        return Container();
      }
    );
  }

  Widget _buildDeclaratoriaIndigena(Size size) {
    return StreamBuilder<String>(
      stream: _characterizationStepBloc.hablaLenguaIndigena,
      builder: (context, snapshot) {
        if(snapshot.data == "SI") {
          return StreamBuilder<String>(
              stream: _characterizationStepBloc.declaratoriaIndigena,
              builder: (context, snapshot) {
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Declaratoria indígena",
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                  // underline: Container(),
                  isExpanded: true,
                  value: snapshot.data,
                  items: [
                    DropdownMenuItem<String>(
                      value: "SI",
                      child: Text("SI"),
                    ),
                    DropdownMenuItem<String>(
                      value: "NO",
                      child: Text("NO"),
                    ),
                  ],
                  onChanged: (val) {
                    print('Val $val ');
                    FocusScope.of(context).requestFocus(FocusNode());
                    _characterizationStepBloc.changePuebloEtnia(null);
                    _characterizationStepBloc.changeDeclaratoriaIndigena(val);
                  }
                );
              }
          );
        }
        return Container();
      }
    );
  }

  Widget _buildPuebloEtnia(Size size) {
    return StreamBuilder<String>(
      stream: _characterizationStepBloc.declaratoriaIndigena,
      builder: (context, snapshot) {
        if(snapshot.data == "SI") {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 15.0),
              Text("A qué pueblo indígena o Etnia Pertenece", style: TextStyle(color: Colors.grey[600], fontSize: 12.0)),
               StreamBuilder<String>(
                  stream: _characterizationStepBloc.puebloEtnia,
                  builder: (context, snapshot) {
                    return DropdownButtonFormField<String>(
                      //underline: Container(),
                      decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      //labelText: "Declaratoria indígena",
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                      isExpanded: true,
                      hint: Text("Selecciona una opción"),
                      value: snapshot.data,
                      validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                      items: _pueblosEtnias.map((puebloEtnia) {
                        return DropdownMenuItem<String>(
                          value: puebloEtnia.code,
                          child: Text(puebloEtnia.name),
                          
                        );
                      }).toList(),
                      onChanged: (val) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _characterizationStepBloc.changePuebloEtnia(val);
                      },
                    );
                  }
                )
              
            ],
          );
        }
        return Container();
      }
    );
  }

  _submit(int index) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKeyStep3.currentState.validate()) {
       widget.tabController.animateTo(index);
    } else {
      showDialog(
        builder: (context) => PlatformMessage(
          title: "Información incompleta",
          content: "Todos los datos son requeridos",
          okPressed: () => Navigator.of(context).pop()
        ), context: context
      );
    }
  }

  _resetStreamsForm() {
    /* _characterizationStepBloc.changeTipoAsociacion(null);
    _characterizationStepBloc.changeRegimenPropiedad(null);
    _characterizationStepBloc.changeCuentaDiscapacidad(null);
    _characterizationStepBloc.changeTipoDiscapacidad(null);
    _characterizationStepBloc.changeNivelEstudios(null);
    _characterizationStepBloc.changeHablaEspanol(null);
    _characterizationStepBloc.changeHablaLenguaIndigena(null);
    _characterizationStepBloc.changeLenguaIndigena(null);
    _characterizationStepBloc.changeDeclaratoriaIndigena(null);
    _characterizationStepBloc.changePuebloEtnia(null); */
  }

  @override
  void dispose() {
    _resetStreamsForm();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
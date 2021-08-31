import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:siap/repository/connectivity/check_conectivity.dart';
import 'package:load/load.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:siap/blocs/register/add_socio/add_socio_bloc.dart';
import 'package:siap/models/generic/generic_model.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/offlineDB/DBProvider.dart';
import 'package:siap/repository/catalogos/catalogos_repository.dart';
import 'package:siap/repository/home/home_repository.dart';
import 'package:siap/repository/register/register_repository.dart';
import 'package:siap/ui/register/widgets/catalogos_dropdown.dart';
import 'package:siap/ui/widgets/custom_flushbar.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/ui/widgets/platform_message.dart';
import 'package:siap/ui/widgets/rounded_dropdown.dart';
import 'package:siap/utils/ui_data.dart';
import 'package:siap/validators/decimal_formatter.dart';
import 'package:siap/validators/general_validator.dart';

class AddSocioScreen extends StatefulWidget {
  final GrupoPersonaMoral socio;

  const AddSocioScreen({Key key, this.socio}) : super(key: key);
  @override
  _AddSocioScreenState createState() => _AddSocioScreenState();
}

class _AddSocioScreenState extends State<AddSocioScreen> {
  bool _isValidForm = false;
  StreamSubscription<bool> _subscriptionSubmit;
  AddSocioBloc _addSocioBloc;
  CatalogosRepository _catalogosRepository = CatalogosRepository();
  CatalogosDropDown _catalogosDropDown = CatalogosDropDown();
  HomeRepository _homeRepository = HomeRepository();

  final _formKey = GlobalKey<FormState>();

  // List<GenericData<int>> _generos = [];
  List<GenericData<String>> _estados = [];
  List<GenericData<String>> _municipios = [];
  List<GenericData<String>> _localidades = [];
  List<GenericData<String>> _tiposDirecciones = [];
  List<GenericData<int>> _tiposVialidades = [];
  List<GenericData<int>> _tiposAsentamientos = [];
  List<GenericData<String>> _nacionalidades = [];
  List<GenericData<int>> _estadoCivilList = [];

  var maskFormatterFecha = new MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  TextEditingController _curpTextCtrl = TextEditingController();
  TextEditingController _rfcTextCtrl = TextEditingController();
  TextEditingController _homoclaveTextCtrl = TextEditingController();
  TextEditingController _nombreTextCtrl = TextEditingController();
  TextEditingController _apPaternoTextCtrl = TextEditingController();
  TextEditingController _apMaternoTextCtrl = TextEditingController();
  TextEditingController _fechaDeNacimientoTextCtrl = TextEditingController();
   CheckConectivity _checkConectivity = CheckConectivity();
  StreamSubscription<String> _subscriptionCurp;

  bool _validateCurp = false;
  @override
  void initState() {
    super.initState();
    _addSocioBloc = BlocProvider.of<AddSocioBloc>(context);
    _subscriptionSubmit = _addSocioBloc.submitValid.listen((valid) {
      _isValidForm = valid;
    });
    _subscriptionSubmit.onError((handleError) {
      _isValidForm = false;
      print("Handle error: ${handleError.toString()}");
    });
    _subscriptionCurp = _addSocioBloc.curp.listen((onData) async {
      print('EXECUTE LISTEN CURP');
      if (_validateCurp == true) {
        bool net =  await _checkConectivity.checkConnectivity();
        if (net ) {
          try {
            showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
            
            Map<String, dynamic> response = await RegisterRepository()
                .validateCurpWithRenapo(curp: onData, noValid: true);
            _fillRfc(response["rfc"]);
            _fillName(response["nombre"]);
            _fillApPaterno(response["appaterno"]);
            _fillApMaterno(response["apmaterno"]);
            _fillFechaNacimiento(response["fechaDeNacimiento"]);
          } catch (error) {
            _curpTextCtrl.text = "";
            _addSocioBloc.changeCurp("");
            _fillRfc("");
            _fillName("");
            _fillApPaterno("");
            _fillApMaterno("");
            _fillFechaNacimiento("");
            CustomFlushbar(
              message: error.toString(),
              flushbarType: FlushbarType.DANGER,
            ).topBar()
              ..show(context);
          } finally {
            hideLoadingDialog();
          }
        } else {
          //_fillRfc("");
          //_fillName("");
          //_fillApPaterno("");
          //_fillApMaterno("");
          //_fillFechaNacimiento("");
        }
      }
    });
    _initData();
  }

  _initData() async {
    if (await _checkConectivity.checkConnectivity()) {
      try {
        showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
        // _generos = await _catalogosRepository.getGeneros();
        _tiposDirecciones = await _catalogosRepository.getTipoDireccion();
        _tiposVialidades = await _catalogosRepository.getTipoVialidad();
        _tiposAsentamientos = await _catalogosRepository.getTipoAsentamiento();
        _estados = await _catalogosRepository.getEstados();
        _estadoCivilList = await _catalogosRepository.getEstadoCivil();
        _nacionalidades = await _catalogosRepository.getNacionalidades();
        if (widget.socio != null) {
          if (widget.socio.entidadFederativa != null) {
            _addSocioBloc.changeEstado(widget.socio.entidadFederativa);
            if (widget.socio.municipio != null) {
              _municipios = await _catalogosRepository.getMunicipios(
                  codigoEstado: widget.socio.entidadFederativa);
              _addSocioBloc.changeMunicipio(widget.socio.municipio);
              if (widget.socio.localidad != null) {
                _localidades = await _catalogosRepository.getLocalidades(
                    codigoEstado: widget.socio.entidadFederativa,
                    codigoMunicipio: widget.socio.municipio);
                _addSocioBloc.changeLocalidad(widget.socio.localidad);
              }
            }
          }
        }
        setState(() {});
        if (widget.socio != null) {
          _initSimpleDataForm(widget.socio);
        }else {
          Future.delayed(Duration(seconds: 1)).then((_) {
            _validateCurp = true;
          });
        }
      } catch (e) {
        print("Error add socio screen init data: ${e.toString()}");
        CustomFlushbar(
          message: "No fue posible obtener la información, intenta más tarde.",
          flushbarType: FlushbarType.DANGER,
        )..show(context);
      } finally {
        hideLoadingDialog();
      }
    } else {
      try {
        await showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
        // _generos = await _catalogosRepository.getGeneros();
        _tiposDirecciones = await DBProvider.db.getAllTypeAddress();
        _tiposVialidades = await DBProvider.db.getAllTypeRoad();
        _tiposVialidades
            .sort((a, b) => a.name.toString().compareTo(b.name.toString()));
        _tiposAsentamientos = await DBProvider.db.getAllSetElement();
        _tiposAsentamientos
            .sort((a, b) => a.name.toString().compareTo(b.name.toString()));
        _estados = await DBProvider.db.getAllFederalEntity();
        _estadoCivilList = await DBProvider.db.getAllStatusMarital();
        _estadoCivilList
            .sort((a, b) => a.name.toString().compareTo(b.name.toString()));
        _nacionalidades = await DBProvider.db.getAllNacionality();
        if (widget.socio != null) {
          if (widget.socio.entidadFederativa != null) {
            _addSocioBloc.changeEstado(widget.socio.entidadFederativa);
            if (widget.socio.municipio != null) {
              _municipios = await DBProvider.db.getAllMunicipalityByCode(
                  codigoEstado: widget.socio.entidadFederativa);
              _addSocioBloc.changeMunicipio(widget.socio.municipio);
              if (widget.socio.localidad != null) {
                _localidades = await DBProvider.db.getAllLocationByCode(
                    codigoEstado: widget.socio.entidadFederativa,
                    codigoMunicipio: widget.socio.municipio);
                _addSocioBloc.changeLocalidad(widget.socio.localidad);
              }
            }
          }
        }
        setState(() {});
        if (widget.socio != null) {
          _initSimpleDataForm(widget.socio);
        } else {
          Future.delayed(Duration(seconds: 1)).then((_) {
            _validateCurp = true;
          });
        }
      } catch (e) {
        print("Error add socio screen init data: ${e.toString()}");
        CustomFlushbar(
          message: "No fue posible obtener la información, intenta más tarde.",
          flushbarType: FlushbarType.DANGER,
        )..show(context);
      } finally {
        Future.delayed(Duration(seconds: 2)).then((_) {
          hideLoadingDialog();
        });
      }
    }
  }

  _initSimpleDataForm(GrupoPersonaMoral socio) {
    if (socio.email != null) {
      _addSocioBloc.changeEmail(socio.email);
    }
    if (socio.tipoDireccion != null) {
      _addSocioBloc.changeTipoDireccion(socio.tipoDireccion);
    }
    if (socio.tipoVialidad != null) {
      _addSocioBloc.changeTipoVialidad(socio.tipoVialidad);
    }
    if (socio.cp != null) {
      _addSocioBloc.changeCp(socio.cp);
    }
    if (socio.nombreVialidad != null) {
      _addSocioBloc.changeNombreVialidad(socio.nombreVialidad);
    }
    if (socio.noInterior != null) {
      _addSocioBloc.changeNoInterior(socio.noInterior);
    }
    if (socio.noExterior != null) {
      _addSocioBloc.changeNoExterior(socio.noExterior);
    }
    if (socio.tipoAsentamiento != null) {
      _addSocioBloc.changeTipoAsentamiento(socio.tipoAsentamiento);
    }
    if (socio.nombreAsentamiento != null) {
      _addSocioBloc.changeNombreAsentamiento(socio.nombreAsentamiento);
    }
    if (socio.curp != null) {
      _addSocioBloc.changeCurp(socio.curp);
      _curpTextCtrl.text = socio.curp;
    }
    if (socio.estadoCivil != null) {
      _addSocioBloc.changeEstadoCivil(socio.estadoCivil);
    }
    if (socio.nacionalidad != null) {
      _addSocioBloc.changeNacionalidad(socio.nacionalidad);
    }
    if (socio.noTel != null) {
      _addSocioBloc.changeNoTel(socio.noTel);
    }
    if (socio.homoclave != null) {
      _addSocioBloc.changeHomoclave(socio.homoclave);
      _homoclaveTextCtrl.text = socio.homoclave;
    }
    _fillRfc(socio.rfc);
    _fillName(socio.nombre);
    _fillApPaterno(socio.appaterno);
    _fillApMaterno(socio.apmaterno);
    _fillFechaNacimiento(socio.fechaDeNacimiento);
    Future.delayed(Duration(seconds: 1)).then((_) {
      _validateCurp = true;
    });
  }

  _fillRfc(String rfc) {
    if (rfc != null) {
      _addSocioBloc.changeRfc(rfc);
      _rfcTextCtrl.text = rfc;
    }
  }

  _fillName(String nombre) {
    if (nombre != null) {
      _addSocioBloc.changeNombre(nombre);
      _nombreTextCtrl.text = nombre;
    }
  }

  _fillApPaterno(String apPaterno) {
    if (apPaterno != null) {
      _addSocioBloc.changeApPaterno(apPaterno);
      _apPaternoTextCtrl.text = apPaterno;
    }
  }

  _fillApMaterno(String apMaterno) {
    if (apMaterno != null) {
      _addSocioBloc.changeApMaterno(apMaterno);
      _apMaternoTextCtrl.text = apMaterno;
    }
  }

  _fillFechaNacimiento(String fechaNacimiento) {
    if (fechaNacimiento != null) {
      _addSocioBloc.changeFechaNacimiento(fechaNacimiento);
      _fechaDeNacimientoTextCtrl.text = fechaNacimiento;
    }
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
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0.0,
            backgroundColor: UiData.colorAppBar,
            title:
                Image.asset(UiData.imgLogoSiap, width: UiData.widthAppBarLogo)),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Grupo de Personas Morales",
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5)),
                Text("Completa la siguiente información"),
                SizedBox(height: 20.0),
                Form(
                    key: _formKey,
                    child: Column(children: <Widget>[
                      StreamBuilder<String>(
                          stream: _addSocioBloc.curp,
                          builder: (context, snapshot) {
                            return TextFormField(
                              controller: _curpTextCtrl,
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(18),
                                UpperCaseTextInputFormatter()
                              ],
                              decoration: InputDecoration(
                                  labelText: "CURP \*", errorText: snapshot.error),
                              onChanged: _addSocioBloc.changeCurp,
                            );
                          }),
                      StreamBuilder<String>(
                          stream: _addSocioBloc.rfc,
                          builder: (context, snapshot) {
                            return TextFormField(
                              controller: _rfcTextCtrl,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                UpperCaseTextInputFormatter()
                              ],
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                  labelText: "RFC ", errorText: snapshot.error),
                              onChanged: _addSocioBloc.changeRfc,
                            );
                          }),
                      StreamBuilder<String>(
                          stream: _addSocioBloc.homoclaveCtrl,
                          builder: (context, snapshot) {
                            return TextFormField(
                              controller: _homoclaveTextCtrl,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3),
                                UpperCaseTextInputFormatter()
                              ],
                              textCapitalization: TextCapitalization.characters,
                              decoration: InputDecoration(
                                  labelText: "Homoclave",
                                  errorText: snapshot.error),
                              onChanged: (value){
                                if(value.length <= 3){
                                   _addSocioBloc.changeHomoclave(value);
                                }
                              },
                            );
                          }),
                      StreamBuilder<String>(
                          stream: _addSocioBloc.nombre,
                          builder: (context, snapshot) {
                            return TextFormField(
                              controller: _nombreTextCtrl,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                  labelText: "Nombre \*",
                                  errorText: snapshot.error),
                              onChanged: _addSocioBloc.changeNombre,
                            );
                          }),
                      StreamBuilder<String>(
                          stream: _addSocioBloc.apPaterno,
                          builder: (context, snapshot) {
                            return TextFormField(
                              controller: _apPaternoTextCtrl,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                  labelText: "Apellido paterno \*",
                                  errorText: snapshot.error),
                              onChanged: _addSocioBloc.changeApPaterno,
                            );
                          }),
                      StreamBuilder<String>(
                          stream: _addSocioBloc.apMaterno,
                          builder: (context, snapshot) {
                            return TextFormField(
                              controller: _apMaternoTextCtrl,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                  labelText: "Apellido materno",
                                  errorText: snapshot.error),
                              onChanged: _addSocioBloc.changeApMaterno,
                            );
                          }),
                     
                      _buildEstadoCivil(size),
                      _buildNacionalidad(size),
                       StreamBuilder<String>(
                          stream: _addSocioBloc.email,
                          builder: (context, snapshot) {
                            return TextFormField(
                              initialValue: widget.socio?.email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: "Correo electrónico \*",
                                  errorText: snapshot.error),
                              onChanged: _addSocioBloc.changeEmail,
                            );
                          }),
                      StreamBuilder<String>(
                          stream: _addSocioBloc.noTel,
                          builder: (context, snapshot) {
                            return TextFormField(
                              initialValue: widget.socio?.noTel,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10)
                              ],
                              decoration: InputDecoration(
                                  labelText: "No. teléfono \*",
                                  errorText: snapshot.error),
                              onChanged: _addSocioBloc.changeNoTel,
                            );
                          }),
                      StreamBuilder<String>(
                          stream: _addSocioBloc.fechaNacimiento,
                          builder: (context, snapshot) {
                            return TextFormField(
                              controller: _fechaDeNacimientoTextCtrl,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                maskFormatterFecha,
                                LengthLimitingTextInputFormatter(10)
                              ],
                              decoration: InputDecoration(
                                  labelText: "Fecha de nacimiento (DD/MM/AAAA) \*",
                                  errorText: snapshot.error),
                              onChanged: _addSocioBloc.changeFechaNacimiento,
                            );
                          }),
                      StreamBuilder<String>(
                          stream: _addSocioBloc.cp,
                          builder: (context, snapshot) {
                            return TextFormField(
                              initialValue: widget.socio?.cp,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(5)
                              ],
                              decoration: InputDecoration(
                                  labelText: "Código postal \*",
                                  errorText: snapshot.error),
                              onChanged: _addSocioBloc.changeCp,
                            );
                          }),
                      _buildEstados(size),
                      _buildMunicipios(size),
                      _buildLocalidad(size),
                      //_buildGenero(size),
                      _buildTipoAsentamiento(size),
                      StreamBuilder<String>(
                          stream: _addSocioBloc.nombreAsentamiento,
                          builder: (context, snapshot) {
                            return TextFormField(
                              initialValue: widget.socio?.nombreAsentamiento,
                              decoration: InputDecoration(
                                  labelText: "Nombre de asentamiento \*",
                                  errorText: snapshot.error),
                              onChanged: _addSocioBloc.changeNombreAsentamiento,
                            );
                          }),
                      _buildTipoDireccion(size),
                      _buildTipoVialidad(size),
                      StreamBuilder<String>(
                          stream: _addSocioBloc.nombreVialidad,
                          builder: (context, snapshot) {
                            return TextFormField(
                              initialValue: widget.socio?.nombreVialidad,
                              decoration: InputDecoration(
                                  labelText: "Nombre de vialidad \*",
                                  errorText: snapshot.error),
                              onChanged: _addSocioBloc.changeNombreVialidad,
                            );
                          }),
                      StreamBuilder<String>(
                          stream: _addSocioBloc.noExterior,
                          builder: (context, snapshot) {
                            return TextFormField(
                              initialValue: widget.socio?.noExterior,
                              decoration: InputDecoration(
                                  labelText: "No. exterior \*",
                                  errorText: snapshot.error),
                              onChanged: _addSocioBloc.changeNoExterior,
                            );
                          }),
                      StreamBuilder<String>(
                          stream: _addSocioBloc.noInterior,
                          builder: (context, snapshot) {
                            return TextFormField(
                              initialValue: widget.socio?.noInterior,
                              decoration: InputDecoration(
                                  labelText: "No. interior",
                                  errorText: snapshot.error),
                              onChanged: _addSocioBloc.changeNoInterior,
                            );
                          }),
                    ])),
                SizedBox(height: 20.0),
                 
                     Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: UiData.heightMainButtons - 10,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                          ),
                          color: Colors.black,
                          child: Text("Atrás", style: TextStyle(color: Colors.white)),
                          //icon: Icon(Icons.plus_one, color: Colors.white),
                         // label: Flexible(child: Text("Atrás", maxLines: 2, style: TextStyle(color: Colors.white))),
                          onPressed:() => Navigator.of(context).pop()
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    (widget.socio == null  )? 
                    Expanded(
                      child: Container(
                        height: UiData.heightMainButtons - 10,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                          ),
                          color: UiData.colorPrimary,
                          child:Text("Agregar",
                            style: TextStyle(color: Colors.white))
                            ,
                         // icon: Icon(Icons.check, color: Colors.white),
                         // label: Flexible(child: Text("Agregar", style: TextStyle(color: Colors.white))),
                          onPressed: (){

                            _submit(0);
                          }
                        ),
                      ),
                    ):
                    Expanded(
                      child: Container(
                        height: UiData.heightMainButtons - 10,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                          ),
                          color: UiData.colorPrimary,
                          child:Text("Actualizar",
                            style: TextStyle(color: Colors.white))
                            ,
                         // icon: Icon(Icons.check, color: Colors.white),
                         // label: Flexible(child: Text("Agregar", style: TextStyle(color: Colors.white))),
                          onPressed: (){

                            _submit(1);
                          }
                        ),
                      ),
                    )
                  ],
                )
                // Center(
                //   child: Container(
                //     margin: EdgeInsets.symmetric(vertical: 16.0),
                //     height: UiData.heightMainButtons - 10,
                //     child: RaisedButton(
                //         shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(
                //                 UiData.borderRadiusButton)),
                //         color: Colors.black,
                //         child: Text("Agregar",
                //             style: TextStyle(color: Colors.white)),
                //         onPressed: _submit),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* Widget _buildGenero(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      width: size.width,
      child: InputDecorator(
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Genero",
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        child: StreamBuilder<int>(
          stream: _addSocioBloc.genero,
          builder: (context, snapshot) {
            return DropdownButton<int>(
              underline: Container(),
              isExpanded: true,
              hint: Text("Selecciona una opción"),
              value: snapshot.data,
              items: _generos.map((genero) {
                return DropdownMenuItem<int>(
                  value: genero.code,
                  child: Text(genero.name),
                );
              }).toList(),
              onChanged: (val) {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _addSocioBloc.changeGenero(val);
              },
            );
          }
        )
      )
    );
  } */

  Widget _buildEstadoCivil(Size size) {
    return StreamBuilder<int>(
        stream: _addSocioBloc.estadoCivil,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RoundedDropdown(
                  labelText: "Estado civil \*",
                  child: DropdownButton<int>(
                    underline: Container(),
                    isExpanded: true,
                    hint: Text("Selecciona una opción"),
                    value: snapshot.data,
                    items: _estadoCivilList.map((estadoCivil) {
                      return DropdownMenuItem<int>(
                        value: estadoCivil.code,
                        child: Text(estadoCivil.name),
                      );
                    }).toList(),
                    onChanged: (val) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _addSocioBloc.changeEstadoCivil(val);
                    },
                  )),
              (snapshot.hasError)
                  ? Text(snapshot.error,
                      style: TextStyle(color: Colors.red[800], fontSize: 12.0))
                  : Container()
            ],
          );
        });
  }

  Widget _buildNacionalidad(Size size) {
    return StreamBuilder<String>(
        stream: _addSocioBloc.nacionalidad,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RoundedDropdown(
                  labelText: "Nacionalidad \*",
                  child: DropdownButton<String>(
                    underline: Container(),
                    isExpanded: true,
                    hint: Text("Selecciona una opción"),
                    value: snapshot.data,
                    items: _nacionalidades.map((nacionalidad) {
                      return DropdownMenuItem<String>(
                        value: nacionalidad.code,
                        child: Text(nacionalidad.name),
                      );
                    }).toList(),
                    onChanged: (val) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      _addSocioBloc.changeNacionalidad(val);
                    },
                  )),
              (snapshot.hasError)
                  ? Text(snapshot.error,
                      style: TextStyle(color: Colors.red[800], fontSize: 12.0))
                  : Container()
            ],
          );
        });
  }

  Widget _buildTipoDireccion(Size size) {
    return StreamBuilder<String>(
        stream: _addSocioBloc.tipoDireccion,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _catalogosDropDown.buildTipoDireccion(
                  size: size,
                  title: "Tipo de dirección \*",
                  value: snapshot.data,
                  tiposDirecciones: _tiposDirecciones,
                  onChanged: (val) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _addSocioBloc.changeTipoDireccion(val);
                  }),
              (snapshot.hasError)
                  ? Text(snapshot.error,
                      style: TextStyle(color: Colors.red[800], fontSize: 12.0))
                  : Container()
            ],
          );
        });
  }

  Widget _buildTipoVialidad(Size size) {
    return StreamBuilder<int>(
        stream: _addSocioBloc.tipoVialidad,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _catalogosDropDown.buildTipoVialidad(
                  size: size,
                  title: "Tipo de vialidad \*",
                  value: snapshot.data,
                  tiposVialidades: _tiposVialidades,
                  onChanged: (val) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _addSocioBloc.changeTipoVialidad(val);
                  }),
              (snapshot.hasError)
                  ? Text(snapshot.error,
                      style: TextStyle(color: Colors.red[800], fontSize: 12.0))
                  : Container()
            ],
          );
        });
  }

  Widget _buildTipoAsentamiento(Size size) {
    return StreamBuilder<int>(
        stream: _addSocioBloc.tipoAsentamiento,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _catalogosDropDown.buildTipoAsentamiento(
                  size: size,
                  title: "Tipo de asentamiento \*",
                  value: snapshot.data,
                  tiposAsentamientos: _tiposAsentamientos,
                  onChanged: (val) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _addSocioBloc.changeTipoAsentamiento(val);
                  }),
              (snapshot.hasError)
                  ? Text(snapshot.error,
                      style: TextStyle(color: Colors.red[800], fontSize: 12.0))
                  : Container()
            ],
          );
        });
  }

  Widget _buildEstados(Size size) {
    return StreamBuilder<String>(
        stream: _addSocioBloc.estado,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _catalogosDropDown.buildEstados(
                  size: size,
                  title: "Entidad federativa \*",
                  value: snapshot.data,
                  estados: _estados,
                  onChanged: (val) async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (await _checkConectivity.checkConnectivity()) {
                      showCustomLoadingWidget(CustomLoading(),
                          tapDismiss: false);
                      _addSocioBloc.changeMunicipio(null);
                      _municipios = await _catalogosRepository.getMunicipios(
                          codigoEstado: val);
                      hideLoadingDialog();
                      _addSocioBloc.changeEstado(val);
                      setState(() {});
                    } else {
                      showCustomLoadingWidget(CustomLoading(),
                          tapDismiss: false);
                      _addSocioBloc.changeMunicipio(null);
                      _municipios = await DBProvider.db
                          .getAllMunicipalityByCode(codigoEstado: val);
                      Future.delayed(Duration(seconds: 2)).then((_) {
                        hideLoadingDialog();
                      });
                      _addSocioBloc.changeEstado(val);
                      setState(() {});
                    }
                  }),
              (snapshot.hasError)
                  ? Text(snapshot.error,
                      style: TextStyle(color: Colors.red[800], fontSize: 12.0))
                  : Container()
            ],
          );
        });
  }

  Widget _buildMunicipios(Size size) {
    return StreamBuilder<String>(
        stream: _addSocioBloc.municipio,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _catalogosDropDown.buildMunicipios(
                  size: size,
                  title: "Municipio \*",
                  value: snapshot.data,
                  municipios: _municipios,
                  onChanged: (val) async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (await _checkConectivity.checkConnectivity()) {
                      showCustomLoadingWidget(CustomLoading(),
                          tapDismiss: false);
                      _addSocioBloc.changeLocalidad(null);
                      _localidades = await _catalogosRepository.getLocalidades(
                          codigoEstado: _addSocioBloc.estadoCtrl.value,
                          codigoMunicipio: val);
                      hideLoadingDialog();
                      _addSocioBloc.changeMunicipio(val);
                      setState(() {});
                    } else {
                      showCustomLoadingWidget(CustomLoading(),
                          tapDismiss: false);
                      _addSocioBloc.changeLocalidad(null);
                      _localidades = await DBProvider.db.getAllLocationByCode(
                          codigoEstado: _addSocioBloc.estadoCtrl.value,
                          codigoMunicipio: val);
                      Future.delayed(Duration(seconds: 2)).then((_) {
                        hideLoadingDialog();
                      });
                      _addSocioBloc.changeMunicipio(val);
                      setState(() {});
                    }
                  }),
              (snapshot.hasError)
                  ? Text(snapshot.error,
                      style: TextStyle(color: Colors.red[800], fontSize: 12.0))
                  : Container()
            ],
          );
        });
  }

  Widget _buildLocalidad(Size size) {
    return StreamBuilder<String>(
        stream: _addSocioBloc.localidad,
        builder: (context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _catalogosDropDown.buildLocalidad(
                  size: size,
                  title: "Localidad \*",
                  value: snapshot.data,
                  localidades: _localidades,
                  onChanged: (val) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _addSocioBloc.changeLocalidad(val);
                  }),
              (snapshot.hasError)
                  ? Text(snapshot.error,
                      style: TextStyle(color: Colors.red[800], fontSize: 12.0))
                  : Container()
            ],
          );
        });
  }

  void _submit(value) {
    if (_isValidForm == true) {
      _addSocio(updateOrSave:value );
    } else {
      //print(_addSocioBloc.nombreCtrl.value);
      _addSocioBloc.checkValidationsForm();
      showDialog(
          builder: (context) => PlatformMessage(
              title: "Información incompleta",
              content: "Todos los datos son requeridos",
              okPressed: () => Navigator.of(context).pop()), context: context);
    }
  }

  void _addSocio({@required int updateOrSave }) {
    GrupoPersonaMoral socio = GrupoPersonaMoral(
        id: widget.socio?.id,
        // sexo: _addSocioBloc.generoCtrl.value,
        email: _addSocioBloc.emailCtrl.value,
        tipoDireccion: _addSocioBloc.tipoDireccionCtrl.value,
        tipoVialidad: _addSocioBloc.tipoVialidadCtrl.value,
        cp: _addSocioBloc.cpCtrl.value,
        nombreVialidad: _addSocioBloc.nombreVialidadCtrl.value,
        noInterior: _addSocioBloc.noInteriorCtrl.value,
        noExterior: _addSocioBloc.noExteriorCtrl.value,
        tipoAsentamiento: _addSocioBloc.tipoAsentamientoCtrl.value,
        nombreAsentamiento: _addSocioBloc.nombreAsentamientoCtrl.value,
        entidadFederativa: _addSocioBloc.estadoCtrl.value,
        municipio: _addSocioBloc.municipioCtrl.value,
        localidad: _addSocioBloc.localidadCtrl.value,
        curp: _addSocioBloc.curpCtrl.value,
        rfc: _addSocioBloc.rfcCtrl.value,
        homoclave: _addSocioBloc.homoclaveCtrl.value,
        nombre: _addSocioBloc.nombreCtrl.value,
        appaterno: _addSocioBloc.apPaternoCtrl.value,
        apmaterno: _addSocioBloc.apMaternoCtrl.value,
        estadoCivil: _addSocioBloc.estadoCivilCtrl.value,
        nacionalidad: _addSocioBloc.nacionalidadCtrl.value,
        fechaDeNacimiento: _addSocioBloc.fechaNacimientoCtrl.value,
        noTel: _addSocioBloc.noTelCtrl.value);
    
    // print(socio.toJson());

    //FocusScope.of(context).requestFocus(FocusNode());
   
    //final validateCurp =  UserSingleton.instance.user.grupoPersonasMorales;
    
    // List<GrupoPersonaMoral> sociosTemp = _addSocioBloc.sociosCtrl.value
    //     .where((socio) => socio.id != widget.socio.id)
    //     .toList();
   
    var temp = 0;
    if(updateOrSave == 0 ) {
      for (var i = 0; i < _addSocioBloc.sociosCtrl.value.length; i++) {
      if (_addSocioBloc.sociosCtrl.value[i].curp == _addSocioBloc.curpCtrl.value) {
        temp++; 
      }else{
       
      }
    }
    }
    
    if(temp > 0 ){
        Flushbar(
                          flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
                          backgroundColor: Colors.red, leftBarIndicatorColor: Colors.red,
                          isDismissible: true, duration: Duration(seconds: 8),
                          icon: Icon(Icons.close,color: Colors.white,),
                          titleText: Text("Mensaje",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
                          messageText: Text("Curp: ${_addSocioBloc.curpCtrl.value} duplicado", style: TextStyle(color: Colors.white)),
                          )..show(context);
    }else{
       if (widget.socio != null) {
      /* if (widget.socio.id != null) {
        List<GrupoPersonaMoral> sociosTemp = _addSocioBloc.sociosCtrl.value.where((socio) => socio.id != widget.socio.id).toList();
        _addSocioBloc.changeSocios(sociosTemp);
        _addSocioBloc.changeSocios(_addSocioBloc.sociosCtrl.value..add(socio));
      } else { */
      _addSocioBloc.sociosCtrl.value[widget.socio.tempIndex] = socio;
      // }
    } else {
      _addSocioBloc.changeSocios(_addSocioBloc.sociosCtrl.value..add(socio));
    }
    _formKey.currentState.reset();
    Navigator.of(context).pop();
    }
    
  }

  @override
  dispose() {
    _curpTextCtrl.dispose();
    _rfcTextCtrl.dispose();
    _homoclaveTextCtrl.dispose();
    _nombreTextCtrl.dispose();
    _apPaternoTextCtrl.dispose();
    _apMaternoTextCtrl.dispose();
    _fechaDeNacimientoTextCtrl.dispose();
    _subscriptionCurp.cancel();
    _addSocioBloc.resetStreamsForm();
    super.dispose();
  }
}

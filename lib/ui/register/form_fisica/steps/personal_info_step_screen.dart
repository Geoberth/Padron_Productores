import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:load/load.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:siap/blocs/register/fisica/personal_info_step/personal_info_step_bloc.dart';
import 'package:siap/models/generic/generic_model.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/offlineDB/DBProvider.dart';
import 'package:siap/repository/auth/auth_repository.dart';
import 'package:siap/repository/catalogos/catalogos_repository.dart';
import 'package:siap/repository/connectivity/check_conectivity.dart';
import 'package:siap/repository/home/home_repository.dart';
import 'package:siap/repository/register/register_repository.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/ui/register/widgets/catalogos_dropdown.dart';
import 'package:siap/ui/widgets/platform_message.dart';
import 'package:siap/ui/widgets/rounded_dropdown.dart';
import 'package:siap/ui/widgets/custom_flushbar.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/ui/widgets/try_again.dart';
import 'package:siap/utils/ui_data.dart';
import 'package:siap/validators/decimal_formatter.dart';
import 'package:siap/validators/ine_validator.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
class PersonalInfoStepScreen extends StatefulWidget {
  final TabController tabController;
  PersonalInfoStepScreen({@required this.tabController});
  @override
  _PersonalInfoStepScreenState createState() => _PersonalInfoStepScreenState();
}

class _PersonalInfoStepScreenState extends State<PersonalInfoStepScreen> with AutomaticKeepAliveClientMixin {
  bool _isValidForm = false;
  StreamSubscription<bool> _subscriptionSubmit;
  UserModel _userModel = UserSingleton.instance.user;
  PersonalInfoStepBloc _personalInfoStepBloc;
  final _formKeyStep1 = GlobalKey<FormState>();
  CatalogosRepository _catalogosRepository = CatalogosRepository();
    CheckConectivity _checkConectivity = CheckConectivity();
  CatalogosDropDown _catalogosDropDown = CatalogosDropDown();
  List<GenericData<int>> _generos = [];
  List<GenericData<String>> _nacionalidades = [];
  List<GenericData<int>> _tiposTelefonos = [];
  List<GenericData<int>> _identificacionesOficiales = [];
  List<GenericData<int>> _estadoCivilList = [];

  var maskFormatterFecha = MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });

  TextEditingController _curpTextCtrl = TextEditingController();
  TextEditingController _rfcTextCtrl = TextEditingController();
  TextEditingController _homoclaveTextCtrl = TextEditingController();
  TextEditingController _nombreTextCtrl = TextEditingController();
  TextEditingController _apPaternoTextCtrl = TextEditingController();
  TextEditingController _apMaternoTextCtrl = TextEditingController();
  TextEditingController _fechaDeNacimientoTextCtrl = TextEditingController();
  TextEditingController _emailTextCtrl = TextEditingController();
  TextEditingController _noTelTextCtrl = TextEditingController();
  TextEditingController _celPhoneTextCtrl = TextEditingController();
  TextEditingController _folioIdentificacionTextCtrl = TextEditingController();
  RegisterRepository registerRepository = RegisterRepository();
  StreamSubscription<String> _subscriptionCurp;
  HomeRepository _homeRepository = HomeRepository();

  int label_identificacion;
  bool _validateCurp = false;
  bool _tryAgain = false;
  bool _enabledRfc = false;
  @override
  void initState()  {
    
    if(_userModel.id != null){
      updateInfo();
    }
    
  _personalInfoStepBloc = BlocProvider.of<PersonalInfoStepBloc>(context);
    super.initState();
    _subscriptionSubmit = _personalInfoStepBloc.submitValid.listen((valid) {
      _isValidForm = valid;
    });
    _subscriptionSubmit.onError((handleError) {
      _isValidForm = false;
      print("Handle error: ${handleError.toString()}");
    });
    _subscriptionCurp = _personalInfoStepBloc.curp.listen((onData) async {
      if (_validateCurp == true && onData != _userModel.curp) {
        if ( await _checkConectivity.checkConnectivity() ) {
        try {
          Map<String, dynamic> response = await RegisterRepository().validateCurpWithRenapo(curp: onData);
          _fillName(response["nombre"]);
          _fillApPaterno(response["appaterno"]);
          _fillApMaterno(response["apmaterno"]);
          _fillFechaNacimiento(response["fechaDeNacimiento"]);
        } catch(error) {
          _curpTextCtrl.text = _userModel.curp;
          _personalInfoStepBloc.changeCurp(_userModel.curp);
          CustomFlushbar(
            message: error.toString(),
            flushbarType: FlushbarType.DANGER,
          ).topBar()..show(context);
        } finally {
          
        }
        }else{
          _fillName("");
          _fillApPaterno("");
          _fillApMaterno("");
          _fillFechaNacimiento("");
          print(("Hello"));
          
        }
        
      }
    });
    _initData();
  }
  updateInfo() async {
    //actualizar informacion
    
      UserSingleton.instance.user =  await registerRepository.getUserData(userId: _userModel.id);
      _userModel = UserSingleton.instance.user;
    
  }
  @override
  void dispose() {
    _curpTextCtrl.dispose();
    _rfcTextCtrl.dispose();
    _homoclaveTextCtrl.dispose();
    _nombreTextCtrl.dispose();
    _apPaternoTextCtrl.dispose();
    _apMaternoTextCtrl.dispose();
    _fechaDeNacimientoTextCtrl.dispose();
    _emailTextCtrl.dispose();
    _noTelTextCtrl.dispose();
    _celPhoneTextCtrl.dispose();
    _folioIdentificacionTextCtrl.dispose();
    _subscriptionCurp.cancel();
    _subscriptionSubmit.cancel();
    super.dispose();
  }

  _initData() async {
     await showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
    if ( await _checkConectivity.checkConnectivity() ) {
      print('Online-Mode');
      try {
        
       if(_userModel.tipoPersona == 1 ){
            if(_userModel.curp != null )
              await _homeRepository.getParcelas(  curp: _userModel.curp);
          }else {
            if( _userModel.rfc != null)
            await _homeRepository.getParcelas2(  rfc: _userModel.rfc);
        }
        _generos = await _catalogosRepository.getGeneros();
        _nacionalidades = await _catalogosRepository.getNacionalidades();
        _tiposTelefonos = await _catalogosRepository.getTipoTelefono();
        _identificacionesOficiales =  await _catalogosRepository.getIdentificacionOficial();
        _estadoCivilList =  await _catalogosRepository.getEstadoCivil();
        setState(() {});
        _initSimpleDataForm();
      } catch(e) {
        CustomFlushbar(
          message: "No fue posible obtener la información, intenta más tarde.",
          flushbarType: FlushbarType.DANGER,
        )..show(context);
      } finally {
        hideLoadingDialog();
      }
    }else{
      print('Offline-Mode');
      
      try{
      
        _generos = await DBProvider.db.getAllGender();
        _nacionalidades = await DBProvider.db.getAllNacionality();
        _tiposTelefonos = await DBProvider.db.getAllTypePhone();
         _tiposTelefonos.sort((a,b)=> a.name.toString().compareTo(b.name.toString()));
        _identificacionesOficiales = await DBProvider.db.getAllIndentification();
        _estadoCivilList = await DBProvider.db.getAllStatusMarital();
       _estadoCivilList.sort((a,b)=> a.name.toString().compareTo(b.name.toString()));
        setState(() {});
        _initSimpleDataForm();

      } catch(e){
        print("Error Offline - Mode ");
        print(e);
        CustomFlushbar(

          message: "No fue posible obtener informacion del dispositivo, intenta más tarde.",
          flushbarType: FlushbarType.DANGER,
        )..show(context);
      } finally {
        Future.delayed(Duration(seconds: 2 )).then((_) { hideLoadingDialog(); });
      }
    }

  }

  _initSimpleDataForm() {
    if(_userModel.curp != null) {
      _personalInfoStepBloc.changeCurp(_userModel.curp);
      _curpTextCtrl.text = _userModel.curp;
    }
    if(_userModel.rfc != null) {
      _enabledRfc = false;
      _personalInfoStepBloc.changeRfc(_userModel.rfc);
      _rfcTextCtrl.text = _userModel.rfc;
    }else {
      _enabledRfc = true;
    }
    if(_userModel.homoclave != null) {
      _personalInfoStepBloc.changeHomoclave(_userModel.homoclave);
      _homoclaveTextCtrl.text = _userModel.homoclave;
    }
    if(_userModel.sexo != null) {
      _personalInfoStepBloc.changeGenero(_userModel.sexo);
    }
    _fillName(_userModel.nombre);
    _fillApPaterno(_userModel.appaterno);
    _fillApMaterno(_userModel.apmaterno);
    if(_userModel.estadoCivil != null) {
      _personalInfoStepBloc.changeEstadoCivil(_userModel.estadoCivil);
    }
    if(_userModel.nacionalidad != null) {
      _personalInfoStepBloc.changeNacionalidad(_userModel.nacionalidad);
    }
    _fillFechaNacimiento(_userModel.fechaDeNacimiento);
    if(_userModel.email != null) {
      _personalInfoStepBloc.changeEmail(_userModel.email);
      _emailTextCtrl.text = _userModel.email;
    }
    if(_userModel.celPhone != null) {
      _personalInfoStepBloc.changeCelPhone(_userModel.celPhone);
      _celPhoneTextCtrl.text = _userModel.celPhone;
    }
    if(_userModel.tipoTel != null) {
      _personalInfoStepBloc.changeTipoTel(_userModel.tipoTel);
    }
    if(_userModel.noTel != null) {
      _personalInfoStepBloc.changeNoTel(_userModel.noTel);
      _noTelTextCtrl.text = _userModel.noTel;
    }
    if(_userModel.identificacionOficialVigente != null) {
      _personalInfoStepBloc.changeIdentificacionOficial(_userModel.identificacionOficialVigente);
    }
    if(_userModel.folioIdentificacion != null) {
      _personalInfoStepBloc.changeFolioIdentificacion((
        IdentificacionVM(valor: _userModel.folioIdentificacion,
        tipoIdentificacion: _userModel.identificacionOficialVigente)
      ));
      _folioIdentificacionTextCtrl.text = _userModel.folioIdentificacion;
    }
    Future.delayed(Duration(seconds: 1)).then((_) {
      _validateCurp = true;
    });
  }

  _fillName(String nombre) {
    if(nombre != null) {
      _personalInfoStepBloc.changeNombre(nombre);
      _nombreTextCtrl.text = nombre;
    }
  }

  _fillApPaterno(String apPaterno) {
    if(apPaterno != null) {
      _personalInfoStepBloc.changeApPaterno(apPaterno);
      _apPaternoTextCtrl.text = apPaterno;
    }
  }

  _fillApMaterno(String apMaterno) {
    if(apMaterno != null) {
      _personalInfoStepBloc.changeApMaterno(apMaterno);
      _apMaternoTextCtrl.text = apMaterno;
    }
  }

  _fillFechaNacimiento(String fechaNacimiento) {
    if(fechaNacimiento != null) {
      _personalInfoStepBloc.changeFechaNacimiento(fechaNacimiento);
      _fechaDeNacimientoTextCtrl.text = fechaNacimiento;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: (_tryAgain == true) ? TryAgain(onPressed: _initData) : _buildScreen(size),
    );
  }

  Widget _buildScreen(Size size) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(16.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Registro persona física', maxLines: 2, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            SizedBox(height: 10.0,),
            Text('Ingresa los siguientes datos.'),
            Form(
              key: _formKeyStep1,
              child: Column(
                children: <Widget>[
                  StreamBuilder<String>(
                    stream: _personalInfoStepBloc.curp,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _curpTextCtrl,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [LengthLimitingTextInputFormatter(18), UpperCaseTextInputFormatter()],
                        decoration: InputDecoration(
                          labelText: "CURP \*",
                          errorText: snapshot.error
                        ),
                        validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                        onChanged: (val) {
                          _personalInfoStepBloc.changeCurp(val);
                        },
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _personalInfoStepBloc.rfc,
                    builder: (context, snapshot) {
                      return TextFormField(
                        enabled: _enabledRfc,
                        controller: _rfcTextCtrl,
                        inputFormatters: [LengthLimitingTextInputFormatter(10), UpperCaseTextInputFormatter()],
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: "RFC \*",
                          errorText: snapshot.error
                        ),
                        // autovalidate: true,
                        validator: (value) {
                          print(value);
                          return (  value == null || value.isEmpty) ? 'Campo requerido' :null;
                        },
                        onChanged: (value){
                             if(value.length <=10 ){
                               _personalInfoStepBloc.changeRfc(value);
                           }
                           
                         
                        }
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _personalInfoStepBloc.homoclaveCtrl,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _homoclaveTextCtrl,
                        inputFormatters: [LengthLimitingTextInputFormatter(3), UpperCaseTextInputFormatter()],
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: "Homoclave",
                          errorText: snapshot.error
                        ),
                       // validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                        onChanged: (value){
                          if(value.length <= 3){
                            _personalInfoStepBloc.changeHomoclave(value);
                          }
                        },
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _personalInfoStepBloc.nombre,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _nombreTextCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: "Nombre \*",
                          errorText: snapshot.error
                        ),
                        validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                        onChanged: _personalInfoStepBloc.changeNombre,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _personalInfoStepBloc.apPaterno,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _apPaternoTextCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: "Apellido paterno \*",
                          errorText: snapshot.error
                        ),
                        validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                        onChanged: _personalInfoStepBloc.changeApPaterno,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _personalInfoStepBloc.apMaterno,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _apMaternoTextCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: "Apellido materno",
                         // errorText: snapshot.error
                        ),
                        onChanged: _personalInfoStepBloc.changeApMaterno,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _personalInfoStepBloc.fechaNacimiento,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _fechaDeNacimientoTextCtrl,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [maskFormatterFecha, LengthLimitingTextInputFormatter(10)],
                        decoration: InputDecoration(
                          labelText: "Fecha de nacimiento \* (DD/MM/AAAA)",
                          errorText: snapshot.error
                        ),
                        validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                        onChanged: _personalInfoStepBloc.changeFechaNacimiento,
                      );
                    }
                  ),
                  SizedBox(height: 15.0),
                  _buildGenero(size),
                  SizedBox(height: 15.0),
                  _buildEstadoCivil(size),
                  SizedBox(height: 15.0),
                  _buildNacionalidad(size),
                  SizedBox(height: 15.0),
                  _buildIdentification(size),
                StreamBuilder<int>(
                    stream: _personalInfoStepBloc.identificacionOficial,
                    builder: (context, snapshot1) {

                      return  StreamBuilder<String>(
                          stream: _personalInfoStepBloc.folioIdentificacion,
                          builder: (context, snapshot) {
                            return TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              inputFormatters:( _personalInfoStepBloc.identificacionOficialCtrl.value == 1)?  [LengthLimitingTextInputFormatter(18)] :  [LengthLimitingTextInputFormatter(10)] ,
                              controller: _folioIdentificacionTextCtrl,
                              decoration: InputDecoration(
                                  labelText: ( _personalInfoStepBloc.identificacionOficialCtrl.value == 1)?"Clave de elector \*" :"Número de pasaporte \*",
                                  errorText: snapshot.error
                              ),
                              validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                              onChanged: (val) {
                                _personalInfoStepBloc.changeFolioIdentificacion(
                                    IdentificacionVM(valor: val,
                                        tipoIdentificacion: _personalInfoStepBloc.identificacionOficialCtrl.value)
                                );
                              },
                            );
                          }
                      );
                    }
                ),

                  StreamBuilder<String>(
                    stream: _personalInfoStepBloc.email,
                    builder: (context, snapshot) {
                      return TextFormField(
                        enabled: (_userModel.email != null )?false:true,
                        controller: _emailTextCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Correo electrónico \*",
                          errorText: snapshot.error
                        ),
                        validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                        onChanged: _personalInfoStepBloc.changeEmail,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _personalInfoStepBloc.celPhone,
                    builder: (context, snapshot) {
                      return TextFormField(
                        enabled: (_userModel.celPhone != null )?false:true,
                        controller: _celPhoneTextCtrl,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                        decoration: InputDecoration(
                          labelText: "Teléfono celular",
                          errorText: snapshot.error
                        ),
                        validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                        onChanged:(value){
                           if(value.length <=10 ){
                              _personalInfoStepBloc.changeCelPhone(value);
                           }
                        }
                      );
                    }
                  ),
                  _buildTipoTel(size),
                  StreamBuilder<String>(
                    stream: _personalInfoStepBloc.noTel,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _noTelTextCtrl,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                        decoration: InputDecoration(
                          labelText: "No. Teléfono \*",
                          errorText: snapshot.error
                        ),
                        validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                        onChanged:(value){
                          
                          if(value.length <= 10){
                            print('onCHanged $value ');
                            _personalInfoStepBloc.changeNoTel(value);
                          }
                            
                          
                          
                        }
                      );
                    }
                  ),
                  SizedBox(height: 40.0),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 100.0,
                        height: UiData.heightMainButtons,
                        child: RaisedButton(
                          color: Colors.black,
                          onPressed: () => Navigator.of(context).pop(),
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
                            onPressed: () => _submit(1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                            ),
                            child: Text("Siguiente", style: TextStyle(color: Colors.white)),
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
    );
  }

  Widget _buildGenero(Size size) {
    return  StreamBuilder<int>(
        stream: _personalInfoStepBloc.genero,
        builder: (context, snapshot) {
          return DropdownButtonFormField<int>(
           // underline: Container(),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Sexo \*",
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
            ),
            isExpanded: true,
             validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
           // hint: Text("Selecciona una opción"),
            value: snapshot.data,
            items: _generos.map((genero) {
              return DropdownMenuItem<int>(
                value: genero.code,
                child: Text(genero.name),
              );
            }).toList(),
            onChanged: (val) {
                FocusScope.of(context).requestFocus(FocusNode());
                _personalInfoStepBloc.changeGenero(val);
            },
          );
        }
      );
    
  }

  Widget _buildEstadoCivil(Size size) {
    //Estado civil
    return StreamBuilder<int>(
        stream: _personalInfoStepBloc.estadoCivil,
        builder: (context, snapshot) {
          return DropdownButtonFormField<int>(
           // underline: Container(),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Estado civil \*",
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
            ),
            isExpanded: true,
            validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
            //hint: Text("Selecciona una opción"),
            value: snapshot.data,
            items: _estadoCivilList.map((estadoCivil) {
              return DropdownMenuItem<int>(
                value: estadoCivil.code,
                child: Text(estadoCivil.name),
              );
            }).toList(),
            onChanged: (val) {
              FocusScope.of(context).requestFocus(FocusNode());
              _personalInfoStepBloc.changeEstadoCivil(val);
            },
          );
        }
      );
    
  }

  Widget _buildNacionalidad(Size size) {
    //Nacionalidad
    return StreamBuilder<String>(
        stream: _personalInfoStepBloc.nacionalidad,
        builder: (context, snapshot) {
          return DropdownButtonFormField<String>(
            //underline: Container(),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nacionalidad \*",
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
            ),
            isExpanded: true,
            validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
            //hint: Text("Selecciona una opción"),
            value: snapshot.data,
            items: _nacionalidades.map((nacionalidad) {
              return DropdownMenuItem<String>(
                value: nacionalidad.code,
                child: Text(nacionalidad.name),
              );
            }).toList(),
            onChanged: (val) {
                FocusScope.of(context).requestFocus(FocusNode());
                _personalInfoStepBloc.changeNacionalidad(val);
            },
          );
        }
      );
    
  }

  Widget _buildTipoTel(Size size) {
    return StreamBuilder<int>(
      stream: _personalInfoStepBloc.tipoTel,
      builder: (context, snapshot) {
        return _catalogosDropDown.buildTipoTel(
          size: size, title: "Tipo de teléfono \*", value: snapshot.data, tiposTelefonos: _tiposTelefonos,
          onChanged: (val) {
            FocusScope.of(context).requestFocus(FocusNode());
            _personalInfoStepBloc.changeTipoTel(val);
          }
        );
      }
    );
  }

  Widget _buildIdentification(Size size) {
    //Identificación oficial vigente
    return  StreamBuilder<int>(
        stream: _personalInfoStepBloc.identificacionOficial,
        builder: (context, snapshot) {
          return DropdownButtonFormField<int>(
           // underline: Container(),
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Identificación oficial vigente \*",
                errorText: snapshot.error,
                contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
            ),
            validator:(value) => snapshot.data == null ? 'Campo requerido' : null,
            isExpanded: true,
            //hint: Text("Selecciona una opción"),
            value: snapshot.data,
            items: _identificacionesOficiales.map((identificacion) {
              return DropdownMenuItem<int>(
                value: identificacion.code,
                child: Text(identificacion.name),
              );
            }).toList(),
            onChanged: (val) {
              label_identificacion = val;
              FocusScope.of(context).requestFocus(FocusNode());
              _personalInfoStepBloc.changeIdentificacionOficial(val);
                _personalInfoStepBloc.changeFolioIdentificacion(
                  IdentificacionVM(
                    valor: _personalInfoStepBloc.folioIdentificacionCtrl.value?.valor,
                    tipoIdentificacion: val
                  )
                );
            },
          );
        }
      );
    
  }

  _submit(int index) {
    FocusScope.of(context).requestFocus(FocusNode());

    if(_formKeyStep1.currentState.validate()) {
      widget.tabController.animateTo(index);
    } else {
      //_personalInfoStepBloc.changeRfc("");
      showDialog(
        builder: (context) => PlatformMessage(
          title: "Información incompleta",
          content: "Todos los datos son requeridos",
          okPressed: () => Navigator.of(context).pop()
        ), context: context
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
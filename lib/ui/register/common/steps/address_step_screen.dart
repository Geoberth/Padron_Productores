import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:load/load.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:siap/blocs/register/common/address_step_bloc.dart';
import 'package:siap/models/generic/generic_model.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/offlineDB/DBProvider.dart';
import 'package:siap/repository/catalogos/catalogos_repository.dart';
import 'package:siap/repository/connectivity/check_conectivity.dart';
import 'package:siap/repository/home/home_repository.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/ui/register/widgets/catalogos_dropdown.dart';
import 'package:siap/ui/widgets/custom_flushbar.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/ui/widgets/platform_message.dart';
import 'package:siap/utils/ui_data.dart';
import 'package:siap/validators/general_validator.dart';

class AddressStepScreen extends StatefulWidget {
  final TabController tabController;
  AddressStepScreen({@required this.tabController});
  @override
  _AddressStepScreenState createState() => _AddressStepScreenState();
}

class _AddressStepScreenState extends State<AddressStepScreen> with AutomaticKeepAliveClientMixin {
  bool _isValidForm = false;
  UserModel _userModel = UserSingleton.instance.user;
  AddressStepBloc _addressStepBloc;
  CatalogosDropDown _catalogosDropDown = CatalogosDropDown();
  CatalogosRepository _catalogosRepository = CatalogosRepository();
  HomeRepository _homeRepository = HomeRepository();

  List<GenericData<String>> _estados = [];
  List<GenericData<String>> _municipios = [];
  List<GenericData<String>> _localidades = [];
  List<GenericData<String>> _centrosIntegradores = [];
  List<GenericData<String>> _tiposDirecciones = [];
  List<GenericData<int>> _tiposVialidades = [];
  List<GenericData<int>> _tiposAsentamientos = [];
    CheckConectivity _checkConectivity = CheckConectivity();
  var maskFormatterFecha = new MaskTextInputFormatter(mask: '####/##/##', filter: { "#": RegExp(r'[0-9]') });
  
  final _formKeyStep2 = GlobalKey<FormState>();

  TextEditingController _cpTextCtrl = TextEditingController();
  TextEditingController _nombreVialidadTextCtrl = TextEditingController();
  TextEditingController _noInteriorTextCtrl = TextEditingController();
  TextEditingController _noExteriorTextCtrl = TextEditingController();
  TextEditingController _nombreAsentamientoTextCtrl = TextEditingController();
  TextEditingController _ubicacionGeoTextCtrl = TextEditingController();

  initState() {
    _addressStepBloc = BlocProvider.of<AddressStepBloc>(context);
    super.initState();
    _addressStepBloc.submitValid.listen((valid) {
      _isValidForm = valid;
    }).onError((handleError) {
      _isValidForm = false;
      print("Handle error: ${handleError.toString()}");
    });
    _initData();
  }

  _initData() async {
     showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
    if ( await _checkConectivity.checkConnectivity() ) {
      print(" Online ");
      try {
        if(_userModel.tipoPersona == 1 ){
            if(_userModel.curp != null )
              await _homeRepository.getParcelas(  curp: _userModel.curp);
          }else {
            if( _userModel.rfc != null)
            await _homeRepository.getParcelas2(  rfc: _userModel.rfc);
        }
        _tiposDirecciones = await _catalogosRepository.getTipoDireccion();
        _tiposVialidades = await _catalogosRepository.getTipoVialidad();
        _tiposAsentamientos = await _catalogosRepository.getTipoAsentamiento();
        _estados = await _catalogosRepository.getEstados();
        if(_userModel.entidadFederativa != null) {
          _addressStepBloc.changeEstado(_userModel.entidadFederativa);
          _municipios = await _catalogosRepository.getMunicipios(codigoEstado: _userModel.entidadFederativa);
          if(_userModel.municipio != null) {
            _addressStepBloc.changeMunicipio(_userModel.municipio);
            _localidades = await _catalogosRepository.getLocalidades(codigoEstado: _userModel.entidadFederativa, codigoMunicipio: _userModel.municipio);
            _centrosIntegradores = await _catalogosRepository.getCentrosIntegradores(codigoEstado: _userModel.entidadFederativa);
            if(_userModel.localidad != null) {
              _addressStepBloc.changeLocalidad(_userModel.localidad);
            }
            if(_userModel.centroIntegrador != null) {
              _addressStepBloc.changeCentroIntegrador(_userModel.centroIntegrador);
            }
          }
        }
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
      print(" Offline ");
      try {
        _tiposDirecciones = await DBProvider.db.getAllTypeAddress();
        _tiposVialidades = await DBProvider.db.getAllTypeRoad();
        _tiposVialidades.sort((a,b)=> a.name.toString().compareTo(b.name.toString()));
        _tiposAsentamientos = await DBProvider.db.getAllSetElement();
        _tiposAsentamientos.sort((a,b)=> a.name.toString().compareTo(b.name.toString()));
        _estados = await DBProvider.db.getAllFederalEntity();
        if(_userModel.entidadFederativa != null) {
          _addressStepBloc.changeEstado(_userModel.entidadFederativa);
          _municipios = await DBProvider.db.getAllMunicipalityByCode(codigoEstado: _userModel.entidadFederativa);
          if(_userModel.municipio != null) {
            _addressStepBloc.changeMunicipio(_userModel.municipio);
            _localidades = await DBProvider.db.getAllLocationByCode(codigoEstado: _userModel.entidadFederativa, codigoMunicipio: _userModel.municipio);
            _centrosIntegradores = await DBProvider.db.getAllIntegrationCenterByCode(codigoEstado: _userModel.entidadFederativa);
            if(_userModel.localidad != null) {
              _addressStepBloc.changeLocalidad(_userModel.localidad);
            }
            if(_userModel.centroIntegrador != null) {
              _addressStepBloc.changeCentroIntegrador(_userModel.centroIntegrador);
            }
          }
        }
        setState(() {});
        _initSimpleDataForm();
      } catch(e) {
        print("Error");
        print(e);
        CustomFlushbar(
          message: "No fue posible obtener la información, intenta más tarde.",
          flushbarType: FlushbarType.DANGER,
        )..show(context);
      } finally {
        Future.delayed(Duration(seconds: 2)).then((_) { hideLoadingDialog(); });
      }
    }

  }

  _initSimpleDataForm() {
    if(_userModel.tipoDireccion != null) {
      _addressStepBloc.changeTipoDireccion(_userModel.tipoDireccion);
    }
    if(_userModel.tipoVialidad != null) {
      _addressStepBloc.changeTipoVialidad(_userModel.tipoVialidad);
    }
    if(_userModel.cp != null) {
      _addressStepBloc.changeCp(_userModel.cp);
      _cpTextCtrl.text = _userModel.cp.toString();
    }
    if(_userModel.nombreVialidad != null) {
      _addressStepBloc.changeNombreVialidad(_userModel.nombreVialidad);
      _nombreVialidadTextCtrl.text = _userModel.nombreVialidad.toString();
    }
    if(_userModel.noInterior != null) {
      _addressStepBloc.changeNoInterior(_userModel.noInterior);
      _noInteriorTextCtrl.text = _userModel.noInterior;
    }
    if(_userModel.noExterior != null) {
      _addressStepBloc.changeNoExterior(_userModel.noExterior);
      _noExteriorTextCtrl.text = _userModel.noExterior;
    }
    if(_userModel.nombreAsentamiento != null) {
      _addressStepBloc.changeNombreAsentamiento(_userModel.nombreAsentamiento);
      _nombreAsentamientoTextCtrl.text = _userModel.nombreAsentamiento;
    }
    if(_userModel.tipoAsentamiento != null) {
      _addressStepBloc.changeTipoAsentamiento(_userModel.tipoAsentamiento);
    }
    if(_userModel.ubicacionGeografica != null) {
      _addressStepBloc.changeUbicacionGeo(_userModel.ubicacionGeografica);
      _ubicacionGeoTextCtrl.text = _userModel.ubicacionGeografica;
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
            (_userModel.tipoPersona == 1)?
            Text('Registro de domicilio personal', maxLines: 2, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, letterSpacing: 0.5)):
            Text('Registro de domicilio de razón social', maxLines: 2, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, letterSpacing: 0.5))
            ,
            SizedBox(height: 10.0,),
            Text('Ingresa los siguientes datos.'),
            Form(
              key: _formKeyStep2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StreamBuilder<String>(
                    stream: _addressStepBloc.cp,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _cpTextCtrl,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(5)],
                        decoration: InputDecoration(
                          labelText: "Código postal \*",
                          errorText: snapshot.error
                        ),
                        validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                        onChanged:(value) {
                          if(value.length <= 5 ){
                            _addressStepBloc.changeCp(value);
                          }
                        } ,
                      );
                    }
                  ),
                  _buildEstados(size),
                  _buildMunicipios(size),
                  _buildLocalidad(size),
                  _buildCentroIntegrador(size),
                  _buildTipoAsentamiento(size),
                  StreamBuilder<String>(
                    stream: _addressStepBloc.nombreAsentamiento,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _nombreAsentamientoTextCtrl,
                        decoration: InputDecoration(
                          labelText: "Nombre de asentamiento \*",
                          errorText: snapshot.error
                        ),
                        validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                        onChanged: _addressStepBloc.changeNombreAsentamiento,
                      );
                    }
                  ),
                  _buildTipoDireccion(size),
                  _buildTipoVialidad(size),
                  StreamBuilder<String>(
                    stream: _addressStepBloc.nombreVialidad,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _nombreVialidadTextCtrl,
                        decoration: InputDecoration(
                          labelText: "Nombre de vialidad \*",
                          errorText: snapshot.error
                        ),
                        validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                        onChanged: _addressStepBloc.changeNombreVialidad,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _addressStepBloc.noExterior,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _noExteriorTextCtrl,
                        decoration: InputDecoration(
                          labelText: "No. exterior \*",
                          errorText: snapshot.error
                        ),
                        validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                        onChanged: _addressStepBloc.changeNoExterior,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _addressStepBloc.noInterior,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _noInteriorTextCtrl,
                        decoration: InputDecoration(
                          labelText: "No. interior",
                          errorText: snapshot.error
                        ),
                        onChanged: _addressStepBloc.changeNoInterior,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _addressStepBloc.ubicacionGeo,
                    builder: (context, snapshot) {
                      return InkWell(
                        onTap: () async {
                          if ( await _checkConectivity.checkConnectivity() ){
                            print("GEOLOCATION VALUE");
                            print(_addressStepBloc.ubicacionGeoCtrl.value);
                            var ubicacion;
                            if(_addressStepBloc.ubicacionGeoCtrl?.value != null ){
                              var coords = _addressStepBloc.ubicacionGeoCtrl?.value?.split(',');
                             Map<String, dynamic> params = { "latitude": coords[0],"longitude":coords[1] };
                             ubicacion = await Navigator.of(context).pushNamed(UiData.routeMaps,arguments: params);
                            }else{
                              Map<String, dynamic> params = { "latitude": null,"longitude":null };
                              ubicacion = await Navigator.of(context).pushNamed(UiData.routeMaps,arguments: params);
                            }
                            

                            
                            if(ubicacion is LatLng) {
                              String formatLocation = "${ubicacion.latitude}, ${ubicacion.longitude}";
                              _ubicacionGeoTextCtrl.text = formatLocation;
                              _addressStepBloc.changeUbicacionGeo(formatLocation);
                            }
                          }else{
                           await  showCustomLoadingWidget(CustomLoadingLocation(message: 'Obteniendo tu ubicación actual'), tapDismiss: false);
                            
                            try{
                             
                              Position location = await Geolocator().getCurrentPosition();
                            final ubicacion = LatLng(location.latitude, location.longitude);
                            if( ubicacion is LatLng){
                              String formatLocation = "${ubicacion.latitude}, ${ubicacion.longitude}";
                              _ubicacionGeoTextCtrl.text = formatLocation;
                              _addressStepBloc.changeUbicacionGeo(formatLocation);
                            }
                            }catch( e){
                                print("PermissionStatus()");
                                print(e.toString());
                            }finally{
                                Future.delayed(Duration(seconds: 2)).then((_) { 
                             hideLoadingDialog();
                             _submit(2);
                              });
                            }
                            
                           
                           
                          }

                        },
                        child: TextFormField(
                          controller: _ubicacionGeoTextCtrl,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: "Ubicación geográfica \*",
                            errorText: snapshot.error
                          ),
                          validator: (value) => snapshot.data == null ? 'Campo requerido' : null,
                         
                        ),
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
                          onPressed: () => widget.tabController.animateTo(0),
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
                            onPressed: () => _submit(2),
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

  Widget _buildEstados(Size size) {
    return StreamBuilder<String>(
      stream: _addressStepBloc.estado,
      builder: (context, snapshot) {
        return _catalogosDropDown.buildEstados(
          size: size, title: "Entidad federativa \*", value: snapshot.data, estados: _estados,
          onChanged: (val) async {
            FocusScope.of(context).requestFocus(FocusNode());
            if ( await _checkConectivity.checkConnectivity() ) {
              showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
              _addressStepBloc.changeMunicipio(null);
              // _addressStepBloc.changeLocalidad(null);
              _addressStepBloc.changeCentroIntegrador(null);
              _municipios = await _catalogosRepository.getMunicipios(codigoEstado: val);
              hideLoadingDialog();
              _addressStepBloc.changeEstado(val);
              setState(() {});
            }else{
              try{
               await showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
                _addressStepBloc.changeMunicipio(null);
                // _addressStepBloc.changeLocalidad(null);
                _addressStepBloc.changeCentroIntegrador(null);
                _municipios = await DBProvider.db.getAllMunicipalityByCode(codigoEstado: val);
               Future.delayed(Duration(seconds: 2)).then((_) { hideLoadingDialog(); });
                _addressStepBloc.changeEstado(val);
                setState(() {});
              }catch (e){

              }finally{

              }

            }

          }
        );
      }
    );
  }

  Widget _buildMunicipios(Size size) {
    return StreamBuilder<String>(
      stream: _addressStepBloc.municipio,
      builder: (context, snapshot) {
        return _catalogosDropDown.buildMunicipios(
          size: size, title: "Municipio \*", value: snapshot.data, municipios: _municipios,
          onChanged: (val) async {
            FocusScope.of(context).requestFocus(FocusNode());
            if ( await _checkConectivity.checkConnectivity() ) {

              showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
              _addressStepBloc.changeLocalidad(null);
              _addressStepBloc.changeCentroIntegrador(null);
              _localidades = await _catalogosRepository.getLocalidades(codigoEstado: _addressStepBloc.estadoCtrl.value, codigoMunicipio: val);
              _centrosIntegradores = await _catalogosRepository.getCentrosIntegradores(codigoEstado: _addressStepBloc.estadoCtrl.value);
              hideLoadingDialog();
              _addressStepBloc.changeMunicipio(val);
              setState(() {});
            }else{
              try{

               await showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
                _addressStepBloc.changeLocalidad(null);
                _addressStepBloc.changeCentroIntegrador(null);
                print("codigoEstado");
                print( _addressStepBloc.estadoCtrl.value);
                print("codigoMunicipio");
                print(val);
                _localidades = await DBProvider.db.getAllLocationByCode(codigoEstado: _addressStepBloc.estadoCtrl.value, codigoMunicipio: val);
                _centrosIntegradores = await DBProvider.db.getAllIntegrationCenterByCode(codigoEstado: _addressStepBloc.estadoCtrl.value);
               _addressStepBloc.changeMunicipio(val);
               setState(() {});
                Future.delayed(Duration(seconds: 2)).then((_) { hideLoadingDialog(); });
              }catch (e){
                print("Error");
                print(e);
              }finally{

              }

            }

          }
        );
      }
    );
  }

  Widget _buildLocalidad(Size size) {
    return StreamBuilder<String>(
      stream: _addressStepBloc.localidad,
      builder: (context, snapshot) {
        return _catalogosDropDown.buildLocalidad(
          size: size, title: "Localidad \*", value: snapshot.data, localidades: _localidades,
          onChanged: (val) {
            FocusScope.of(context).requestFocus(FocusNode());
            _addressStepBloc.changeLocalidad(val);
          }
        );
      }
    );
  }

  Widget _buildCentroIntegrador(Size size) {
    return StreamBuilder<String>(
      stream: _addressStepBloc.centroIntegrador,
      builder: (context, snapshot) {
        return _catalogosDropDown.buildCentroIntegrador(
          size: size, title: "Centro integrador \*", value: snapshot.data, centrosIntegradores: _centrosIntegradores,
          onChanged: (val) {
            FocusScope.of(context).requestFocus(FocusNode());
            _addressStepBloc.changeCentroIntegrador(val);
          }
        );
      }
    );
  }

  Widget _buildTipoAsentamiento(Size size) {
    return StreamBuilder<Object>(
      stream: _addressStepBloc.tipoAsentamiento,
      builder: (context, snapshot) {
        return _catalogosDropDown.buildTipoAsentamiento(
          size: size, title: "Tipo de asentamiento \*", value: snapshot.data, tiposAsentamientos: _tiposAsentamientos,
          onChanged: (val) {
            FocusScope.of(context).requestFocus(FocusNode());
            _addressStepBloc.changeTipoAsentamiento(val);
          }
        );
      }
    );
  }

  Widget _buildTipoDireccion(Size size) {
    return StreamBuilder<String>(
      stream: _addressStepBloc.tipoDireccion,
      builder: (context, snapshot) {
        return _catalogosDropDown.buildTipoDireccion(
          size: size, title: "Tipo de dirección \*", value: snapshot.data, tiposDirecciones: _tiposDirecciones,
          onChanged: (val) {
            FocusScope.of(context).requestFocus(FocusNode());
            _addressStepBloc.changeTipoDireccion(val);
          }
        );
      }
    );
  }

  Widget _buildTipoVialidad(Size size) {
    return StreamBuilder<int>(
      stream: _addressStepBloc.tipoVialidad,
      builder: (context, snapshot) {
        return _catalogosDropDown.buildTipoVialidad(
          size: size, title: "Tipo de vialidad \*", value: snapshot.data, tiposVialidades: _tiposVialidades,
          onChanged: (val) {
            FocusScope.of(context).requestFocus(FocusNode());
            _addressStepBloc.changeTipoVialidad(val);
          }
        );
      }
    );
  }

  _submit(int index) {
    FocusScope.of(context).requestFocus(FocusNode());
    if(_formKeyStep2.currentState.validate()) {
      widget.tabController.animateTo(index);
    } else {
      print(_addressStepBloc.ubicacionGeoCtrl.value);
      ( _addressStepBloc.ubicacionGeoCtrl.value == null || _addressStepBloc.ubicacionGeoCtrl.value == '' )?
      showDialog(
        builder: (context) => PlatformMessage(
          title: "Información incompleta",
          content: "El campo Ubicación Geográfica es obligatorio",
          okPressed: () => Navigator.of(context).pop()
        ), context: context
      ):
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
  void dispose() {
    _resetStreamsForm();
    super.dispose();
  }

  void _resetStreamsForm() {
    /* _addressStepBloc.changeCp(null);
    _addressStepBloc.changeEstado(null);
    _addressStepBloc.changeMunicipio(null);
    _addressStepBloc.changeLocalidad(null);
    _addressStepBloc.changeCentroIntegrador(null);
    _addressStepBloc.changeTipoAsentamiento(null);
    _addressStepBloc.changeNombreAsentamiento(null);
    _addressStepBloc.changeTipoDireccion(null);
    _addressStepBloc.changeTipoVialidad(null);
    _addressStepBloc.changeNombreVialidad(null);
    _addressStepBloc.changeNoExterior(null);
    _addressStepBloc.changeNoInterior(null);
    _addressStepBloc.changeUbicacionGeo(null); */
  }

  @override
  bool get wantKeepAlive => true;
}
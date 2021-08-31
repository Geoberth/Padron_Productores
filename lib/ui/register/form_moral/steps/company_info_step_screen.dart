import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:load/load.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:siap/blocs/register/add_socio/add_socio_bloc.dart';
import 'package:siap/blocs/register/moral/company_info_step/company_info_step_bloc.dart';
import 'package:siap/models/generic/generic_model.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/offlineDB/DBProvider.dart';
import 'package:siap/repository/catalogos/catalogos_repository.dart';
import 'package:siap/repository/connectivity/check_conectivity.dart';
import 'package:siap/repository/home/home_repository.dart';
import 'package:siap/repository/register/register_repository.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/ui/register/widgets/catalogos_dropdown.dart';
import 'package:siap/ui/widgets/custom_flushbar.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/ui/widgets/platform_message.dart';
import 'package:siap/utils/ui_data.dart';
import 'package:siap/validators/decimal_formatter.dart';
import 'package:siap/validators/ine_validator.dart';
import 'package:siap/validators/ine_validator2.dart';

class CompanyInfoStepScreen extends StatefulWidget {
  final TabController tabController;
  CompanyInfoStepScreen({@required this.tabController});
  @override
  _CompanyInfoStepScreenState createState() => _CompanyInfoStepScreenState();
}

class _CompanyInfoStepScreenState extends State<CompanyInfoStepScreen>  with AutomaticKeepAliveClientMixin{
  bool _isValidForm = false;
  StreamSubscription<bool> _subscriptionSubmit;
  UserModel _userModel = UserSingleton.instance.user;
  CompanyInfoStepBloc _companyInfoStepBloc;
  AddSocioBloc _addSocioBloc;
  final _formKeyStep1 = GlobalKey<FormState>();
  CatalogosDropDown _catalogosDropDown = CatalogosDropDown();
  CatalogosRepository _catalogosRepository = CatalogosRepository();
  List<GenericData<int>> _tiposTelefonos = [];
  List<GrupoPersonaMoral> grupoPersonasMorales = [];
    CheckConectivity _checkConectivity = CheckConectivity();
  var maskFormatterFecha = new MaskTextInputFormatter(mask: '##/##/####', filter: { "#": RegExp(r'[0-9]') });
  HomeRepository _homeRepository = HomeRepository();
  TextEditingController _noSociosMoralesTextCtrl = TextEditingController();
  TextEditingController _rfcTextCtrl = TextEditingController();
  TextEditingController _razonSocialCtrl = TextEditingController();
  TextEditingController _representanteLegalCtrl = TextEditingController();
  TextEditingController _noIdentificationCtrl = TextEditingController();
  TextEditingController _fechaConstitucionCtrl = TextEditingController();
  TextEditingController _noRegistroInstrumentoCtrl = TextEditingController();
   TextEditingController _noNotarioCtrl = TextEditingController();
  TextEditingController _ultimaActualizacionCtrl = TextEditingController();
  TextEditingController _totalSociosCtrl = TextEditingController();
  TextEditingController _noSociosCtrl = TextEditingController();
  TextEditingController _correoCtrl = TextEditingController();
  TextEditingController _celPhoneCtrl = TextEditingController();
  TextEditingController _tipoTelefonoCtrl = TextEditingController();
  TextEditingController _noTelefonoCtrl = TextEditingController();

   RegisterRepository registerRepository = RegisterRepository();
  StreamSubscription<String> _subscriptionRfc;
  bool _inputEnabled = false;
  bool _validateRfc = false;
  @override
  void initState() {
    super.initState();
    
    _companyInfoStepBloc = BlocProvider.of<CompanyInfoStepBloc>(context);
       _subscriptionSubmit = _companyInfoStepBloc.submitValid.listen((valid) {
      _isValidForm = valid;
    });
    _subscriptionSubmit.onError((handleError) {
      _isValidForm = false;
      print("Handle error: ${handleError.toString()}");
    });
    _addSocioBloc = BlocProvider.of<AddSocioBloc>(context)..changeSocios([]);
    _subscriptionRfc = _companyInfoStepBloc.rfc.listen((onData) async {
      if (_validateRfc == true && onData != _userModel.rfc) {
        try {
          
          Map<String, dynamic> response = await RegisterRepository().validateRfc(rfc: onData);
        } catch(error) {
          _rfcTextCtrl.text = _userModel.rfc;
          _companyInfoStepBloc.changeRfc(_userModel.rfc);
          CustomFlushbar(
            message: error.toString(),
            flushbarType: FlushbarType.DANGER,
          ).topBar()..show(context);
        } finally {
          
        }
      }
    });
      
        _initData();
   
    
  }
   updateInfo() async {
    //actualizar informacion
      print('ACTUALIZACION ACTUALIAZCION');
      _userModel =  await registerRepository.getUserData(userId: _userModel.id);
      print('_userModelUpdate');
      print(_userModel.toJson().toString());
      UserSingleton.instance.user = _userModel ;
    
  }
  _initData() async {
    showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
    if ( await _checkConectivity.checkConnectivity() ) {
      try {
        if(_userModel.id != null){
           updateInfo();
         }
        if(_userModel.tipoPersona == 1 ){
            if(_userModel.curp != null )
              await _homeRepository.getParcelas(  curp: _userModel.curp);
          }else {
            if( _userModel.rfc != null)
            await _homeRepository.getParcelas2(  rfc: _userModel.rfc);
        }
        _tiposTelefonos = await _catalogosRepository.getTipoTelefono();
        setState(() {});
        _initForm();
        _companyInfoStepBloc.initSimpleDataForm(_userModel, _addSocioBloc);
        _noSociosMoralesTextCtrl.text = _companyInfoStepBloc.noSociosMoralesCtrl.value;

      } catch(e) {
        CustomFlushbar(
          message: "No fue posible obtener la información, intenta más tarde.",
          flushbarType: FlushbarType.DANGER,
        )..show(context);
      } finally {
        hideLoadingDialog();
      }
    }else{
      _inputEnabled = true;
      try {
        _tiposTelefonos = await DBProvider.db.getAllTypePhone();
        _tiposTelefonos.sort((a,b)=> a.name.toString().compareTo(b.name.toString()));
        setState(() {});
          _initForm();
        _companyInfoStepBloc.initSimpleDataForm(_userModel, _addSocioBloc);
        _noSociosMoralesTextCtrl.text = _companyInfoStepBloc.noSociosMoralesCtrl.value;
      } catch(e) {
        CustomFlushbar(
          message: "No fue posible obtener la información, intenta más tarde.",
          flushbarType: FlushbarType.DANGER,
        )..show(context);
      } finally {
        Future.delayed(Duration(seconds: 2 )).then((_) { hideLoadingDialog(); });
      }
    }

  }
  _initForm()async {
    if(_userModel.rfc != null) {
      _companyInfoStepBloc.changeRfc(_userModel.rfc);
      _rfcTextCtrl.text = _userModel.rfc;

    }
    if(_userModel.razonSocial != null ) {
      _companyInfoStepBloc.changeRazonSocial(_userModel.razonSocial);
      _razonSocialCtrl.text  = _userModel.razonSocial;
    }
    if(_userModel.representanteLegal != null){
      _companyInfoStepBloc.changeRepresentanteLegal(_userModel.representanteLegal);
      print("REPRESENTANTE");
      print(_userModel.representanteLegal);
      _representanteLegalCtrl.text  = _userModel.representanteLegal;
    }
    if(_userModel.fechaConstitucion != null ){
      _companyInfoStepBloc.changeFechaConstitucion(_userModel.fechaConstitucion);
      _fechaConstitucionCtrl.text = _userModel.fechaConstitucion;
    }
    if(_userModel.noRegistroInstrumentoConstitucion != null){
      _companyInfoStepBloc.changeNoRegistroConstitucion(_userModel.noRegistroInstrumentoConstitucion);
      _noRegistroInstrumentoCtrl.text  = _userModel.noRegistroInstrumentoConstitucion;
    }
    if( _userModel.noNotario != null){
      _companyInfoStepBloc.changeNoNotario(_userModel.noNotario);
      _noNotarioCtrl.text  = _userModel.noNotario;
      
    }
    if(_userModel.ultimaActualizacionActaConstitutiva != null ){
      _companyInfoStepBloc.changeUltimaActualizacion(_userModel.ultimaActualizacionActaConstitutiva);
      _ultimaActualizacionCtrl.text = _userModel.ultimaActualizacionActaConstitutiva;
    }
    if(_userModel.totalSociosFisicos != null){
      _companyInfoStepBloc.changeTotalSociosFisicos(_userModel.totalSociosFisicos.toString() );
      _totalSociosCtrl.text =  _userModel.totalSociosFisicos.toString() ;
    }
    if(_userModel.noSociosMorales != null ) {
      _companyInfoStepBloc.changeNoSociosMorales(_userModel.noSociosMorales.toString());
      _noSociosCtrl.text = _userModel.noSociosMorales.toString();
    }
    if(_userModel.email != null ){
      _companyInfoStepBloc.changeEmail(_userModel.email);
      _correoCtrl.text = _userModel.email;
    }
    if(_userModel.celPhone != null ) {
      _companyInfoStepBloc.changeCelPhone(_userModel.celPhone);
      _celPhoneCtrl.text = _userModel.celPhone;
    }
    if(_userModel.tipoTel != null ) {
      _companyInfoStepBloc.changeTipoTel(_userModel.tipoTel);
      _tipoTelefonoCtrl.text = _userModel.tipoTel.toString();
    }
    if(_userModel.noTel != null ){
      _companyInfoStepBloc.changeNoTel(_userModel.noTel);
      _noTelefonoCtrl.text = _userModel.noTel;
    }
    if(_userModel.noIdentificacionRepresentanteLegal != null ){
      _companyInfoStepBloc.changeNoIdentificacionRepresentanteLegal(
        IdentificacionValidator(valor: _userModel.noIdentificacionRepresentanteLegal)
      );
      _noIdentificationCtrl.text = _userModel.noIdentificacionRepresentanteLegal;
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
            Text('Registro persona moral', maxLines: 2, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            SizedBox(height: 10.0),
            Text('Ingresa los siguientes datos.'),
            Form(
              key: _formKeyStep1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.rfc,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _rfcTextCtrl,
                        inputFormatters: [LengthLimitingTextInputFormatter(12), UpperCaseTextInputFormatter()],
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: "RFC \*",
                          errorText: snapshot.error
                        ),
                        onChanged: (value){
                          if (value.length <=12) {
                             _companyInfoStepBloc.changeRfc(value);
                          }
                        },
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.razonSocial,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _razonSocialCtrl,
                        decoration: InputDecoration(
                          labelText: "Razón social \*",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeRazonSocial,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.representanteLegal,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _representanteLegalCtrl,
                        decoration: InputDecoration(
                          labelText: "Representante legal \*",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeRepresentanteLegal,
                      );
                    }
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15.0),
                      Text("No. de identificación del representante legal ( Clave de elector ) \*", style: TextStyle(fontSize: 12.0, color: Colors.grey[600])),
                      StreamBuilder<String>(
                        stream: _companyInfoStepBloc.noIdentificacionRepresentanteLegal,
                        builder: (context, snapshot) {
                          return TextFormField(
                            textCapitalization: TextCapitalization.characters,
                             inputFormatters: [UpperCaseTextInputFormatter()],
                            //initialValue: _userModel.noIdentificacionRepresentanteLegal,
                            controller:_noIdentificationCtrl,
                            decoration: InputDecoration(                                
                              hintText: "No. de identificación del representante legal",
                              errorText: snapshot.error
                            ),
                            onChanged:(val){
                              print('Val $val');
                                 _companyInfoStepBloc.changeNoIdentificacionRepresentanteLegal(
                                   IdentificacionValidator(valor: val)
                                );
                                 
                            }
                            
                            
                          );
                        }
                      )                  
                    ],
                  ),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.fechaConstitucion,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _fechaConstitucionCtrl,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [maskFormatterFecha, LengthLimitingTextInputFormatter(10)],
                        decoration: InputDecoration(
                          labelText: "Fecha de constitución (DD/MM/AAAA) \*",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeFechaConstitucion,
                      );
                    }
                  ),
                  
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 15.0),
                        Text("No. registro del instrumento de constitución \*", style: TextStyle(fontSize: 12.0, color: Colors.grey[600])),
                        StreamBuilder<String>(
                            stream: _companyInfoStepBloc.noRegistroConstitucion,
                            builder: (context, snapshot) {
                              return TextFormField(
                                controller: _noRegistroInstrumentoCtrl,
                                decoration: InputDecoration(
                                    hintText: "No. registro del instrumento de constitución",
                                    errorText: snapshot.error
                                ),
                                onChanged: _companyInfoStepBloc.changeNoRegistroConstitucion,
                              );
                            }
                        )
                      ]

                  ),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.noNotario,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _noNotarioCtrl,
                        decoration: InputDecoration(
                          labelText: "No. notario \*",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeNoNotario,
                      );
                    }
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 15.0),
                      Text("Última actualización del acta constitutiva", style: TextStyle(fontSize: 12.0, color: Colors.grey[600])),
                      StreamBuilder<String>(
                        stream: _companyInfoStepBloc.ultimaActualizacion,
                        builder: (context, snapshot) {
                          return TextFormField(
                            controller: _ultimaActualizacionCtrl,
                            decoration: InputDecoration(
                              hintText: "Última actualización del acta constitutiva",
                              errorText: snapshot.error
                            ),
                            onChanged: _companyInfoStepBloc.changeUltimaActualizacion,
                          );
                        }
                      )
                    ],
                  ),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.totalSociosFisicos,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _totalSociosCtrl,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          labelText: "Total de socios físicos \*",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeTotalSociosFisicos,
                      );
                    }
                  ),
                  InkWell(
                    onTap: () async {
                      await Navigator.of(context).pushNamed(UiData.routeSocios, arguments: grupoPersonasMorales);
                      String noSocios = _addSocioBloc.sociosCtrl.value.length.toString();
                      _noSociosMoralesTextCtrl.text = noSocios;
                      _companyInfoStepBloc.changeNoSociosMorales(noSocios);
                    },
                    child: StreamBuilder<String>(
                      stream: null,
                      builder: (context, snapshot) {
                        return TextFormField(
                          controller: _noSociosMoralesTextCtrl,
                          enabled: false,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            labelText: "No. de socios morales \*",
                            errorText: snapshot.error
                          ),
                        );
                      }
                    )
                  ),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.email,
                    builder: (context, snapshot) {
                      return TextFormField(
                        enabled: (_userModel.email != null )?false:true,
                        controller: _correoCtrl,
                        decoration: InputDecoration(
                          labelText: "Correo electrónico \*",
                          errorText: snapshot.error
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: _companyInfoStepBloc.changeEmail,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.celPhone,
                    builder: (context, snapshot) {
                      return TextFormField(
                        enabled: (_userModel.email != null )?false:true,
                        controller: _celPhoneCtrl,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                        decoration: InputDecoration(
                          labelText: "Teléfono celular",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeCelPhone,
                      );
                    }
                  ),
                  _buildTipoTel(size),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.noTel,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _noTelefonoCtrl,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                        decoration: InputDecoration(
                          labelText: "No. teléfono \*",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeNoTel,
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
      )
      /* Container(
        margin: EdgeInsets.all(16.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Registro persona moral', maxLines: 2, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            SizedBox(height: 10.0),
            Text('Ingresa los siguientes datos.'),
            Form(
              key: _formKeyStep1,
              child: Column(
                children: <Widget>[
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.rfc,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _rfcTextCtrl,
                        inputFormatters: [LengthLimitingTextInputFormatter(12), UpperCaseTextInputFormatter()],
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: "RFC",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeRfc,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.email,
                    builder: (context, snapshot) {
                      return TextFormField(
                        enabled: false,
                        initialValue: _userModel.email,
                        decoration: InputDecoration(
                          labelText: "Correo electrónico",
                          errorText: snapshot.error
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onChanged: _companyInfoStepBloc.changeEmail,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.celPhone,
                    builder: (context, snapshot) {
                      return TextFormField(
                        enabled: false,
                        initialValue: _userModel.celPhone,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                        decoration: InputDecoration(
                          labelText: "Teléfono celular",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeCelPhone,
                      );
                    }
                  ),
                  _buildTipoTel(size),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.noTel,
                    builder: (context, snapshot) {
                      return TextFormField(
                        initialValue: _userModel.noTel,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                        decoration: InputDecoration(
                          labelText: "No. Teléfono",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeNoTel,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.razonSocial,
                    builder: (context, snapshot) {
                      return TextFormField(
                        initialValue: _userModel.razonSocial,
                        decoration: InputDecoration(
                          labelText: "Razón Social",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeRazonSocial,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.fechaConstitucion,
                    builder: (context, snapshot) {
                      return TextFormField(
                        initialValue: _userModel.fechaConstitucion,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [maskFormatterFecha, LengthLimitingTextInputFormatter(10)],
                        decoration: InputDecoration(
                          labelText: "Fecha de Constitución (DD/MM/YYYY)",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeFechaConstitucion,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.noRegistroConstitucion,
                    builder: (context, snapshot) {
                      return TextFormField(
                        initialValue: _userModel.noRegistroInstrumentoConstitucion,
                        decoration: InputDecoration(
                          labelText: "No. Registro del Instrumento de Constitución",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeNoRegistroConstitucion,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.noNotario,
                    builder: (context, snapshot) {
                      return TextFormField(
                        initialValue: _userModel.noNotario,
                        decoration: InputDecoration(
                          labelText: "No. Notario",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeNoNotario,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.ultimaActualizacion,
                    builder: (context, snapshot) {
                      return TextFormField(
                        initialValue: _userModel.ultimaActualizacionActaConstitutiva,
                        decoration: InputDecoration(
                          labelText: "Última Actualización del Acta Constitutiva",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeUltimaActualizacion,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.representanteLegal,
                    builder: (context, snapshot) {
                      return TextFormField(
                        initialValue: _userModel.representanteLegal,
                        decoration: InputDecoration(
                          labelText: "Representante Legal",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeRepresentanteLegal,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.noIdentificacionRepresentanteLegal,
                    builder: (context, snapshot) {
                      return TextFormField(
                        initialValue: _userModel.noIdentificacionRepresentanteLegal,
                        decoration: InputDecoration(
                          labelText: "No. de Identificación del Representante Legal",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeNoIdentificacionRepresentanteLegal,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _companyInfoStepBloc.totalSociosFisicos,
                    builder: (context, snapshot) {
                      return TextFormField(
                        initialValue: _userModel.totalSociosFisicos?.toString(),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          labelText: "Total de Socios Físicos",
                          errorText: snapshot.error
                        ),
                        onChanged: _companyInfoStepBloc.changeTotalSociosFisicos,
                      );
                    }
                  ),
                  InkWell(
                    onTap: () async {
                      await Navigator.of(context).pushNamed(UiData.routeSocios, arguments: grupoPersonasMorales);
                      String noSocios = _addSocioBloc.sociosCtrl.value.length.toString();
                      _noSociosMoralesTextCtrl.text = noSocios;
                      _companyInfoStepBloc.changeNoSociosMorales(noSocios);
                    },
                    child: StreamBuilder<String>(
                      stream: null,
                      builder: (context, snapshot) {
                        return TextFormField(
                          controller: _noSociosMoralesTextCtrl,
                          enabled: false,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                          decoration: InputDecoration(
                            labelText: "No. de Socios Morales",
                            errorText: snapshot.error
                          ),
                        );
                      }
                    )
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
      ) */,
    ),
    );
  }

  Widget _buildTipoTel(Size size) {
    return StreamBuilder<int>(
      stream: _companyInfoStepBloc.tipoTel,
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _catalogosDropDown.buildTipoTel(
              size: size, title: "Tipo de teléfono \*", value: snapshot.data, tiposTelefonos: _tiposTelefonos,
              onChanged: (val) {
                FocusScope.of(context).requestFocus(FocusNode());
                _companyInfoStepBloc.changeTipoTel(val);
              }
            ),
            (snapshot.hasError) ? Text(snapshot.error, style: TextStyle(color: Colors.red[800], fontSize: 12.0)) : Container()
          ],
        );
      }
    );
  }

  _submit(int index) {
    print("Isvalid form : $_isValidForm");
    print(_companyInfoStepBloc.totalSociosFisicosCtrl.value);
    print(_companyInfoStepBloc.noSociosMoralesCtrl.value);
    FocusScope.of(context).requestFocus(FocusNode());
    if(_isValidForm == true) {
      widget.tabController.animateTo(index);
    } else {
      _companyInfoStepBloc.checkValidationsForm();
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
    _subscriptionSubmit.cancel();
    _noSociosMoralesTextCtrl.dispose();
    _noIdentificationCtrl.dispose();
    _rfcTextCtrl.dispose();
    _subscriptionRfc.cancel();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

}
import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:load/load.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siap/blocs/register/common/address_step_bloc.dart';
import 'package:siap/blocs/register/common/production_step_bloc.dart';
import 'package:siap/blocs/register/fisica/characterization_step/characterization_step_bloc.dart';
import 'package:siap/blocs/register/fisica/personal_info_step/personal_info_step_bloc.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/repository/connectivity/check_conectivity.dart';
import 'package:siap/repository/register/register_repository.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/repository/utils/utils_repository.dart';
import 'package:siap/ui/register/form_moral/steps/files_moral_step_screen.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/ui/widgets/platform_message.dart';
import 'package:siap/utils/settings.dart';
import 'package:siap/utils/ui_data.dart';

class FilesStepScreen extends StatefulWidget {
  final TabController tabController;
  FilesStepScreen({@required this.tabController});
  @override
  _FilesStepScreenState createState() => _FilesStepScreenState();
}

class _FilesStepScreenState extends State<FilesStepScreen>  with AutomaticKeepAliveClientMixin {
  final _formKeyStep5 = GlobalKey<FormState>();
  UserModel _userModel = UserSingleton.instance.user;
  PersonalInfoStepBloc _personalInfoStepBloc;
  AddressStepBloc _addressStepBloc;
  CharacterizationStepBloc _characterizationStepBloc;
  ProductionStepBloc _productionStepBloc;
    CheckConectivity _checkConectivity = CheckConectivity();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  RegisterRepository _registerRepository = RegisterRepository();
  UtilsRepository _utilsRepository = UtilsRepository();
  
  List<FilesFoodIndustry> _filesFoodIndustry;

  @override
  void initState() {
    super.initState();
    _personalInfoStepBloc = BlocProvider.of<PersonalInfoStepBloc>(context);
    _addressStepBloc = BlocProvider.of<AddressStepBloc>(context);
    _characterizationStepBloc = BlocProvider.of<CharacterizationStepBloc>(context);
    _productionStepBloc = BlocProvider.of<ProductionStepBloc>(context);
    _initDocuments();
  }

  void _initDocuments() {
    _filesFoodIndustry = [];
    try{
_userModel.produccion.map((p) {
        
      _userModel.filesFoodIndustry.map((ffi) {
        
         if (p.foodIndustry.code == ffi.code) {
           
         
              _filesFoodIndustry.add(ffi);
          
           //ffi.doc = p.foodIndustry.filesRequired;
         }

      }).toList();
    }).toList();
    }catch(error){
        print("Error");
        print(error.toString());

    }
    
    setState(() {});
  }

    @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16.0),
          child: Form(
            key: _formKeyStep5,
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Agregar expediente', maxLines: 2, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                SizedBox(height: 10.0,),
                Text('Sube tus archivos en formato "PDF", máximo "1MB" por archivo.'),
                SizedBox(height: 10.0),
                Text("Documentos", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                _buildDocuments(),
                SizedBox(height: 20.0),
                _buildSectorFiles(),
                Row(
                  children: <Widget>[
                    Container(
                      width: 100.0,
                      height: UiData.heightMainButtons,
                      child: RaisedButton(
                        color: Colors.black,
                        onPressed: () => widget.tabController.animateTo(3),
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
                          onPressed: _submit,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                          ),
                          child: Text("Finalizar", style: TextStyle(color: Colors.white)),
                        )
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

  Widget _getSubtitleFile(dynamic f) {
    if (f.tempFile == null && f.fileId != null) {
      return Text("doc.pdf");
    } else if (f.tempFile != null) {
      return Text(f.tempFile.name ?? '', overflow: TextOverflow.ellipsis);
    } else if (f.file != null) {
      return Text(f.file, overflow: TextOverflow.ellipsis);
    } else {
      return Container();
    }
  }

  Widget _buildDocuments() {
    return Column(
      children: _userModel.filesPersons.map((f) {
        return Column(
          children: <Widget>[
            FormField(
              builder: (FormFieldState<String> state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(f.name + ' \*', style: TextStyle(fontSize: 13.0),),
                      subtitle: _getSubtitleFile(f),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                           (f.fileId != null && f.tempFile == null) ? 
                           InkWell(
                              onTap: () async {
                                if (await _checkConectivity.checkConnectivity()){
                                  print("${Settings.baseUrl}/siap-v4/${f.file}");
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PdfViewerScreen(urlPdf: "${Settings.baseUrl}/siap-v4/${f.file}")));
                                }else{
                                  Flushbar(
                                    flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
                                    backgroundColor: Colors.red, leftBarIndicatorColor: Colors.red,
                                    isDismissible: true, duration: Duration(seconds: 8),
                                    icon: Icon(Icons.close,color: Colors.white,),
                                    titleText: Text("Mensaje",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
                                    messageText: Text("Esta Funcionalidad no esta disponible en modo Offline", style: TextStyle(color: Colors.white)),
                                  )..show(context);
                                }

                              },
                              child: Icon(FontAwesomeIcons.eye, color: Colors.cyan, size: 20.0,),
                            ) : Container(),
                            SizedBox(width: 20.0),
                           InkWell(
                            onTap: () async {
                              final pdfFile = await _utilsRepository.filePicker(_scaffoldKey, "pdf");
                              if(pdfFile != null) {
                                f.tempFile = pdfFile;
                                f.file = pdfFile.base64;
                                state.didChange(pdfFile.base64);
                                state.validate();
                                setState((){});
                              }
                            },
                            child: Icon(FontAwesomeIcons.cloudUploadAlt, color: Colors.green, size: 20.0,),
                          )
                        ],
                      ),
                    ),
                    state.hasError ?
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        state.errorText,
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 12.0
                        ),
                      ),
                    ) :
                    Container()
                  ]
                );
              },
              validator: (value) {
                if (f.file != null) {
                  return null;
                } else if (value == null) {
                  return 'Falta seleccionar documento';
                } else {
                  return null;
                }
              },
            ),
            Container(height: 1.5, width: double.infinity, color: Colors.grey[200]),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSectorFiles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _filesFoodIndustry.map((ffi) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(ffi.name, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            Column(
              children: ffi.doc.map((d){
                return FormField(
                  builder: (FormFieldState<String> state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          title: Text( (d.isRequired == 1) ?d.name + ' \*':d.name, style: TextStyle(fontSize: 13.0)),
                          subtitle: _getSubtitleFile(d),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              (d.file != null && d.file.split("/")[0] == "uploads") ? 
                              InkWell(
                                onTap: () async {
                                    if ( await _checkConectivity.checkConnectivity() ){
                                      print("${Settings.baseUrl}/siap-v4/${d.file}");
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PdfViewerScreen(urlPdf: "${Settings.baseUrl}/siap-v4/${d.file}")));
                                    }else{
                                      Flushbar(
                                        flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
                                        backgroundColor: Colors.red, leftBarIndicatorColor: Colors.red,
                                        isDismissible: true, duration: Duration(seconds: 8),
                                        icon: Icon(Icons.close,color: Colors.white,),
                                        titleText: Text("Mensaje",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
                                        messageText: Text("Esta Funcionalidad no esta disponible en modo Offline", style: TextStyle(color: Colors.white)),
                                      )..show(context);
                                    }


                                },
                                child: Icon(FontAwesomeIcons.eye, color: Colors.cyan, size: 20.0,),
                              ) : Container(),
                              SizedBox(width: 20.0),
                              InkWell(
                                onTap: () async {
                                  final pdfFile = await _utilsRepository.filePicker(_scaffoldKey, "pdf");
                                  if(pdfFile != null) {
                                    d.tempFile = pdfFile;
                                    d.file = pdfFile.base64;
                                    state.didChange(pdfFile.base64);
                                    state.validate();
                                    print(state.hasError);
                                    setState((){});
                                  }
                                },
                                child: Icon(FontAwesomeIcons.cloudUploadAlt, color: Colors.green, size: 20.0,),
                              )
                            ],
                          ),
                        ),
                        state.hasError ?
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            state.errorText,
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 12.0
                            ),
                          ),
                        ) :
                        Container(),
                        Container(height: 1.5, width: double.infinity, color: Colors.grey[200]),
                        SizedBox(height: 20.0),
                      ],
                    );
                  },
                  validator: (value) {

                    
                    if (d.isRequired == 0) {
                      return null;
                    }
                    if (d.file != null ) {
                      return null;
                    } else if (value == null ) {
                      return 'Falta seleccionar documento';
                    } else {
                      return null;
                    }
                  },
                );
              }).toList()
            )
          ],
        );
      }).toList(),
    );
  }
  
  void _submit() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKeyStep5.currentState.validate()) {
      _saveAndFinish();
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

  _saveAndFinish() async {
    //Validar estatus
     
      _userModel = UserSingleton.instance.user;
    UserModel userModelUpdated = UserModel(id: _userModel.id,
      tipoPersona: 1,
      typePersonId: 1,
      curp: _personalInfoStepBloc.curpCtrl.value,
      rfc: _personalInfoStepBloc.rfcCtrl.value,
      homoclave: _personalInfoStepBloc.homoclaveCtrl.value,
      sexo: _personalInfoStepBloc.generoCtrl.value,
      nombre: _personalInfoStepBloc.nombreCtrl.value,
      appaterno: _personalInfoStepBloc.apPaternoCtrl.value,
      apmaterno: _personalInfoStepBloc.apMaternoCtrl.value,
      estadoCivil: _personalInfoStepBloc.estadoCivilCtrl.value,
      nacionalidad: _personalInfoStepBloc.nacionalidadCtrl.value,
      fechaDeNacimiento: _personalInfoStepBloc.fechaNacimientoCtrl.value,
      email: _personalInfoStepBloc.emailCtrl.value,
      celPhone: _personalInfoStepBloc.celPhoneCtrl.value,
      tipoTel: _personalInfoStepBloc.tipoTelCtrl.value,
      noTel: _personalInfoStepBloc.noTelCtrl.value,
      regimenPropiedad: _characterizationStepBloc.regimenPropiedadCtrl.value,
      tipoAsociacion: _characterizationStepBloc.tipoAsociacionCtrl.value,
      identificacionOficialVigente: _personalInfoStepBloc.identificacionOficialCtrl.value,
      folioIdentificacion: _personalInfoStepBloc.folioIdentificacionCtrl.value.valor,
      cuentaConDiscapacidad: _characterizationStepBloc.cuentaDiscapacidadCtrl.value,
      tipoDiscapacidad: _characterizationStepBloc.tipoDiscapacidadCtrl.value,
      declaratoriaIndigena: _characterizationStepBloc.declaratoriaIndigenaCtrl.value,
      grupoEtnico: _characterizationStepBloc.puebloEtniaCtrl.value,
      nivelDeEstudios: _characterizationStepBloc.nivelEstudiosCtrl.value,
      hablaEspanol: _characterizationStepBloc.hablaEspanolCtrl.value,
      hablaLenguaIndigena: _characterizationStepBloc.hablaLenguaIndigenaCtrl.value,
      lenguaIndigena: _characterizationStepBloc.lenguaIndigenaCtrl.value,
      tipoDireccion: _addressStepBloc.tipoDireccionCtrl.value,
      tipoVialidad: _addressStepBloc.tipoVialidadCtrl.value,
      cp: _addressStepBloc.cpCtrl.value,
      nombreVialidad: _addressStepBloc.nombreVialidadCtrl.value,
      noExterior: _addressStepBloc.noExteriorCtrl.value,
      noInterior: _addressStepBloc.noInteriorCtrl.value,
      tipoAsentamiento: _addressStepBloc.tipoAsentamientoCtrl.value,
      nombreAsentamiento: _addressStepBloc.nombreAsentamientoCtrl.value,
      entidadFederativa: _addressStepBloc.estadoCtrl.value,
      municipio: _addressStepBloc.municipioCtrl.value,
      localidad: _addressStepBloc.localidadCtrl.value,
      centroIntegrador: _addressStepBloc.centroIntegradorCtrl.value,
      ubicacionGeografica: _addressStepBloc.ubicacionGeoCtrl.value,
      filesPersons: _userModel.filesPersons,
      filesFoodIndustry: _userModel.filesFoodIndustry,
      produccion: _productionStepBloc.produccionCtrl.value,
      token: _userModel.token
    );
   /* String rs = userModelUpdated.toJson().toString();
    print("this line is just to give a extra line where stop debbug");*/
   await showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
    if ( await _checkConectivity.checkConnectivity() ) {
      UserModel tempUser;
    tempUser =  await _registerRepository.getUserData(userId: _userModel.id);
    if(tempUser.id != null && tempUser.validacion == 1) {
      print("Validado");
       Navigator.of(context).pushNamedAndRemoveUntil(UiData.routeHome, (e) => false);
       Flushbar(
          flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
          backgroundColor: Colors.green, leftBarIndicatorColor: Colors.green[400],
          isDismissible: true, duration: Duration(seconds: 8),
          icon: Icon(Icons.check_circle, color: Colors.white,),
          titleText: Text("Éxito",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
          messageText: Text("Su registro ha sido autorizado, por lo tanto sus datos no pueden actualizarse", style: TextStyle(color: Colors.white)),
        )..show(context);
    }else{
      try {
        
        final UserModel userModelDB = await _registerRepository.addPadron(user: userModelUpdated);
        _registerRepository.setUser(json.encode(userModelDB));
        UserSingleton.instance.user = userModelDB;
        Navigator.of(context).pushNamedAndRemoveUntil(UiData.routeHome, (e) => false);
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
          backgroundColor: Colors.green, leftBarIndicatorColor: Colors.green[400],
          isDismissible: true, duration: Duration(seconds: 8),
          icon: Icon(Icons.check_circle, color: Colors.white,),
          titleText: Text("Éxito",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
          messageText: Text("Información actualizada correctamente", style: TextStyle(color: Colors.white)),
        )..show(context);
      }catch(error) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString()), duration: Duration(minutes: 20),backgroundColor: Colors.red,));
      }finally {
        hideLoadingDialog();
      }
    }
      
    }else{
      try{
        
        UserModel userModelLocal = UserModel(
            id: _userModel.id,
            tipoPersona: 1,
            typePersonId: 1,
            validacion: 3,
            curp: _personalInfoStepBloc.curpCtrl.value,
            rfc: _personalInfoStepBloc.rfcCtrl.value,
            homoclave: _personalInfoStepBloc.homoclaveCtrl.value,
            sexo: _personalInfoStepBloc.generoCtrl.value,
            nombre: _personalInfoStepBloc.nombreCtrl.value,
            appaterno: _personalInfoStepBloc.apPaternoCtrl.value,
            apmaterno: _personalInfoStepBloc.apMaternoCtrl.value,
            estadoCivil: _personalInfoStepBloc.estadoCivilCtrl.value,
            nacionalidad: _personalInfoStepBloc.nacionalidadCtrl.value,
            fechaDeNacimiento: _personalInfoStepBloc.fechaNacimientoCtrl.value,
            email: _personalInfoStepBloc.emailCtrl.value,
            celPhone: _personalInfoStepBloc.celPhoneCtrl.value,
            tipoTel: _personalInfoStepBloc.tipoTelCtrl.value,
            noTel: _personalInfoStepBloc.noTelCtrl.value,
            regimenPropiedad: _characterizationStepBloc.regimenPropiedadCtrl.value,
            tipoAsociacion: _characterizationStepBloc.tipoAsociacionCtrl.value,
            identificacionOficialVigente: _personalInfoStepBloc.identificacionOficialCtrl.value,
            folioIdentificacion: _personalInfoStepBloc.folioIdentificacionCtrl.value.valor,
            cuentaConDiscapacidad: _characterizationStepBloc.cuentaDiscapacidadCtrl.value,
            tipoDiscapacidad: _characterizationStepBloc.tipoDiscapacidadCtrl.value,
            declaratoriaIndigena: _characterizationStepBloc.declaratoriaIndigenaCtrl.value,
            grupoEtnico: _characterizationStepBloc.puebloEtniaCtrl.value,
            nivelDeEstudios: _characterizationStepBloc.nivelEstudiosCtrl.value,
            hablaEspanol: _characterizationStepBloc.hablaEspanolCtrl.value,
            hablaLenguaIndigena: _characterizationStepBloc.hablaLenguaIndigenaCtrl.value,
            lenguaIndigena: _characterizationStepBloc.lenguaIndigenaCtrl.value,
            tipoDireccion: _addressStepBloc.tipoDireccionCtrl.value,
            tipoVialidad: _addressStepBloc.tipoVialidadCtrl.value,
            cp: _addressStepBloc.cpCtrl.value,
            nombreVialidad: _addressStepBloc.nombreVialidadCtrl.value,
            noExterior: _addressStepBloc.noExteriorCtrl.value,
            noInterior: _addressStepBloc.noInteriorCtrl.value,
            tipoAsentamiento: _addressStepBloc.tipoAsentamientoCtrl.value,
            nombreAsentamiento: _addressStepBloc.nombreAsentamientoCtrl.value,
            entidadFederativa: _addressStepBloc.estadoCtrl.value,
            municipio: _addressStepBloc.municipioCtrl.value,
            localidad: _addressStepBloc.localidadCtrl.value,
            centroIntegrador: _addressStepBloc.centroIntegradorCtrl.value,
            ubicacionGeografica: _addressStepBloc.ubicacionGeoCtrl.value,
            filesPersons: _userModel.filesPersons,
            filesFoodIndustry: _userModel.filesFoodIndustry,
            produccion: _productionStepBloc.produccionCtrl.value,
            token: _userModel.token
        );
        SharedPreferences user = await SharedPreferences.getInstance();
        String userModel = jsonEncode(userModelUpdated);
        user.setString('user', userModel );

        _registerRepository.setUser(json.encode(userModelLocal));
        UserSingleton.instance.user = userModelLocal;
        Navigator.of(context).pushNamedAndRemoveUntil(UiData.routeHome, (e) => false);
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
          backgroundColor: Colors.green, leftBarIndicatorColor: Colors.green[400],
          isDismissible: true, duration: Duration(seconds: 8),
          icon: Icon(Icons.check_circle, color: Colors.white,),
          //titleText: Text("",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
          messageText: Text("¡Se guardó su registro en su teléfono! Envíe (sincronice) la información en cuanto tenga conexión a internet.", style: TextStyle(color: Colors.white)),
        )..show(context);
      }catch(e){
       // _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(e.toString()), duration: Duration(minutes: 20),backgroundColor: Colors.red,));
      }finally{
        print("First loading ");
        Future.delayed(Duration(seconds: 2 )).then((_) { hideLoadingDialog(); });
      }

    }



  }

  @override
  bool get wantKeepAlive => true;
}
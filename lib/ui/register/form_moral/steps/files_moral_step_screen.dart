import 'dart:async';
import 'dart:convert';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:load/load.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siap/blocs/register/add_socio/add_socio_bloc.dart';
import 'package:siap/blocs/register/common/address_step_bloc.dart';
import 'package:siap/blocs/register/common/production_step_bloc.dart';
import 'package:siap/blocs/register/moral/company_info_step/company_info_step_bloc.dart';
import 'package:siap/models/generic/generic_model.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/repository/catalogos/catalogos_repository.dart';
import 'package:siap/repository/connectivity/check_conectivity.dart';
import 'package:siap/repository/register/register_repository.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/repository/utils/utils_repository.dart';
import 'package:siap/ui/widgets/custom_flushbar.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/ui/widgets/platform_message.dart';
import 'package:siap/utils/settings.dart';
import 'package:siap/utils/ui_data.dart';

class TempFilesVM {
  String nombreSector;
  List<GenericData<int>> files;

  TempFilesVM({this.nombreSector, this.files});

}

class FilesMoralStepScreen extends StatefulWidget {
  final TabController tabController;
  FilesMoralStepScreen({@required this.tabController});
  @override
  _FilesMoralStepScreenState createState() => _FilesMoralStepScreenState();
}

class _FilesMoralStepScreenState extends State<FilesMoralStepScreen> {
  final _formKeyStep5 = GlobalKey<FormState>();
  UserModel _userModel = UserSingleton.instance.user;
  CompanyInfoStepBloc _companyInfoStepBloc;
  AddressStepBloc _addressStepBloc;
  ProductionStepBloc _productionStepBloc;
  AddSocioBloc _addSocioBloc;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CatalogosRepository _catalogosRepository = CatalogosRepository();
  RegisterRepository _registerRepository = RegisterRepository();
  UtilsRepository _utilsRepository = UtilsRepository();

  List<FilesFoodIndustry> _filesFoodIndustry;
    CheckConectivity _checkConectivity = CheckConectivity();
  @override
  void initState() {
    super.initState();
    _companyInfoStepBloc = BlocProvider.of<CompanyInfoStepBloc>(context);
    _addressStepBloc = BlocProvider.of<AddressStepBloc>(context);
    _addSocioBloc = BlocProvider.of<AddSocioBloc>(context);
    _productionStepBloc = BlocProvider.of<ProductionStepBloc>(context);
    _initDocuments();
  }

  void _initDocuments() {
    _filesFoodIndustry = [];
    _userModel.produccion.map((p) {
      _userModel.filesFoodIndustry.map((ffi) {
         if (p.foodIndustry.code == ffi.code) {
         
           //  e.isRequired = p.foodIndustry.filesRequired;
           _filesFoodIndustry.add(ffi);
          
           
         }
      }).toList();
    }).toList();
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
                        onPressed: () => widget.tabController.animateTo(2),
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
                                if ( await _checkConectivity.checkConnectivity()){
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
                  return 'Campo requerido';
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
                          title: Text((d.isRequired == 1) ?d.name + ' \*':d.name, style: TextStyle(fontSize: 13.0)),
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
                    if (d.file != null) {
                      return null;
                    } else if (value == null) {
                      return 'Campo requerido';
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
    UserModel userModelUpdated = UserModel(
      id: _userModel.id,
      tipoPersona: 2,
      rfc: _companyInfoStepBloc.rfcCtrl.value,
      razonSocial: _companyInfoStepBloc.razonSocialCtrl.value,
      fechaConstitucion: _companyInfoStepBloc.fechaConstitucionCtrl.value,
      noRegistroInstrumentoConstitucion: _companyInfoStepBloc.noRegistroConstitucionCtrl.value,
      noNotario: _companyInfoStepBloc.noNotarioCtrl.value,
      ultimaActualizacionActaConstitutiva: _companyInfoStepBloc.ultimaActualizacionCtrl.value,
      representanteLegal: _companyInfoStepBloc.representanteLegalCtrl.value,
      noIdentificacionRepresentanteLegal: _companyInfoStepBloc.noIdentificacionRepresentanteLegalCtrl.value.valor,
      totalSociosFisicos: int.parse(_companyInfoStepBloc.totalSociosFisicosCtrl.value ?? "0"),
      noSociosMorales: int.parse(_companyInfoStepBloc.noSociosMoralesCtrl.value ?? "0"),
      email: _companyInfoStepBloc.emailCtrl.value,
      celPhone: _companyInfoStepBloc.celPhoneCtrl.value,
      tipoTel: _companyInfoStepBloc.tipoTelCtrl.value,
      noTel: _companyInfoStepBloc.noTelCtrl.value,
      tipoDireccion: _addressStepBloc.tipoDireccionCtrl.value,
      tipoVialidad: _addressStepBloc.tipoVialidadCtrl.value,
      cp: _addressStepBloc.cpCtrl.value,
      nombreVialidad: _addressStepBloc.nombreVialidadCtrl.value,
      noInterior: _addressStepBloc.noInteriorCtrl.value,
      noExterior: _addressStepBloc.noExteriorCtrl.value,
      tipoAsentamiento: _addressStepBloc.tipoAsentamientoCtrl.value,
      nombreAsentamiento: _addressStepBloc.nombreAsentamientoCtrl.value,
      entidadFederativa: _addressStepBloc.estadoCtrl.value,
      municipio: _addressStepBloc.municipioCtrl.value,
      localidad: _addressStepBloc.localidadCtrl.value,
      centroIntegrador: _addressStepBloc.centroIntegradorCtrl.value,
      ubicacionGeografica: _addressStepBloc.ubicacionGeoCtrl.value,
      grupoPersonasMorales: _addSocioBloc.sociosCtrl.value,
      filesPersons: _userModel.filesPersons,
      filesFoodIndustry: _filesFoodIndustry,
      produccion: _productionStepBloc.produccionCtrl.value,
      token: _userModel.token
    );
    /* String rs = userModelUpdated.toJson().toString();*/
    print("this line is just to give a extra line where stop debbug");
    debugPrint(jsonEncode(userModelUpdated.toJson()), wrapWidth: 1024);
  
    await showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
    if ( await _checkConectivity.checkConnectivity() ) {
        UserModel tempUser;
    tempUser =  await _registerRepository.getUserData(userId: _userModel.id);
    if(tempUser.id != null && tempUser.validacion == 1) {
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
        print(error);
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString()), backgroundColor: Colors.red,));
      }finally {
        hideLoadingDialog();
      }
    }
    }else{
      try {
        UserModel userModelUpdated = UserModel(
            id: _userModel.id,
            tipoPersona: 2,
            validacion: 3,
            rfc: _companyInfoStepBloc.rfcCtrl.value,
            razonSocial: _companyInfoStepBloc.razonSocialCtrl.value,
            fechaConstitucion: _companyInfoStepBloc.fechaConstitucionCtrl.value,
            noRegistroInstrumentoConstitucion: _companyInfoStepBloc.noRegistroConstitucionCtrl.value,
            noNotario: _companyInfoStepBloc.noNotarioCtrl.value,
            ultimaActualizacionActaConstitutiva: _companyInfoStepBloc.ultimaActualizacionCtrl.value,
            representanteLegal: _companyInfoStepBloc.representanteLegalCtrl.value,
            noIdentificacionRepresentanteLegal: _companyInfoStepBloc.noIdentificacionRepresentanteLegalCtrl.value.valor,
            totalSociosFisicos: int.parse(_companyInfoStepBloc.totalSociosFisicosCtrl.value ?? "0"),
            noSociosMorales: int.parse(_companyInfoStepBloc.noSociosMoralesCtrl.value ?? "0"),
            email: _companyInfoStepBloc.emailCtrl.value,
            celPhone: _companyInfoStepBloc.celPhoneCtrl.value,
            tipoTel: _companyInfoStepBloc.tipoTelCtrl.value,
            noTel: _companyInfoStepBloc.noTelCtrl.value,
            tipoDireccion: _addressStepBloc.tipoDireccionCtrl.value,
            tipoVialidad: _addressStepBloc.tipoVialidadCtrl.value,
            cp: _addressStepBloc.cpCtrl.value,
            nombreVialidad: _addressStepBloc.nombreVialidadCtrl.value,
            noInterior: _addressStepBloc.noInteriorCtrl.value,
            noExterior: _addressStepBloc.noExteriorCtrl.value,
            tipoAsentamiento: _addressStepBloc.tipoAsentamientoCtrl.value,
            nombreAsentamiento: _addressStepBloc.nombreAsentamientoCtrl.value,
            entidadFederativa: _addressStepBloc.estadoCtrl.value,
            municipio: _addressStepBloc.municipioCtrl.value,
            localidad: _addressStepBloc.localidadCtrl.value,
            centroIntegrador: _addressStepBloc.centroIntegradorCtrl.value,
            ubicacionGeografica: _addressStepBloc.ubicacionGeoCtrl.value,
            grupoPersonasMorales: _addSocioBloc.sociosCtrl.value,
            filesPersons: _userModel.filesPersons,
            filesFoodIndustry: _filesFoodIndustry,
            produccion: _productionStepBloc.produccionCtrl.value,
            token: _userModel.token
        );
        SharedPreferences user = await SharedPreferences.getInstance();
        String userModel = jsonEncode(userModelUpdated);
        user.setString('userMoral', userModel );
        print("Message");
        print(int.parse(_companyInfoStepBloc.totalSociosFisicosCtrl.value ?? "0"));
        _registerRepository.setUser(json.encode(userModelUpdated));
        UserSingleton.instance.user = userModelUpdated;
        Navigator.of(context).pushNamedAndRemoveUntil(UiData.routeHome, (e) => false);
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP, forwardAnimationCurve: Curves.elasticOut,
          backgroundColor: Colors.green, leftBarIndicatorColor: Colors.green[400],
          isDismissible: true, duration: Duration(seconds: 8),
          icon: Icon(Icons.check_circle, color: Colors.white,),
         // titleText: Text("Éxito",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
          messageText: Text("¡Se guardó su registro en su teléfono! Envíe (sincronice) la información en cuanto tenga conexión a internet.", style: TextStyle(color: Colors.white)),
        )..show(context);
      }catch(error){
        print(error);
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString()), backgroundColor: Colors.red,));
      }finally{
        Future.delayed(Duration(seconds: 2 )).then((_) { hideLoadingDialog(); });
      }
    }

  }
  
}


class PdfViewerScreen extends StatefulWidget {
  final String urlPdf;
  PdfViewerScreen({this.urlPdf});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  StreamController<PDFDocument> documentCtrl = StreamController<PDFDocument>.broadcast();

  @override
  void initState() {
    _loadPdf(widget.urlPdf);
    super.initState();
  }

  @override
  dispose() {
    documentCtrl.close();
    super.dispose();
  }

  Future<void> _loadPdf(String urlPdf) async {
    try {
      final PDFDocument document = await PDFDocument.fromURL(urlPdf);
      documentCtrl.sink.add(document);
    } catch(e) {
      Navigator.of(context).pop();
      CustomFlushbar(
        flushbarType: FlushbarType.DANGER,
        message: "Tu archivo PDF es incorrecto.",
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
        ),
        body: Center(
        child: StreamBuilder(
          stream: documentCtrl.stream,
          builder: (context, documentSnapshot) {
            if (documentSnapshot.hasData && documentSnapshot.data != null) {
              return PDFViewer(document: documentSnapshot.data);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        )
      )
    );
  }
}
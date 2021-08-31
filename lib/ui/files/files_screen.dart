import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:file_picker/file_picker.dart';
import 'package:siap/models/pdf/pdf_model.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/repository/home/home_repository.dart';
import 'package:siap/repository/register/register_repository.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/utils/ui_data.dart';

class FilesScreen extends StatefulWidget {
  @override
  _FilesScreenState createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UserModel _userModel = UserSingleton.instance.user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              Center(
                child: Container(
                  width: 120.0,
                  child: Image.asset(UiData.imgCloud),
                ),
              ),
              SizedBox(height: 10.0),
              Text("AGREGAR EXPEDIENTE", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              SizedBox(height: 5.0),
              Text("Sube tus archivos", style: TextStyle(color: Colors.grey)),
              SizedBox(height: 40.0),
              _buildFileItems(),
              SizedBox(height: 40.0),
              _buildButtons()
            ],
          ),
        ),
      ),
    );
  }

  // Construye el los widgets necesarios dependiendo del tipo de persona
  Widget _buildFileItems() {
    if (_userModel.tipoPersona == 1) {
      return _buildFisicaFiles();
    } else {
      return _buildMoralFiles();
    }
  }

  Widget _buildFisicaFiles() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Image.asset(UiData.imgPdf, height: 45.0),
          title: Text("Credencial de elector", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.2)),
          subtitle: Text(""),
          trailing: Container(
            width: 60.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
              ),
              color: Colors.black,
              onPressed: () async {
                
              },
              child: Icon(Icons.cloud_upload, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 15.0),
        ListTile(
          leading: Image.asset(UiData.imgPdf, height: 45.0),
          title: Text("Comprobante de domicilio", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.2)),
          subtitle: Text(""),
          trailing: Container(
            width: 60.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
              ),
              color: Colors.black,
              onPressed: () async {

              },
              child: Icon(Icons.cloud_upload, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 15.0),
        ListTile(
          leading: Image.asset(UiData.imgPdf, height: 45.0),
          title: Text("Documento legal de propiedad", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.2)),
          subtitle: Text(""),
          trailing: Container(
            width: 60.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
              ),
              color: Colors.black,
              onPressed: () async {

              },
              child: Icon(Icons.cloud_upload, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 15.0),
        ListTile(
          leading: Image.asset(UiData.imgPdf, height: 45.0),
          title: Text("Documento de arrendatario", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.2)),
          subtitle: Text(""),
          trailing: Container(
            width: 60.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
              ),
              color: Colors.black,
              onPressed: () async {
              },
              child: Icon(Icons.cloud_upload, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMoralFiles() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Image.asset(UiData.imgPdf, height: 45.0),
          title: Text("RFC Vigente", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.2)),
          subtitle: Text(""),
          trailing: Container(
            width: 60.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
              ),
              color: Colors.black,
              onPressed: () async {
              },
              child: Icon(Icons.cloud_upload, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 15.0),
        ListTile(
          leading: Image.asset(UiData.imgPdf, height: 45.0),
          title: Text("Acta constitutiva", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.2)),
          subtitle: Text(""),
          trailing: Container(
            width: 60.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
              ),
              color: Colors.black,
              onPressed: () async {
              },
              child: Icon(Icons.cloud_upload, color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 15.0),
        ListTile(
          leading: Image.asset(UiData.imgPdf, height: 45.0),
          title: Text("Comprobante de domicilio", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.2)),
          subtitle: Text(""),
          trailing: Container(
            width: 60.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
              ),
              color: Colors.black,
              onPressed: () async {
              },
              child: Icon(Icons.cloud_upload, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 10.0),
              height: UiData.heightMainButtons - 10.0,
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(UiData.borderRadiusButton)),
                color: UiData.colorPrimary,
                onPressed: () {
                  _submitFiles();
                },
                icon: Icon(Icons.cloud_upload, color: Colors.white),
                label: Expanded(child: Text("Enviar y terminar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<PdfModel> _filePicker() async {
    final File file = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['pdf']);
    int fileSizeBytes = File(file.resolveSymbolicLinksSync()).lengthSync();
    double fileSizeMB = (fileSizeBytes / (1e+6));
    if(fileSizeMB > 1) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("El archivo no puede ser mayor a 1MB"), backgroundColor: Colors.red,));
      return null;
    } else {
      Uint8List bytes = await file.readAsBytes();
      List<String> path = file.toString().split("/");
      String name = path[path.length-1];
      print(convert.base64Encode(bytes));
      return PdfModel(base64: convert.base64Encode(bytes), name: name);
    }
  }

  void _submitFiles() async {
    try {
      RegisterRepository registerRepository = RegisterRepository();
      HomeRepository homeRepository = HomeRepository();
      showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
      Map<String, dynamic> data;
      Map<String, dynamic> response = await homeRepository.addArchivos(data);
      if (_userModel.tipoPersona == 1) {
      } else {
      }
      registerRepository.setUser(convert.json.encode(_userModel));
      UserSingleton.instance.user = _userModel;
      Navigator.of(context).pop(true);
    }catch(error) {
      print(error);
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(error.toString()), backgroundColor: Colors.red,));
    }finally {
      hideLoadingDialog();
    }
  }

}


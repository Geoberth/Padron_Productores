import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:load/load.dart';
import 'package:siap/blocs/register/pre_registro/pre_registro_bloc.dart';
import 'package:siap/models/signin/signin_model.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/repository/auth/auth_repository.dart';
import 'package:siap/repository/register/register_repository.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/utils/ui_data.dart';

class PreRegisterScreenOffline extends StatefulWidget {
  
  @override
  _PreRegisterScreenState createState() => _PreRegisterScreenState();
}

class _PreRegisterScreenState extends State<PreRegisterScreenOffline> {
  UserModel _userModel = UserSingleton.instance.user;
  PreRegistroBloc _preRegistroBloc = PreRegistroBloc();
  TextEditingController _curpEditingCtrl = TextEditingController();
  TextEditingController _rfcEditingCtrl = TextEditingController();
  TextEditingController _emailEditingCtrl = TextEditingController();
  TextEditingController _telEditingCtrl = TextEditingController();
  @override
  void initState() {
    super.initState();
    
    _initForm();
    setState(() {});
  }
  _initForm(){
    if(_userModel.tipoPersona != null){
      _preRegistroBloc.changeTipoPersona(_userModel.tipoPersona);
      
    }
    if (_userModel.curp != null) {
      _preRegistroBloc.changeCurp(_userModel.curp);
      _curpEditingCtrl.text = _userModel.curp;
    }
    if (_userModel.email != null) {
      _preRegistroBloc.changeEmail(_userModel.email);
      _emailEditingCtrl.text = _userModel.email;
    }
    if (_userModel.celPhone != null ) {
      _preRegistroBloc.changeNoTel(_userModel.celPhone);
      _telEditingCtrl.text = _userModel.celPhone;
    }
    if (_userModel.rfc != null ) {
      _preRegistroBloc.changeRfc(_userModel.rfc);
      _rfcEditingCtrl.text = _userModel.rfc;
    }

  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int selectedTypePerson = _preRegistroBloc.tipoPersonaCtrl.value;
    
    return GestureDetector(
      onTap: () {
         Navigator.of(context).pop(false);
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black
          ),
          elevation: 0.0,
          backgroundColor: UiData.colorAppBar,
          title: Image.asset(UiData.imgLogoSiap, width: 250),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Registro', maxLines: 2, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  SizedBox(height: 10.0,),
                  Text('Ingresa los siguientes datos.'),
                  SizedBox(height: 20.0),
                  _buildTipoPersona(size),
                  _buildUsername(size, selectedTypePerson),
                  StreamBuilder<String>(
                    stream: _preRegistroBloc.email,
                    builder: (context, snapshot) {
                      return TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller:_emailEditingCtrl ,
                        decoration: InputDecoration(
                          errorText: snapshot.error,
                          labelText: "Correo electr??nico",
                          hintText: "email@dominio.com",
                          prefixIcon: IconTheme(
                            data: IconThemeData(color: Colors.grey),
                            child: Icon(Icons.email),
                            ),
                          ),
                          onChanged: _preRegistroBloc.changeEmail,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _preRegistroBloc.noTel,
                    builder: (context, snapshot) {
                      return TextField(
                        keyboardType: TextInputType.phone,
                        controller: _telEditingCtrl,
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                        decoration: InputDecoration(
                          errorText: snapshot.error,
                          labelText: "Tel??fono celular",
                          hintText: "N??mero de celular",
                          prefixIcon: IconTheme(
                            data: IconThemeData(color: Colors.grey),
                            child: Icon(Icons.phone),
                            ),
                          ),
                          onChanged: _preRegistroBloc.changeNoTel,
                      );
                    }
                  ),
                  StreamBuilder<String>(
                    stream: _preRegistroBloc.password,
                    builder: (context, snapshot) {
                      return TextField(
                        obscureText: true,
                        inputFormatters: [LengthLimitingTextInputFormatter(16)],
                        decoration: InputDecoration(
                          errorMaxLines: 2,
                          errorText: snapshot.error,
                          labelText: "Contrase??a",
                          hintText: "Introduce tu contrase??a",
                          prefixIcon: IconTheme(
                            data: IconThemeData(color: Colors.grey),
                            child: Icon(Icons.lock),
                            ),
                          ),
                          onChanged: _preRegistroBloc.changePassword,
                      );
                    }
                  ),
                  SizedBox(height: 45.0),
                  Container(
                    width: size.width,
                    height: UiData.heightMainButtons,
                    child: StreamBuilder<Object>(
                      stream: (selectedTypePerson == 1) ? _preRegistroBloc.submitValidFisica : (selectedTypePerson == 2) ? _preRegistroBloc.submitValidMoral : null,
                      builder: (context, snapshot) {
                        return RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                          ),
                          color:(!snapshot.hasData) ? Colors.grey:  UiData.colorPrimary,
                          onPressed: (!snapshot.hasData) ? (){} : () => _signUp(),
                          child: Text("REGISTRAR", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                        );
                      }
                    ),
                  ),
                  SizedBox(height: 40.0),
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
          stream: _preRegistroBloc.tipoPersona,
          builder: (context, snapshot) {
            return DropdownButton<int>(
              underline: Container(),
              isExpanded: true,
              value: snapshot.data,
              items: [
                DropdownMenuItem<int>(
                  value: 1,
                  child: Text("Persona F??sica"),
                ),
                DropdownMenuItem<int>(
                  value: 2,
                  child: Text("Persona Moral"),
                ),
              ],
              onChanged: (val) {
                FocusScope.of(context).requestFocus(FocusNode());
                if(_preRegistroBloc.tipoPersonaCtrl.value != val) {
                  _preRegistroBloc.changeTipoPersona(val);
                  _preRegistroBloc.changeCurp(null);
                  _preRegistroBloc.changeRfc(null);
                  _curpEditingCtrl.text = "";
                  _rfcEditingCtrl.text = "";
                  setState(() {});
                }
              },
              hint: Text("Selecciona una opci??n", style: TextStyle(color: Colors.black),
              ),
            );
          }
        )
      )
    );
  }

  Widget _buildUsername(Size size, int selectedTypePerson) {
    return (selectedTypePerson == 1) ?
      StreamBuilder<String>(
        stream: _preRegistroBloc.curp,
        builder: (context, snapshot) {
          return TextField(
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [LengthLimitingTextInputFormatter(18)],
            controller: _curpEditingCtrl,
            decoration: InputDecoration(
              errorText: snapshot.error,
              labelText: "CURP",
              hintText: "Introduce tu curp",
              prefixIcon: IconTheme(
                data: IconThemeData(color: Colors.grey),
                child: Icon(Icons.description),
                ),
              ),
              onChanged: _preRegistroBloc.changeCurp,
          );
        }
      ) : (selectedTypePerson == 2) ?
      StreamBuilder<String>(
        stream: _preRegistroBloc.rfc,
        builder: (context, snapshot) {
          return TextField(
            inputFormatters: [LengthLimitingTextInputFormatter(12)],
            textCapitalization: TextCapitalization.characters,
            controller: _rfcEditingCtrl,
            decoration: InputDecoration(
              errorText: snapshot.error,
              labelText: "RFC",
              hintText: "Introduce tu rfc",
              prefixIcon: IconTheme(
                data: IconThemeData(color: Colors.grey),
                child: Icon(Icons.description),
                ),
              ),
              onChanged: _preRegistroBloc.changeRfc,
          );
        }
      ) : Container();
  }
 
  void _signUp() async {
    try{  
      FocusScope.of(context).requestFocus(FocusNode());
      showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
      UserMobile userMobile = UserMobile(
        tipoPersona: _preRegistroBloc.tipoPersonaCtrl.value,
        curp: _preRegistroBloc.curpCtrl.value,
        rfc: _preRegistroBloc.rfcCtrl.value,
        email: _preRegistroBloc.emailCtrl.value,
        phone: _preRegistroBloc.noTelCtrl.value
      );
      AuthRepository authRepository = AuthRepository();
      RegisterRepository registerRepository = RegisterRepository();
      print("Aftter");
      print(UserSingleton.instance.user.toJson().toString());
      //Register User
   Map<String, dynamic> data  =  await authRepository.signInOffline(userMobile: userMobile, password: _preRegistroBloc.passwordCtrl.value);
    UserSingleton.instance.user.id = data["id"];
    UserSingleton.instance.user.token = data["token"];
    UserSingleton.instance.user.email = _preRegistroBloc.emailCtrl.value;
    UserSingleton.instance.user.curp = _preRegistroBloc.curpCtrl.value;
    UserSingleton.instance.user.rfc = data['rfc'];
    UserSingleton.instance.user.nombre = data['nombre'];
    UserSingleton.instance.user.apmaterno = data['apmaterno'];
    UserSingleton.instance.user.appaterno = data['appaterno'];
    UserSingleton.instance.user.fechaDeNacimiento = data['fechaDeNacimiento'];
    registerRepository.setUser(json.encode(UserSingleton.instance.user));
    print("Token");
    print(UserSingleton.instance.user.token );
     
    if (UserSingleton.instance.user.token == null ) {
      hideLoadingDialog();
      print("Tokn null ");
    }else{
      print("Token Existe ");
      hideLoadingDialog();
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pop(true);
      

    }
    } catch (error) {
       hideLoadingDialog();
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        forwardAnimationCurve: Curves.elasticOut,
        backgroundColor: Colors.red,
        leftBarIndicatorColor: Colors.red,
        isDismissible: true,
        duration: Duration(seconds: 8),
        icon: Icon(Icons.close,color: Colors.white,),
        titleText: Text("Mensaje",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white)),
        messageText: Text(error.toString(), style: TextStyle(color: Colors.white)),
      )..show(context);
    } 
   
  }

  @override
  void dispose() {
    _preRegistroBloc.close();
    _curpEditingCtrl.dispose();
    _rfcEditingCtrl.dispose();
    super.dispose();
  }

}
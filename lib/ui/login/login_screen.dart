import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flushbar/flushbar.dart';
import 'package:load/load.dart';
import 'package:siap/blocs/login/login_bloc.dart';
import 'package:siap/models/signin/signin_model.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/repository/auth/auth_repository.dart';
import 'package:siap/repository/connectivity/check_conectivity.dart';
import 'package:siap/repository/register/register_repository.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/ui/widgets/platform_message.dart';
import 'package:siap/utils/settings.dart';
import 'package:siap/utils/ui_data.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc _loginBloc = LoginBloc();
  TextEditingController _curpEditingCtrl = TextEditingController();
  TextEditingController _rfcEditingCtrl = TextEditingController();
  CheckConectivity _checkConectivity = CheckConectivity();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int selectedTypePerson = _loginBloc.tipoPersonaCtrl.value;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(40.0),
                    child: Image.asset(UiData.imgLogoSiap, height: UiData.heightLogo),
                  ),
                  _buildTipoPersona(size),
                  _buildUsername(size, selectedTypePerson),
                  StreamBuilder<String>(
                    stream: _loginBloc.password,
                    builder: (context, snapshot) {
                      return TextField(
                        obscureText: true,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          errorText: snapshot.error,
                          hintStyle: TextStyle(fontSize: 16),
                          labelText: "Contraseña",
                          labelStyle: TextStyle(fontSize: 16),
                          hintText: "Introduce tu contraseña",
                          prefixIcon: IconTheme(
                            data: IconThemeData(color: Colors.grey),
                            child: Icon(Icons.lock),
                            ),
                          ),
                          onChanged: _loginBloc.changePassword,
                      );
                    }
                  ),                  
                  Container(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () => Navigator.of(context).pushNamed(UiData.routeRecovery),
                      child: Padding(
                        padding: EdgeInsets.all(26.0),
                        child: Text("Reestablecer contraseña", style: TextStyle(color: UiData.colorPrimary, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width,
                    height: UiData.heightMainButtons,
                    child: StreamBuilder<bool>(
                      stream: (selectedTypePerson == 1) ? _loginBloc.submitValidFisica : (selectedTypePerson == 2) ? _loginBloc.submitValidMoral : null,
                      builder: (context, snapshot) {
                        return RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                          ),
                          color: UiData.colorPrimary,
                          onPressed: (!snapshot.hasData) ? null : () => _login(),
                          child: Text("INICIAR", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                        );
                      }
                    ),
                  ),
                  SizedBox(height: 40.0),
                  _buildRegisterButton(size),
                  SizedBox(height: 0.0),
                  _buildRegisterOfflineMode(size)
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(Settings.appVersion, style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(Size size) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(UiData.routePreRegister),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        width: size.width,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: "¿Aún no tienes una cuenta? "
              ),
              TextSpan(
                text: "Regístrate",
                style: TextStyle(fontWeight: FontWeight.bold)
              )
            ]
          ),
        ),
      ),
    );
  }
Widget _buildRegisterOfflineMode(Size size) {
    return InkWell(
      onTap: () async {
        bool status =  await _checkConectivity.checkConnectivity();
        await showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
        Future.delayed(const Duration(seconds:4, ) ,() async {
         Future.delayed(Duration(seconds: 1 )).then((_) { hideLoadingDialog();});
            if(status){
              showDialog(
                  builder: (context) => PlatformMessage(
                      title: "Importante",
                      content: "Actualmente estás conectado a internet, para continuar con tu registro en modo offline es necesario desactivar tu internet.",
                      cancelPressed: () => Navigator.of(context).pop(),
                      cancelLabel: "Cancelar",
                      okLabel: "Continuar",
                      okPressed: () async {
                        Navigator.of(context).pushNamed(UiData.routeTypePerson);
                        //await _registerRepository.signOut();
                       // Navigator.of(context).pushNamedAndRemoveUntil(UiData.routeLogin, (e) => false);
                      }
                  ), context: context
                );
            }else{
              showDialog(
                  builder: (context) => PlatformMessage(
                      title: "Importante",
                      content: "Para una mejor experiencia te sugerimos estar desconectado de internet, en cuando termines tu registro  conectarte a internet.",
                      cancelPressed: () => Navigator.of(context).pop(),
                      cancelLabel: "Cancelar",
                      okLabel: "Continuar",
                      okPressed: () async {
                        Navigator.of(context).pushNamed(UiData.routeTypePerson);
                        //await _registerRepository.signOut();
                       // Navigator.of(context).pushNamedAndRemoveUntil(UiData.routeLogin, (e) => false);
                      }
                  ), context: context
                );
            }
        });
        
       // Navigator.of(context).pushNamed(UiData.routeTypePerson);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        width: size.width,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: "¿Registro sin conexión a internet? "
              ),
              TextSpan(
                text: "Iniciar",
                style: TextStyle(fontWeight: FontWeight.bold)
              )
            ]
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

  Widget _buildUsername(Size size, int selectedTypePerson) {
    return (selectedTypePerson == 1) ?
      StreamBuilder<String>(
        stream: _loginBloc.curp,
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
              onChanged: _loginBloc.changeCurp,
          );
        }
      ) : (selectedTypePerson == 2) ?
      StreamBuilder<String>(
        stream: _loginBloc.rfc,
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
              onChanged: _loginBloc.changeRfc,
          );
        }
    ) : Container();
  }

  _login() async {
    try {
      FocusScope.of(context).requestFocus(FocusNode());
      showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
      int tipoPersona = _loginBloc.tipoPersonaCtrl.value;
      UserMobile userMobile = UserMobile(
        tipoPersona: tipoPersona,
        curp: _loginBloc.curpCtrl.value,
        rfc: _loginBloc.rfcCtrl.value
      );
      AuthRepository authRepository = AuthRepository();
      RegisterRepository registerRepository = RegisterRepository();
      UserModel userModel = await authRepository.logIn(userMobile: userMobile, password: _loginBloc.passwordCtrl.value);
      registerRepository.setUser(json.encode(userModel));
      UserSingleton.instance.user = userModel;
      Navigator.of(context).pushNamedAndRemoveUntil(UiData.routeHome, (e) => false);
    } catch (error) {
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
    } finally {
      hideLoadingDialog();
    }
  }

  @override
  void dispose() {
    _loginBloc.close();
    _curpEditingCtrl.dispose();
    _rfcEditingCtrl.dispose();
    super.dispose();
  }

}
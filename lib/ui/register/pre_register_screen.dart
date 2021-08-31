import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:load/load.dart';
import 'package:siap/blocs/register/pre_registro/pre_registro_bloc.dart';
import 'package:siap/models/signin/signin_model.dart';
import 'package:siap/repository/auth/auth_repository.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/utils/ui_data.dart';

class PreRegisterScreen extends StatefulWidget {
  @override
  _PreRegisterScreenState createState() => _PreRegisterScreenState();
}

class _PreRegisterScreenState extends State<PreRegisterScreen> {
  PreRegistroBloc _preRegistroBloc = PreRegistroBloc();
  TextEditingController _curpEditingCtrl = TextEditingController();
  TextEditingController _rfcEditingCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    int selectedTypePerson = _preRegistroBloc.tipoPersonaCtrl.value;
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
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
                        decoration: InputDecoration(
                          errorText: snapshot.error,
                          labelText: "Correo electrónico",
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
                        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                        decoration: InputDecoration(
                          errorText: snapshot.error,
                          labelText: "Teléfono celular",
                          hintText: "Número de celular",
                          prefixIcon: IconTheme(
                            data: IconThemeData(color: Colors.grey),
                            child: Icon(Icons.phone),
                            ),
                          ),
                          onChanged: (value) {
                            
                            if(value.length <=10 ){
                              _preRegistroBloc.changeNoTel(value);
                            }
                            
                          },
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
                          labelText: "Contraseña",
                          hintText: "Introduce tu contraseña",
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
                          color: UiData.colorPrimary,
                          onPressed: (!snapshot.hasData) ? null : () => _signUp(),
                          child: Text("REGISTRAR", style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                        );
                      }
                    ),
                  ),
                  SizedBox(height: 40.0),
                  _buildLoginButton(size)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(Size size) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        width: size.width,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: "¿Ya tienes una cuenta? "
              ),
              TextSpan(
                text: "Inicia sesión",
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
          stream: _preRegistroBloc.tipoPersona,
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
                if(_preRegistroBloc.tipoPersonaCtrl.value != val) {
                  _preRegistroBloc.changeTipoPersona(val);
                  _preRegistroBloc.changeCurp(null);
                  _preRegistroBloc.changeRfc(null);
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
      await authRepository.signIn(userMobile: userMobile, password: _preRegistroBloc.passwordCtrl.value);
      hideLoadingDialog();
      Navigator.of(context).pushNamed(UiData.routeRecoverySuccess, 
      arguments: {
        "title": "Se envió un correo de verificación a ${userMobile.email} para validarlo y continuar el registro en el padrón georreferenciado de productores del sector agroalimentario.",
        "subtitle": "Conserva tu usuario y contraseña para iniciar sesión."
      });
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
    _preRegistroBloc.close();
    _curpEditingCtrl.dispose();
    _rfcEditingCtrl.dispose();
    super.dispose();
  }

}
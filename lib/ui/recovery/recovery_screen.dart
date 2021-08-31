import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';
import 'package:siap/blocs/recovery/recovery_bloc.dart';
import 'package:siap/repository/auth/auth_repository.dart';
import 'package:siap/ui/widgets/custom_loading.dart';
import 'package:siap/utils/ui_data.dart';

class RecoveryScreen extends StatefulWidget {
  @override
  _RecoveryScreenState createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  RecoveryBloc _recoveryBloc = RecoveryBloc();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: UiData.colorAppBar,
            elevation: 0.0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(16.0, size.height * 0.16, 16.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset(UiData.imgLogoSiap, width: size.width),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Reestablecer", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
                      Text("contraseña", style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold))
                    ],
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text("Ingrese su dirección de correo electrónico."),
                ),
                StreamBuilder<String>(
                  stream: _recoveryBloc.email,
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
                        onChanged: _recoveryBloc.changeEmail,
                    );
                  }
                ),
                SizedBox(height: 40.0),
                Container(
                  margin: EdgeInsets.only(bottom: 30.0, top: 10.0),
                  width: size.width,
                  height: UiData.heightMainButtons,
                  child: StreamBuilder<bool>(
                    stream: _recoveryBloc.submitValid,
                    builder: (context, snapshot) {
                      return RaisedButton(
                        color: UiData.colorPrimary,
                        onPressed: (!snapshot.hasData) ? null : () => _submitForm(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(UiData.borderRadiusButton)
                        ),
                        child: Text("ENVIAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                      );
                    }
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    print(_recoveryBloc.emailCtrl.value);
    try {
      showCustomLoadingWidget(CustomLoading(), tapDismiss: false);
      AuthRepository authRepository = AuthRepository();
      String email = await authRepository.recoveryPass(email: _recoveryBloc.emailCtrl.value);
      Navigator.of(context).pushReplacementNamed(UiData.routeRecoverySuccess, arguments: {"title": "Te enviamos un email a $email, con las instrucciones para reestablecer la contraseña."});
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
    _recoveryBloc.close();
    super.dispose();
  }

}
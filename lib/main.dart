


import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:load/load.dart';
import 'package:siap/blocs/register/add_socio/add_socio_bloc.dart';
import 'package:siap/routes/route_generator.dart';
import 'package:siap/utils/navKey.dart';
import 'package:siap/utils/ui_data.dart';
void main() {
  
  ErrorWidget.builder = (errorDetails) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          print("*=*=*=*=*=*=*=*=*=*=*=*=*=ERROR*=*=*=*=*=*=*=*=*=*=*=*=*=");
          print(errorDetails.toString()); 
          return Container(
            color: Colors.white,
            height: double.infinity,
            width: double.infinity,
            child: Center(child: Text("No fue posible procesar esta información."))
          );
        }
      )
    );
  };
  runApp(LoadingProvider(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  
  _configStatusBar() async {
    await FlutterStatusbarcolor.setStatusBarColor(Colors.green);
    if (useWhiteForeground(Colors.green)) {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    } else {
      FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    _configStatusBar();
    
    return  MultiBlocProvider(
          providers: [
            
            BlocProvider<AddSocioBloc>(create: (context) => AddSocioBloc())
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: "Poppins",
              scaffoldBackgroundColor: Colors.white,
              primaryColor: Colors.black,
              accentColor: Colors.green[200],
              accentColorBrightness: Brightness.light,
            ),
            initialRoute: UiData.routeSplash,
            onGenerateRoute: RouteGenerator.generateRoute,
            navigatorKey: NavKey.navKey,
          ),
  
    );
  }
}

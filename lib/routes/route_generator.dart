

import 'package:flutter/material.dart';
import 'package:siap/ui/files/files_screen.dart';
import 'package:siap/ui/help/help_detail_screen.dart';
import 'package:siap/ui/help/help_screen.dart';
import 'package:siap/ui/home/home_screen.dart';
import 'package:siap/ui/home/sector_agroalimentario/sector_agroalimentario_screen.dart';
import 'package:siap/ui/map/map_location_screen.dart';
import 'package:siap/ui/profile/profile_screen.dart';
import 'package:siap/ui/recovery/recovery_success_screen.dart';
import 'package:siap/ui/register/add_socio/add_socio_screen.dart';
import 'package:siap/ui/register/add_socio/socios_screen.dart';
import 'package:siap/ui/register//form_fisica/form_fisica_screen.dart';
import 'package:siap/ui/register/form_moral/form_moral_screen.dart';
import 'package:siap/ui/register/pre_register_screen.dart';
import 'package:siap/ui/register/pre_register_screen_offline.dart';
import 'package:siap/ui/requirement/requirement_screen.dart';
import 'package:siap/ui/login/login_screen.dart';
import 'package:siap/ui/map/map_screen.dart';
import 'package:siap/ui/map/map_screenv2.dart';
import 'package:siap/ui/recovery/recovery_screen.dart';
import 'package:siap/ui/register/register_screen.dart';
import 'package:siap/ui/requirement/requirement_useapp_screen.dart';
import 'package:siap/ui/splash/splash_screen.dart';
import 'package:siap/ui/typePerson/type_person.dart';
import 'package:siap/utils/ui_data.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch(settings.name) {

      case UiData.routeSplash:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case UiData.routeRequirement:
        return MaterialPageRoute(builder: (context) => RequirementScreen());
      case UiData.routeProfile:
        return MaterialPageRoute(builder: (context) => ProfileScreen());
      case UiData.routeLogin:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case UiData.routePreRegister:
        return MaterialPageRoute(builder: (context) => PreRegisterScreen());
      case UiData.routeRegister:
        return MaterialPageRoute(builder: (context) => RegisterScreen());
      case UiData.routeFormFisica:
        return MaterialPageRoute(builder: (context) => FormFisicaScreen());
      case UiData.routeFormMoral:
        return MaterialPageRoute(builder: (context) => FormMoralScreen());
      case UiData.routeAddSocio:
        return MaterialPageRoute(builder: (context) => AddSocioScreen(socio: args));
      case UiData.routeSocios:
        return MaterialPageRoute(builder: (context) => SociosScreen(socios: args));
      case UiData.routeRecovery:
        return MaterialPageRoute(builder: (context) => RecoveryScreen());
      case UiData.routeRecoverySuccess:
        return MaterialPageRoute(builder: (context) => RecoverySuccessScreen(message: args));
      case UiData.routeMap:
        return MaterialPageRoute(builder: (context) => MapScreen());
      case UiData.routeMaps:
        return MaterialPageRoute(builder: (context) => MarkerPage(coords:args));
      case UiData.routeMapLocation:
        /* if(args is LatLng) {
          return MaterialPageRoute(builder: (context) => MapLocationScreen(latLngParcela: args));  
        }
        if(args is List<LatLng>) {
          return MaterialPageRoute(builder: (context) => MapLocationScreen(poligono: args));
        } */
        return MaterialPageRoute(builder: (context) => MapLocationScreen(parcela: args));
      case UiData.routeHome:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case UiData.routeSector:
        return MaterialPageRoute(builder: (context) => SectorAgroalimentarioScreen());
      case UiData.routeHelp:
        return MaterialPageRoute(builder: (context) => HelpScreen());
      case UiData.routeHelpDetail:
        return MaterialPageRoute(builder: (context) => HelpDetailScreen(data: args));
      case UiData.routeFiles:
        return MaterialPageRoute(builder: (context) => FilesScreen());
      //Offline Options Screen
      case UiData.routeTypePerson:
        return MaterialPageRoute(builder: (context) => TypePerson() );
      case UiData.routePreRegisterOffline:
        return MaterialPageRoute(builder: (context) => PreRegisterScreenOffline());
      case UiData.routeRequirementApp:
        return MaterialPageRoute(builder: (context) => RequirementAppScreen());
      default:
        return _errorRoute();

    }
  }

  static MaterialPageRoute<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        body: Center(
          child: Text("Not found screen", textAlign: TextAlign.center, style: Theme.of(context).textTheme.display4)
        ),
      );
    });
  }

}
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meta/meta.dart';
import 'package:siap/utils/ui_data.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpDetailScreen extends StatelessWidget {

  final Map<String, dynamic> data;

  HelpDetailScreen({@required this.data});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
        child: SafeArea(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0),
                Text(data["title"], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
                SizedBox(height: 30.0),
                _buildContent(size)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Size size) {
    switch(data["option"]) {
      case 1:
        return _buildContact();
      case 2:
        return _buildNoticePrivacy(size);
      default:
        return Container(child: Text("Información no disponible"));
    }
  }

  Widget _buildContact() {
    return Column(
      children: <Widget>[
        Text("correo:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
        Icon(FontAwesomeIcons.envelopeOpenText),
        SizedBox(height: 10.0),
        _buildEmailItem("elia.guerrero@siap.gob.mx"),
        Divider(),
        _buildEmailItem("alejandro.diaz@siap.gob.mx"),
        Divider(),
        _buildEmailItem("gustavo.tenorio@siap.gob.mx"),
        Divider(),
        _buildEmailItem("areli.martinez@siap.gob.mx"),
        SizedBox(height: 10.0),
        Text("Tel:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0)),
        Icon(FontAwesomeIcons.phone),
        SizedBox(height: 10.0),
        InkWell(child: Text("5538718500", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue, fontWeight: FontWeight.bold, letterSpacing: 0.5)), onTap: () => _launchURL("tel:5538718500")),
        SizedBox(height: 5.0),
        Text("ext. 48149, 48141 y 48112")
      ],
    );
  }

  Widget _buildEmailItem(String email) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.cyan,
            width: 3.0
          )
        )
      ),
      child: ListTile(
        onTap: () => _launchURL("mailto:$email"),
        leading: Icon(FontAwesomeIcons.solidEnvelope, color: Colors.green),
        title: Text(email),
      ),
    );
  }

  Widget _buildNoticePrivacy(Size size) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text("AVISO DE PRIVACIDAD INTEGRAL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0), textAlign: TextAlign.center),
          SizedBox(height: 15.0),
          Text("El Servicio de Información Agroalimentaria y Pesquera (SIAP), Órgano Administrativo Desconcentrado de la Secretaría de Agricultura y Desarrollo Rural (SADER), con domicilio en Benjamín Franklin 146, Colonia Escandón, Alcaldía Miguel Hidalgo, Código Postal 11800, Ciudad de México.", textAlign: TextAlign.justify),
          SizedBox(height: 10.0),
          Text("¿Qué datos personales se recaban y cuál es la finalidad?", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.justify),
          SizedBox(height: 15.0),
          Text("Los datos personales (nombre completo, CURP, RFC, sexo, escolaridad, estado civil, nacionalidad, fecha de nacimiento, correo electrónico, teléfono particular, domicilio particular, sector agroalimentario (agrícola, pecuario, pesquero, acuícola), principales cultivos/especies, tipo de cultivo (perene/cíclico, superficie (Ha), volumen de producción (Ton), valor de la producción (\$/Ton), precio del cultivo/especie, asociación campesina u organización de productores, régimen hídrico, asociación campesina u organización de productores, régimen de propiedad, identificación oficial vigente, folio de identificación vigente, tipo de discapacidad, declaratoria de indígena, lengua o dialecto que habla, tipo de dirección, tipo de vialidad, código postal, nombre de la vialidad, número exterior, número interior, tipo de asentamiento, nombre del asentamiento, entidad federativa, municipio, localidad y ubicación geográfica (Lat, Long). Estos datos serán utilizados exclusivamente para realizar el registro georreferenciado de los productores del sector agroalimentario de toda la República Mexicana, así como para fines estadísticos.", textAlign: TextAlign.justify),
          SizedBox(height: 10.0),
          Text("Fundamento jurídico que faculta al responsable para llevar a cabo el tratamiento.", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.justify),
          SizedBox(height: 15.0),
          Text("Artículos 17, 26 y 35 de la Ley Orgánica de la Administración Pública Federal; 2 inciso D, fracción V, 3, 17 fracción IV, 44, 45, 46 del Reglamento Interior de la Secretaría de Agricultura, Ganadería, Desarrollo Rural, Pesca y Alimentación, publicado en el Diario Oficial de la Federación “DOF” el 25 de abril del 2012, en relación con el Octavo Transitorio del Decreto por el que se reforman, adicionan y derogan diversas disposiciones de la Ley Orgánica de la Administración Pública Federal, publicado en el “DOF” el 30 de noviembre de 2018; 1, 2, fracción VIII del Reglamento Interior de Servicio de Información Agroalimentaria y Pesquera “SIAP”, publicado en el “DOF” el 29 de agosto de 2013, en relación con lo dispuesto en los diversos 3, fracción II, 20, fracción III, 21, segundo párrafo, y 26 de la Ley General de Protección de Datos Personales en Posesión de Sujetos Obligados.", textAlign: TextAlign.justify),
          SizedBox(height: 10.0),
          Text("Transferencias de datos personales que requieren consentimiento del titular.", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.justify),
          SizedBox(height: 15.0),
          Text("1. Sus datos personales pueden ser transferidos conforme lo establecido en el marco legal aplicable en la materia y dentro de las actividades propias del SIAP. Los cuáles serán transferidos a la propia SADER; con la finalidad de crear padrones secundarios para solicitar y acceder a incentivos productivos. Así mismo, se compartirá su información con la Secretaría del Bienestar; con la finalidad de identificar quien de los productores registrados son candidatos a programas de beneficios.", textAlign: TextAlign.justify),
          SizedBox(height: 10.0),
          Text("2. Si no manifiesta su oposición para que sus datos personales sean transferidos, se entenderá que ha otorgado su consentimiento para ello, en términos del Artículo 21 de la Ley General de Protección de Datos Personales en Posesión de Sujetos Obligados.", textAlign: TextAlign.justify),
          SizedBox(height: 10.0),
          Text("Mecanismos, medios y procedimientos para ejercer derechos de acceso, rectificación, cancelación y oposición (ARCO) al tratamiento de datos personales.", style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.justify),
          SizedBox(height: 15.0),
          Text("Directamente ante la Unidad de Transparencia del SIAP, ubicada en Benjamín Franklin 146, Colonia Escandón, Alcaldía Miguel Hidalgo, Código Postal 11800, Ciudad de México, a través de la Plataforma Nacional de Transparencia www.plataformadetransparencia.org.mx o bien a través del correo electrónico: contacto@siap.gob.mx o comunicarte al teléfono 55 3871 8500.", textAlign: TextAlign.justify),
          SizedBox(height: 10.0),
          Text("Los procedimientos para ejercer los derechos ARCO se encuentran previstos en los Capítulos I y II del Título Tercero de la Ley General de Protección de Datos Personales en Posesión de Sujetos Obligados.", textAlign: TextAlign.justify),
          SizedBox(height: 40.0),
          Container(
            width: size.width,
            child: Text("Última actualización: 24/01/2020", textAlign: TextAlign.end),
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}

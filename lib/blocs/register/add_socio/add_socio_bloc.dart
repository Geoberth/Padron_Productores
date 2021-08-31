import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/validators/general_validator.dart';

class AddSocioBloc extends Bloc with GeneralValidatorsStreams {

  BehaviorSubject<String> tipoDireccionCtrl      = BehaviorSubject<String>();
  BehaviorSubject<int>    tipoVialidadCtrl       = BehaviorSubject<int>();
  BehaviorSubject<String> cpCtrl                 = BehaviorSubject<String>();
  BehaviorSubject<String> nombreVialidadCtrl     = BehaviorSubject<String>();
  BehaviorSubject<String> noInteriorCtrl         = BehaviorSubject<String>();
  BehaviorSubject<String> noExteriorCtrl         = BehaviorSubject<String>();
  BehaviorSubject<int>    tipoAsentamientoCtrl   = BehaviorSubject<int>();
  BehaviorSubject<String> nombreAsentamientoCtrl = BehaviorSubject<String>();
  BehaviorSubject<String> estadoCtrl             = BehaviorSubject<String>();
  BehaviorSubject<String> municipioCtrl          = BehaviorSubject<String>();
  BehaviorSubject<String> localidadCtrl          = BehaviorSubject<String>();
  BehaviorSubject<String> curpCtrl               = BehaviorSubject<String>();
  BehaviorSubject<String> rfcCtrl                = BehaviorSubject<String>();
  BehaviorSubject<String> homoclaveCtrl          = BehaviorSubject<String>();
  // BehaviorSubject<int>    generoCtrl             = BehaviorSubject<int>();
  BehaviorSubject<String> emailCtrl              = BehaviorSubject<String>();
  BehaviorSubject<String> nombreCtrl             = BehaviorSubject<String>();
  BehaviorSubject<String> apPaternoCtrl          = BehaviorSubject<String>();
  BehaviorSubject<String> apMaternoCtrl          = BehaviorSubject<String>();
  BehaviorSubject<int>    estadoCivilCtrl        = BehaviorSubject<int>();
  BehaviorSubject<String> nacionalidadCtrl       = BehaviorSubject<String>();
  BehaviorSubject<String> fechaNacimientoCtrl    = BehaviorSubject<String>();
  BehaviorSubject<String> noTelCtrl              = BehaviorSubject<String>();

  BehaviorSubject<List<GrupoPersonaMoral>> sociosCtrl = BehaviorSubject<List<GrupoPersonaMoral>>();

  Function(String) get changeTipoDireccion => tipoDireccionCtrl.sink.add;
  Function(int)    get changeTipoVialidad => tipoVialidadCtrl.sink.add;
  Function(String) get changeCp => cpCtrl.sink.add;
  Function(String) get changeNombreVialidad => nombreVialidadCtrl.sink.add;
  Function(String) get changeNoInterior => noInteriorCtrl.sink.add;
  Function(String) get changeNoExterior => noExteriorCtrl.sink.add;
  Function(int)    get changeTipoAsentamiento => tipoAsentamientoCtrl.sink.add;
  Function(String) get changeNombreAsentamiento => nombreAsentamientoCtrl.sink.add;
  Function(String) get changeEstado => estadoCtrl.sink.add;
  Function(String) get changeMunicipio => municipioCtrl.sink.add;
  Function(String) get changeLocalidad => localidadCtrl.sink.add;
  Function(String) get changeCurp => curpCtrl.sink.add;
  Function(String) get changeRfc => rfcCtrl.sink.add;
  Function(String) get changeHomoclave => homoclaveCtrl.sink.add;
  // Function(int)    get changeGenero => generoCtrl.sink.add;
  Function(String) get changeEmail => emailCtrl.sink.add;
  Function(String) get changeNombre => nombreCtrl.sink.add;
  Function(String) get changeApPaterno => apPaternoCtrl.sink.add;
  Function(String) get changeApMaterno => apMaternoCtrl.sink.add;
  Function(int)    get changeEstadoCivil => estadoCivilCtrl.sink.add;
  Function(String) get changeNacionalidad => nacionalidadCtrl.sink.add;
  Function(String) get changeFechaNacimiento => fechaNacimientoCtrl.sink.add;
  Function(String) get changeNoTel => noTelCtrl.sink.add;

  Function(List<GrupoPersonaMoral>) get changeSocios => sociosCtrl.sink.add;

  Stream<String> get tipoDireccion => tipoDireccionCtrl.stream.transform(isRequiredDropdownString);
  Stream<int>    get tipoVialidad => tipoVialidadCtrl.stream.transform(isRequiredInt);
  Stream<String> get cp => cpCtrl.stream.transform(isValidCp);
  Stream<String> get nombreVialidad => nombreVialidadCtrl.stream.transform(isRequired);
  Stream<String> get noInterior => noInteriorCtrl.stream.transform(isValidExteriorNum);
  Stream<String> get noExterior => noExteriorCtrl.stream.transform(isValidExteriorNum);
  Stream<int>    get tipoAsentamiento => tipoAsentamientoCtrl.stream.transform(isRequiredInt);
  Stream<String> get nombreAsentamiento => nombreAsentamientoCtrl.stream.transform(isRequired);
  Stream<String> get estado => estadoCtrl.stream.transform(isRequiredDropdownString);
  Stream<String> get municipio => municipioCtrl.stream.transform(isRequiredDropdownString);
  Stream<String> get localidad => localidadCtrl.stream.transform(isRequiredDropdownString);
  Stream<String> get curp => curpCtrl.stream.transform(validateCurp);
  Stream<String> get rfc => rfcCtrl.stream.transform(isRequired);
  Stream<String> get homoclave => homoclaveCtrl.stream;
  // Stream<int>    get genero => generoCtrl.stream.transform(isRequiredInt);
  Stream<String> get email => emailCtrl.stream.transform(validateEmail);
  Stream<String> get nombre => nombreCtrl.stream.transform(isRequired);
  Stream<String> get apPaterno => apPaternoCtrl.stream.transform(isRequired);
  Stream<String> get apMaterno => apMaternoCtrl.stream;
  Stream<int>    get estadoCivil => estadoCivilCtrl.stream.transform(isRequiredInt);
  Stream<String> get nacionalidad => nacionalidadCtrl.stream.transform(isRequiredDropdownString);
  Stream<String> get fechaNacimiento => fechaNacimientoCtrl.stream.transform(isRequired);
  Stream<String> get noTel => noTelCtrl.stream.transform(isValidPhone);

  Stream<List<GrupoPersonaMoral>> get socios => sociosCtrl.stream;

  Stream<bool> get submitValid => Rx.combineLatest([
    curp, rfc, nombre, apPaterno, apMaterno, estadoCtrl,
    nacionalidad, noTel, fechaNacimiento, cp, estado, email,
    municipio, localidad, tipoAsentamiento, nombreAsentamiento,
    tipoDireccion, tipoVialidad, nombreVialidad, noExterior
  ], ([a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t]) => true);

  void checkValidationsForm() {
    changeCurp(curpCtrl.value ?? '');
    changeRfc(rfcCtrl.value ?? '');    
    changeEmail(emailCtrl.value ?? '');
    changeNombre(nombreCtrl.value ?? '');
    changeApPaterno(apPaternoCtrl.value ?? '');
    changeApMaterno(apMaternoCtrl.value ?? '');
    changeEstadoCivil(estadoCivilCtrl.value);
    changeNacionalidad(nacionalidadCtrl.value);
    changeNoTel(noTelCtrl.value ?? '');
    changeFechaNacimiento(fechaNacimientoCtrl.value ?? '');
    changeCp(cpCtrl.value ?? '');
    changeEstado(estadoCtrl.value);
    changeMunicipio(municipioCtrl.value);
    changeLocalidad(localidadCtrl.value);
    changeTipoAsentamiento(tipoAsentamientoCtrl.value);
    changeNombreAsentamiento(nombreAsentamientoCtrl.value ?? '');
    changeTipoDireccion(tipoDireccionCtrl.value);
    changeTipoVialidad(tipoVialidadCtrl.value);
    changeNombreVialidad(nombreVialidadCtrl.value ?? '');
    changeNoExterior(noExteriorCtrl.value ?? '');
  }

  void resetStreamsForm() {
    changeTipoDireccion(null);
    changeTipoVialidad(null);
    changeCp(null);
    changeNombreVialidad(null);
    changeNoInterior(null);
    changeNoExterior(null);
    changeTipoAsentamiento(null);
    changeNombreAsentamiento(null);
    changeEstado(null);
    changeMunicipio(null);
    changeLocalidad(null);
    changeCurp(null);
    changeRfc(null);
    changeHomoclave(null);
    changeEmail(null);
    changeNombre(null);
    changeApPaterno(null);
    changeApMaterno(null);
    changeEstadoCivil(null);
    changeNacionalidad(null);
    changeFechaNacimiento(null);
    changeNoTel(null);
  }

  @override
  get initialState => null;

  @override
  Stream mapEventToState(event) {
    return null;
  }

  @override
  Future<void> close() {
    tipoDireccionCtrl.close();
    tipoVialidadCtrl.close();
    cpCtrl.close();
    nombreVialidadCtrl.close();
    noInteriorCtrl.close();
    noExteriorCtrl.close();
    tipoAsentamientoCtrl.close();
    nombreAsentamientoCtrl.close();
    estadoCtrl.close();
    municipioCtrl.close();
    localidadCtrl.close();
    curpCtrl.close();
    rfcCtrl.close();
    homoclaveCtrl.close();
    emailCtrl.close();
    nombreCtrl.close();
    apPaternoCtrl.close();
    apMaternoCtrl.close();
    estadoCivilCtrl.close();
    nacionalidadCtrl.close();
    fechaNacimientoCtrl.close();
    noTelCtrl.close();
    sociosCtrl.close();
    return super.close();
  }

}

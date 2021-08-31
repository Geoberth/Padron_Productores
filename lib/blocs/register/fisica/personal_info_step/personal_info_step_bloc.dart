import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:siap/validators/general_validator.dart';
import 'package:siap/validators/ine_validator.dart';

class PersonalInfoStepBloc extends Bloc with GeneralValidatorsStreams, IneValidator {

  BehaviorSubject<String> curpCtrl                  = BehaviorSubject<String>();
  BehaviorSubject<String> homoclaveCtrl             = BehaviorSubject<String>();
  BehaviorSubject<String> rfcCtrl                   = BehaviorSubject<String>();
  BehaviorSubject<int>   generoCtrl                 = BehaviorSubject<int>();
  BehaviorSubject<String> nombreCtrl                = BehaviorSubject<String>();
  BehaviorSubject<String> apPaternoCtrl             = BehaviorSubject<String>();
  BehaviorSubject<String> apMaternoCtrl             = BehaviorSubject<String>();
  BehaviorSubject<int> estadoCivilCtrl              = BehaviorSubject<int>();
  BehaviorSubject<String> nacionalidadCtrl          = BehaviorSubject<String>();
  BehaviorSubject<String> fechaNacimientoCtrl       = BehaviorSubject<String>();
  BehaviorSubject<String> emailCtrl                 = BehaviorSubject<String>();
  BehaviorSubject<int> tipoTelCtrl                  = BehaviorSubject<int>();
  BehaviorSubject<String> noTelCtrl                 = BehaviorSubject<String>();
  BehaviorSubject<String> celPhoneCtrl              = BehaviorSubject<String>();
  BehaviorSubject<int> identificacionOficialCtrl    = BehaviorSubject<int>();
  BehaviorSubject<IdentificacionVM> folioIdentificacionCtrl   = BehaviorSubject<IdentificacionVM>();

  Function(String) get changeCurp => curpCtrl.sink.add;
  Function(String) get changeHomoclave => homoclaveCtrl.sink.add;
  Function(String) get changeRfc => rfcCtrl.sink.add;
  Function(int)    get changeGenero => generoCtrl.sink.add;
  Function(String) get changeNombre => nombreCtrl.sink.add;
  Function(String) get changeApPaterno => apPaternoCtrl.sink.add;
  Function(String) get changeApMaterno => apMaternoCtrl.sink.add;
  Function(int)    get changeEstadoCivil => estadoCivilCtrl.sink.add;
  Function(String) get changeNacionalidad => nacionalidadCtrl.sink.add;
  Function(String) get changeFechaNacimiento => fechaNacimientoCtrl.sink.add;
  Function(String) get changeEmail => emailCtrl.sink.add;
  Function(int)    get changeTipoTel => tipoTelCtrl.sink.add;
  Function(String) get changeNoTel => noTelCtrl.sink.add;
  Function(String) get changeCelPhone => celPhoneCtrl.sink.add;
  Function(int)    get changeIdentificacionOficial => identificacionOficialCtrl.sink.add;
  Function(IdentificacionVM) get changeFolioIdentificacion => folioIdentificacionCtrl.sink.add;

  Stream<String> get curp => curpCtrl.stream.transform(validateCurp);
  Stream<String> get homoclave => curpCtrl.stream;
  Stream<String> get rfc => rfcCtrl.stream.transform(isRequired);
  Stream<int>    get genero => generoCtrl.stream.transform(isRequiredInt);
  Stream<String> get nombre => nombreCtrl.stream.transform(isRequired);
  Stream<String> get apPaterno => apPaternoCtrl.stream.transform(isRequired);
  Stream<String> get apMaterno => apMaternoCtrl.stream;
  Stream<int>    get estadoCivil => estadoCivilCtrl.stream.transform(isRequiredInt);
  Stream<String> get nacionalidad => nacionalidadCtrl.stream.transform(isRequired);
  Stream<String> get fechaNacimiento => fechaNacimientoCtrl.stream.transform(isRequired);
  Stream<String> get email => emailCtrl.stream.transform(validateEmail);
  Stream<int>    get tipoTel => tipoTelCtrl.stream.transform(isRequiredInt);
  Stream<String> get noTel => noTelCtrl.stream.transform(isValidPhone);
  Stream<String> get celPhone => celPhoneCtrl.stream.transform(isValidPhone);
  Stream<int>    get identificacionOficial => identificacionOficialCtrl.stream.transform(isRequiredInt);
  Stream<String> get folioIdentificacion => folioIdentificacionCtrl.stream.transform(isIneValidStream);
  
  Stream<bool> get submitValid => Rx.combineLatest(
    [curp, rfc, genero, nombre, apPaterno, apMaterno, estadoCivil,
    nacionalidad, fechaNacimiento, email, tipoTel, noTel, celPhone,
    identificacionOficial, folioIdentificacion], 
    ([a, b, c, d, e, f, g, h, i, j, k, l, m, n, o]) => true);

  @override
  get initialState => null;

  @override
  Stream mapEventToState(event) {
    return null;
  }

  @override
  Future<void> close() {
    curpCtrl.close();
    homoclaveCtrl.close();
    rfcCtrl.close();
    generoCtrl.close();
    nombreCtrl.close();
    apPaternoCtrl.close();
    apMaternoCtrl.close();
    estadoCivilCtrl.close();
    nacionalidadCtrl.close();
    fechaNacimientoCtrl.close();
    emailCtrl.close();
    tipoTelCtrl.close();
    noTelCtrl.close();
    celPhoneCtrl.close();
    identificacionOficialCtrl.close();
    folioIdentificacionCtrl.close();
    return super.close();
  }

}

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:siap/blocs/register/add_socio/add_socio_bloc.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/validators/general_validator.dart';
import 'package:siap/validators/ine_validator2.dart';
class CompanyInfoStepBloc extends Bloc with GeneralValidatorsStreams,IneValidator {
  
  BehaviorSubject<String> rfcCtrl                                = BehaviorSubject<String>();
  BehaviorSubject<String> razonSocialCtrl                        = BehaviorSubject<String>();
  BehaviorSubject<String> fechaConstitucionCtrl                  = BehaviorSubject<String>();
  BehaviorSubject<String> noRegistroConstitucionCtrl             = BehaviorSubject<String>();
  BehaviorSubject<String> noNotarioCtrl                          = BehaviorSubject<String>();
  BehaviorSubject<String> ultimaActualizacionCtrl                = BehaviorSubject<String>();
  BehaviorSubject<String> representanteLegalCtrl                 = BehaviorSubject<String>();
  BehaviorSubject<IdentificacionValidator> noIdentificacionRepresentanteLegalCtrl = BehaviorSubject<IdentificacionValidator>();
  BehaviorSubject<String> totalSociosFisicosCtrl                 = BehaviorSubject<String>();
  BehaviorSubject<String> noSociosMoralesCtrl                    = BehaviorSubject<String>();
  BehaviorSubject<String> emailCtrl                              = BehaviorSubject<String>();
  BehaviorSubject<String> celPhoneCtrl                           = BehaviorSubject<String>();
  BehaviorSubject<String> noTelCtrl                              = BehaviorSubject<String>();
  BehaviorSubject<int> tipoTelCtrl                               = BehaviorSubject<int>();

  Function(String) get changeRfc => rfcCtrl.sink.add;
  Function(String) get changeRazonSocial => razonSocialCtrl.sink.add;
  Function(String) get changeFechaConstitucion => fechaConstitucionCtrl.sink.add;
  Function(String) get changeNoRegistroConstitucion => noRegistroConstitucionCtrl.sink.add;
  Function(String) get changeNoNotario => noNotarioCtrl.sink.add;
  Function(String) get changeUltimaActualizacion => ultimaActualizacionCtrl.sink.add;
  Function(String) get changeRepresentanteLegal => representanteLegalCtrl.sink.add;
  Function(IdentificacionValidator) get changeNoIdentificacionRepresentanteLegal => noIdentificacionRepresentanteLegalCtrl.sink.add;
  Function(String) get changeTotalSociosFisicos => totalSociosFisicosCtrl.sink.add;
  Function(String) get changeNoSociosMorales => noSociosMoralesCtrl.sink.add;
  Function(String) get changeEmail => emailCtrl.sink.add;
  Function(String) get changeCelPhone => celPhoneCtrl.sink.add;
  Function(String) get changeNoTel => noTelCtrl.sink.add;
  Function(int)    get changeTipoTel => tipoTelCtrl.sink.add;

  Stream<String> get rfc => rfcCtrl.stream.transform(validateRfc);
  Stream<String> get razonSocial => razonSocialCtrl.stream.transform(isRequired);
  Stream<String> get fechaConstitucion => fechaConstitucionCtrl.stream.transform(isRequired);
  Stream<String> get noRegistroConstitucion => noRegistroConstitucionCtrl.stream.transform(isRequired);
  Stream<String> get noNotario => noNotarioCtrl.stream.transform(isRequired);
  Stream<String> get ultimaActualizacion => ultimaActualizacionCtrl.stream;
  Stream<String> get representanteLegal => representanteLegalCtrl.stream.transform(isRequired);
  Stream<String> get noIdentificacionRepresentanteLegal => noIdentificacionRepresentanteLegalCtrl.stream.transform(isIneValidStream2);
  Stream<String> get totalSociosFisicos => totalSociosFisicosCtrl.stream.transform(isRequired);
  Stream<String> get noSociosMorales => noSociosMoralesCtrl.stream.transform(isRequired);
  Stream<String> get email => emailCtrl.stream.transform(isRequired);
  Stream<String> get celPhone => celPhoneCtrl.stream.transform(isValidPhone);
  Stream<String> get noTel => noTelCtrl.stream.transform(isValidPhone);
  Stream<int>    get tipoTel => tipoTelCtrl.stream.transform(isRequiredInt);

  Stream<bool> get submitValid => Rx.combineLatest(
    [rfc, razonSocial, fechaConstitucion, noRegistroConstitucion,
    noNotario, representanteLegal,
    noIdentificacionRepresentanteLegal, totalSociosFisicos,
    noSociosMorales, email, celPhone, noTel, tipoTel
  ], ([a,b,c,d,e,f,g,h,i,j,k,l,m]) => true);

  void initSimpleDataForm(UserModel userModel, AddSocioBloc addSocioBloc) {
    if(userModel.razonSocial != null) {
      changeRazonSocial(userModel.razonSocial);
    }
    if(userModel.rfc != null) {
      changeRfc(userModel.rfc );
    }
    if(userModel.fechaConstitucion != null) {
      changeFechaConstitucion(userModel.fechaConstitucion);
    }
    if(userModel.noRegistroInstrumentoConstitucion != null) {
      changeNoRegistroConstitucion(userModel.noRegistroInstrumentoConstitucion);
    }
    if(userModel.noNotario != null) {
      changeNoNotario(userModel.noNotario);
    }
    if(userModel.ultimaActualizacionActaConstitutiva != null) {
      changeUltimaActualizacion(userModel.ultimaActualizacionActaConstitutiva);
    }
    if(userModel.representanteLegal != null) {
      changeRepresentanteLegal(userModel.representanteLegal);
    }
    if(userModel.noIdentificacionRepresentanteLegal != null) {
    changeNoIdentificacionRepresentanteLegal(IdentificacionValidator(valor:userModel.noIdentificacionRepresentanteLegal ));
    }
    if(userModel.totalSociosFisicos != null) {
      changeTotalSociosFisicos(userModel.totalSociosFisicos.toString());
    }
    if(userModel.grupoPersonasMorales != null) {
      changeNoSociosMorales(userModel.grupoPersonasMorales.length.toString());
      addSocioBloc.changeSocios(userModel.grupoPersonasMorales);
    }
    if(userModel.email != null) {
      changeEmail(userModel.email);
    }
    if(userModel.celPhone != null) {
      changeCelPhone(userModel.celPhone);
    }
    if(userModel.tipoTel != null) {
      changeTipoTel(userModel.tipoTel);
    }
    if(userModel.noTel != null) {
      changeNoTel(userModel.noTel);
    }
  }

  void checkValidationsForm() {
    changeRfc(rfcCtrl.value ?? '');
    changeEmail(emailCtrl.value ?? '');
    changeCelPhone(celPhoneCtrl.value ?? '');
    changeTipoTel(tipoTelCtrl.value);
    changeNoTel(noTelCtrl.value ?? '');
    changeRazonSocial(razonSocialCtrl.value ?? '');
    changeFechaConstitucion(fechaConstitucionCtrl.value ?? '');
    changeNoRegistroConstitucion(noRegistroConstitucionCtrl.value ?? '');
    changeNoNotario(noNotarioCtrl.value ?? '');
    changeUltimaActualizacion(ultimaActualizacionCtrl.value ?? '');
    changeRepresentanteLegal(representanteLegalCtrl.value ?? '');
    changeNoIdentificacionRepresentanteLegal(noIdentificacionRepresentanteLegalCtrl.value ?? '');
    changeTotalSociosFisicos(totalSociosFisicosCtrl.value ?? '');
    changeNoSociosMorales(noSociosMoralesCtrl.value ?? '');
  }

  @override
  get initialState => null;

  @override
  Stream mapEventToState(event) {
    return null;
  }

  @override
  Future<void> close() {
    rfcCtrl.close();
    razonSocialCtrl.close();
    fechaConstitucionCtrl.close();
    noRegistroConstitucionCtrl.close();
    noNotarioCtrl.close();
    ultimaActualizacionCtrl.close();
    representanteLegalCtrl.close();
    noIdentificacionRepresentanteLegalCtrl.close();
    totalSociosFisicosCtrl.close();
    noSociosMoralesCtrl.close();
    emailCtrl.close();
    celPhoneCtrl.close();
    noTelCtrl.close();
    tipoTelCtrl.close();
    return super.close();
  }

}

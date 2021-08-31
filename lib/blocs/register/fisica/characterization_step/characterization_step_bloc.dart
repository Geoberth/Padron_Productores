import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:siap/validators/general_validator.dart';

class CharacterizationStepBloc extends Bloc with GeneralValidatorsStreams {

  BehaviorSubject<String> tipoAsociacionCtrl        = BehaviorSubject<String>();
  BehaviorSubject<int> regimenPropiedadCtrl         = BehaviorSubject<int>();
  BehaviorSubject<String> cuentaDiscapacidadCtrl    = BehaviorSubject<String>();
  BehaviorSubject<String> tipoDiscapacidadCtrl      = BehaviorSubject<String>();
  BehaviorSubject<String> declaratoriaIndigenaCtrl  = BehaviorSubject<String>();
  BehaviorSubject<String> nivelEstudiosCtrl         = BehaviorSubject<String>();
  BehaviorSubject<String> hablaEspanolCtrl          = BehaviorSubject<String>();
  BehaviorSubject<String> hablaLenguaIndigenaCtrl   = BehaviorSubject<String>();
  BehaviorSubject<String> lenguaIndigenaCtrl        = BehaviorSubject<String>();
  BehaviorSubject<String> puebloEtniaCtrl           = BehaviorSubject<String>();
  
  Function(String) get changeTipoAsociacion => tipoAsociacionCtrl.sink.add;
  Function(int) get changeRegimenPropiedad => regimenPropiedadCtrl.sink.add;
  Function(String) get changeCuentaDiscapacidad => cuentaDiscapacidadCtrl.sink.add;
  Function(String) get changeTipoDiscapacidad => tipoDiscapacidadCtrl.sink.add;
  Function(String) get changeDeclaratoriaIndigena => declaratoriaIndigenaCtrl.sink.add;
  Function(String) get changeNivelEstudios => nivelEstudiosCtrl.sink.add;
  Function(String) get changeHablaEspanol => hablaEspanolCtrl.sink.add;
  Function(String) get changeHablaLenguaIndigena => hablaLenguaIndigenaCtrl.sink.add;
  Function(String) get changeLenguaIndigena => lenguaIndigenaCtrl.sink.add;
  Function(String) get changePuebloEtnia => puebloEtniaCtrl.sink.add;

  Stream<String> get tipoAsociacion => tipoAsociacionCtrl.stream;
  Stream<int>    get regimenPropiedad => regimenPropiedadCtrl.stream.transform(isRequiredInt);
  Stream<String> get cuentaDiscapacidad => cuentaDiscapacidadCtrl.stream.transform(isRequired);
  Stream<String>    get tipoDiscapacidad => tipoDiscapacidadCtrl.stream.transform(isRequired);
  Stream<String> get declaratoriaIndigena => declaratoriaIndigenaCtrl.stream.transform(isRequired);
  Stream<String> get nivelEstudios => nivelEstudiosCtrl.stream.transform(isRequired);
  Stream<String> get hablaEspanol => hablaEspanolCtrl.stream.transform(isRequired);
  Stream<String> get hablaLenguaIndigena => hablaLenguaIndigenaCtrl.stream.transform(isRequired);
  Stream<String> get lenguaIndigena => lenguaIndigenaCtrl.stream.transform(isRequired);
  Stream<String> get puebloEtnia => puebloEtniaCtrl.stream.transform(isRequired);


  Stream<bool> get submitValid => Rx.combineLatest(
      [regimenPropiedad, cuentaDiscapacidad, 
      nivelEstudios, hablaEspanol, hablaLenguaIndigena], 
      ([a, b, c, d, e]) => true);

  Stream<bool> get submitValid2 => Rx.combineLatest(
      [regimenPropiedad, cuentaDiscapacidad, tipoDiscapacidad,
      nivelEstudios, hablaEspanol, hablaLenguaIndigena], 
      ([a, b, c, d, e, f]) => true);

  Stream<bool> get submitValid3 => Rx.combineLatest(
      [regimenPropiedad, cuentaDiscapacidad, 
      nivelEstudios, hablaEspanol, hablaLenguaIndigena, declaratoriaIndigena], 
      ([a, b, c, d, e, f]) => true);

  Stream<bool> get submitValid4 => Rx.combineLatest(
      [regimenPropiedad, cuentaDiscapacidad, tipoDiscapacidad,
      nivelEstudios, hablaEspanol, hablaLenguaIndigena, declaratoriaIndigena], 
      ([a, b, c, d, e, f, g]) => true);

  @override
  get initialState => null;

  @override
  Stream mapEventToState(event) {
    return null;
  }

  @override
  Future<void> close() {
    tipoAsociacionCtrl.close();
    regimenPropiedadCtrl.close();
    cuentaDiscapacidadCtrl.close();
    tipoDiscapacidadCtrl.close();
    declaratoriaIndigenaCtrl.close();
    nivelEstudiosCtrl.close();
    hablaEspanolCtrl.close();
    hablaLenguaIndigenaCtrl.close();
    lenguaIndigenaCtrl.close();
    puebloEtniaCtrl.close();
    return super.close();
  }

}
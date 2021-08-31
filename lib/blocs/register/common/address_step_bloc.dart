import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:siap/validators/general_validator.dart';

class AddressStepBloc extends Bloc with GeneralValidatorsStreams {

  BehaviorSubject<String> tipoDireccionCtrl       = BehaviorSubject<String>();
  BehaviorSubject<int> tipoVialidadCtrl           = BehaviorSubject<int>();
  BehaviorSubject<String> cpCtrl                  = BehaviorSubject<String>();
  BehaviorSubject<String> nombreVialidadCtrl      = BehaviorSubject<String>();
  BehaviorSubject<String> noInteriorCtrl          = BehaviorSubject<String>();  
  BehaviorSubject<String> noExteriorCtrl          = BehaviorSubject<String>();
  BehaviorSubject<int> tipoAsentamientoCtrl       = BehaviorSubject<int>();
  BehaviorSubject<String> nombreAsentamientoCtrl  = BehaviorSubject<String>();
  BehaviorSubject<String> estadoCtrl              = BehaviorSubject<String>();
  BehaviorSubject<String> municipioCtrl           = BehaviorSubject<String>();
  BehaviorSubject<String> localidadCtrl           = BehaviorSubject<String>();
  BehaviorSubject<String> centroIntegradorCtrl    = BehaviorSubject<String>();
  BehaviorSubject<String> ubicacionGeoCtrl        = BehaviorSubject<String>();
  

  Function(String) get changeTipoDireccion => tipoDireccionCtrl.sink.add;
  Function(int) get changeTipoVialidad => tipoVialidadCtrl.sink.add;
  Function(String) get changeCp => cpCtrl.sink.add;
  Function(String) get changeNombreVialidad => nombreVialidadCtrl.sink.add;
  Function(String) get changeNoInterior => noInteriorCtrl.sink.add;
  Function(String) get changeNoExterior => noExteriorCtrl.sink.add;
  Function(int) get changeTipoAsentamiento => tipoAsentamientoCtrl.sink.add;
  Function(String) get changeNombreAsentamiento => nombreAsentamientoCtrl.sink.add;
  Function(String) get changeEstado => estadoCtrl.sink.add;
  Function(String) get changeMunicipio => municipioCtrl.sink.add;
  Function(String) get changeLocalidad => localidadCtrl.sink.add;
  Function(String) get changeCentroIntegrador => centroIntegradorCtrl.sink.add;
  Function(String) get changeUbicacionGeo => ubicacionGeoCtrl.sink.add;

  Stream<String> get tipoDireccion => tipoDireccionCtrl.stream.transform(isRequiredDropdownString);
  Stream<int> get tipoVialidad => tipoVialidadCtrl.stream.transform(isRequiredInt);
  Stream<String> get cp => cpCtrl.stream.transform(isValidCp);
  Stream<String> get nombreVialidad => nombreVialidadCtrl.stream.transform(isRequired);
  Stream<String> get noInterior => noInteriorCtrl.stream.transform(isValidExteriorNum);
  Stream<String> get noExterior => noExteriorCtrl.stream.transform(isValidExteriorNum);
  Stream<int> get tipoAsentamiento => tipoAsentamientoCtrl.stream.transform(isRequiredInt);
  Stream<String> get nombreAsentamiento => nombreAsentamientoCtrl.stream.transform(isRequired);
  Stream<String> get estado => estadoCtrl.stream.transform(isRequiredDropdownString);
  Stream<String> get municipio => municipioCtrl.stream.transform(isRequiredDropdownString);
  Stream<String> get localidad => localidadCtrl.stream.transform(isRequiredDropdownString);
  Stream<String> get centroIntegrador => centroIntegradorCtrl.stream.transform(isRequiredDropdownString);
  Stream<String> get ubicacionGeo => ubicacionGeoCtrl.stream;
  
  Stream<bool> get submitValid => Rx.combineLatest(
    [tipoDireccion, tipoVialidad, cp, nombreVialidad, noExterior, tipoAsentamiento,
    nombreAsentamiento, estado, municipio, localidad, centroIntegrador, ubicacionGeo], 
    ([a, b, c, d, e, f, g, h, i, j, k, l]) => true);

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
    centroIntegradorCtrl.close();
    ubicacionGeoCtrl.close();
    return super.close();
  }

}

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/validators/general_validator.dart';

class ProductionStepBloc extends Bloc with GeneralValidatorsStreams {

  BehaviorSubject<int> sectorAgroalimentarioCtrl        = BehaviorSubject<int>();
  BehaviorSubject<String> principalCultivoEspecieCtrl   = BehaviorSubject<String>();
  BehaviorSubject<String> principalProductoCtrl         = BehaviorSubject<String>();
  BehaviorSubject<int> regimenHidricoCtrl               = BehaviorSubject<int>();
  BehaviorSubject<int> tipoCultivoCtrl                  = BehaviorSubject<int>();
  BehaviorSubject<String> superficieCtrl                = BehaviorSubject<String>();
  BehaviorSubject<String> volumenProduccionCtrl         = BehaviorSubject<String>();
  BehaviorSubject<String> valorProduccionCtrl           = BehaviorSubject<String>();
  BehaviorSubject<String> precioCtrl                    = BehaviorSubject<String>();
   BehaviorSubject<String> typeOfHoneyProducerCtrl        = BehaviorSubject<String>();

  BehaviorSubject<String> typeOfHoneyProducerCodeCtrl   = BehaviorSubject<String>();
  BehaviorSubject<String> numberOfHivesCtrl             = BehaviorSubject<String>();
  BehaviorSubject<String> amountOfBelliesCtrl          = BehaviorSubject<String>();
  BehaviorSubject<String> numberOfPlantsHaCtrl         = BehaviorSubject<String>();
  BehaviorSubject<List<Produccion>> produccionCtrl      = BehaviorSubject<List<Produccion>>();

  Function(int) get changeSectorAgroalimentario => sectorAgroalimentarioCtrl.sink.add;
  Function(String) get changePrincipalCultivoEspecie => principalCultivoEspecieCtrl.sink.add;
  Function(String) get changePrincipalProducto => principalProductoCtrl.sink.add;
  Function(int) get changeRegimenHidrico => regimenHidricoCtrl.sink.add;
  Function(int) get changeTipoCultivo => tipoCultivoCtrl.sink.add;
  Function(List<Produccion>) get changeProduccion => produccionCtrl.sink.add;
  Function(String) get changeSuperficie => superficieCtrl.sink.add;
  Function(String) get changeVolumenProduccion => volumenProduccionCtrl.sink.add;
  Function(String) get changeValorProduccion => valorProduccionCtrl.sink.add;
  Function(String) get changePrecio => precioCtrl.sink.add;
  Function(String) get changetypeOfHoneyProducer => typeOfHoneyProducerCtrl.sink.add;
  Function(String) get changetypeOfHoneyProducerCode => typeOfHoneyProducerCodeCtrl.sink.add;
  Function(String) get changeNumberOfHives => numberOfHivesCtrl.sink.add;
  Function(String) get changeAmountOfBellies => amountOfBelliesCtrl.sink.add;
  Function(String) get changenumberOfPlantsHa => numberOfPlantsHaCtrl.sink.add;

  Stream<int> get sectorAgroalimentario => sectorAgroalimentarioCtrl.stream;
  Stream<String> get principalCultivoEspecie => principalCultivoEspecieCtrl.stream;
  Stream<String> get principalProducto => principalProductoCtrl.stream;
  Stream<int>    get regimenHidrico => regimenHidricoCtrl.stream;
  Stream<int> get tipoCultivo => tipoCultivoCtrl.stream;
  Stream<List<Produccion>> get produccion => produccionCtrl.stream;
  Stream<String> get superficie => superficieCtrl.stream.transform(isGreaterThanZero1);
  Stream<String> get volumenProduccion => volumenProduccionCtrl.stream.transform(isGreaterThanZero2);
  Stream<String> get valorProduccion => valorProduccionCtrl.stream;
  Stream<String> get precio => precioCtrl.stream.transform(isGreaterThanZero3);

  Stream<String> get typeOfHoneyProducer => typeOfHoneyProducerCtrl.stream;
  Stream<String> get typeOfHoneyProducerCode => typeOfHoneyProducerCodeCtrl.stream;
  Stream<String> get numberOfHives => numberOfHivesCtrl.stream;
  Stream<String> get amountOfBellies => amountOfBelliesCtrl.stream;
  Stream<String> get numberOfPlantsHa => numberOfPlantsHaCtrl.stream;
  @override
  get initialState => null;

  @override
  Stream mapEventToState(event) {
    return null;
  }

  @override
  Future<void> close() {
    sectorAgroalimentarioCtrl.close();
    principalCultivoEspecieCtrl.close();
    principalProductoCtrl.close();
    regimenHidricoCtrl.close();
    tipoCultivoCtrl.close();
    produccionCtrl.close();
    superficieCtrl.close();
    volumenProduccionCtrl.close();
    valorProduccionCtrl.close();
    precioCtrl.close();
     numberOfHivesCtrl.close();
    amountOfBelliesCtrl.close();
    numberOfPlantsHaCtrl.close();
    typeOfHoneyProducerCtrl.close();
    typeOfHoneyProducerCodeCtrl.close();
    return super.close();
  }

}
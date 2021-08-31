import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:siap/validators/general_validator.dart';

class PreRegistroBloc extends Bloc with GeneralValidatorsStreams {

  BehaviorSubject<int>    tipoPersonaCtrl = BehaviorSubject<int>();
  BehaviorSubject<String> curpCtrl        = BehaviorSubject<String>();
  BehaviorSubject<String> rfcCtrl         = BehaviorSubject<String>();
  BehaviorSubject<String> emailCtrl       = BehaviorSubject<String>();
  BehaviorSubject<String> noTelCtrl       = BehaviorSubject<String>();
  BehaviorSubject<String> passwordCtrl    = BehaviorSubject<String>();

  Function(int) get changeTipoPersona => tipoPersonaCtrl.sink.add;
  Function(String) get changeCurp => curpCtrl.sink.add;
  Function(String) get changeRfc => rfcCtrl.sink.add;
  Function(String) get changeEmail => emailCtrl.sink.add;
  Function(String) get changeNoTel => noTelCtrl.sink.add;
  Function(String) get changePassword => passwordCtrl.sink.add;

  Stream<int> get tipoPersona => tipoPersonaCtrl.stream;
  Stream<String> get curp => curpCtrl.stream.transform(validateCurp);
  Stream<String> get rfc => rfcCtrl.stream.transform(validateRfc);
  Stream<String> get email => emailCtrl.stream.transform(validateEmail);
  Stream<String> get noTel => noTelCtrl.stream.transform(isValidPhone);
  Stream<String> get password => passwordCtrl.stream.transform(isValidPassword);

  Stream<bool> get submitValidFisica => Rx.combineLatest(
    [curp, email, noTel, password], ([a, b, c, d]) => true);

  Stream<bool> get submitValidMoral => Rx.combineLatest(
    [rfc, email, noTel, password], ([a, b, c, d]) => true);

  @override
  get initialState => null;

  @override
  Stream mapEventToState(event) {
    return null;
  }

  @override
  Future<void> close() {
    tipoPersonaCtrl.close();
    curpCtrl.close();
    rfcCtrl.close();
    emailCtrl.close();
    noTelCtrl.close();
    passwordCtrl.close();
    return super.close();
  }

}
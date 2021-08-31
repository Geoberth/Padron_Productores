import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:siap/validators/general_validator.dart';

class RecoveryBloc extends Bloc with GeneralValidatorsStreams{
  
  BehaviorSubject<String> emailCtrl = BehaviorSubject<String>();
  Function(String) get changeEmail => emailCtrl.sink.add;
  Stream<String> get email => emailCtrl.stream.transform(validateEmail);

  Stream<bool> get submitValid => Rx.combineLatest([email], ([a]) => true);

  @override
  get initialState => null;

  @override
  Stream mapEventToState(event) {
    return null;
  }

  @override
  Future<void> close() {
    emailCtrl.close();
    return super.close();
  }
}

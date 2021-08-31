import 'dart:async';

class SignupValidators {

  final isRequired = StreamTransformer<String, String>.fromHandlers(
    handleData: (field, sink) {
      if(field.trim().length > 0) {
        sink.add(field);
      }else {
        sink.addError("Este campo es requerido.");
      }
    }
  );

  final isRequiredCombo = StreamTransformer<int, int>.fromHandlers(
    handleData: (field, sink) {
      if(field != null) {
        sink.add(field);
      }else {
        sink.addError("Este campo es requerido.");
      }
    }
  );

  final isValidPhone = StreamTransformer<String, String>.fromHandlers(
    handleData: (phone, sink) {
      if(phone.trim().length == 10) {
        sink.add(phone);
      }else {
        sink.addError("Introduce 10 dígitos.");
      }
    }
  );

}
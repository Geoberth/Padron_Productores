import 'dart:async';

class AuthValidators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );  

  final isValidEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      if(_emailRegExp.hasMatch(email)) {
        sink.add(email);
      }else {
        sink.addError("Introduce un email válido.");
      }
    });

  final isValidPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if(password.trim().length > 5) {
        sink.add(password);
      }else {
        sink.addError("Introduce una contraseña segura.");
      }
    }
  );

}
import 'dart:async';
/* class GeneralValidators {

  isRequired(String value) {
    if (value.isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }

  validateEmail(String value) {
    final RegExp _emailRegExp = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );
    if (value.isEmpty) {
      return 'Este campo es requerido';
    }
    if(!_emailRegExp.hasMatch(value)) {
      return 'Introduce un correo valido';
    }
    return null;
  }

  validateRfc(String value) {
    final RegExp _rfcRegExp = RegExp(
      r'^([A-ZÑ&]{3,4}) ?(?:- ?)?(\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])) ?(?:- ?)?([A-Z\d]{2})([A\d])$',
    );
    if (value.isEmpty) {
      return 'Este campo es requerido';
    }
    if(!_rfcRegExp.hasMatch(value)) {
      return 'Introduce un RFC valido';
    }
    return null;
  }

  validateCurp(String value) {
    final RegExp _rfcRegExp = RegExp(
      r'^([A-Z][AEIOUX][A-Z]{2}\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])[HM](?:AS|B[CS]|C[CLMSH]|D[FG]|G[TR]|HG|JC|M[CNS]|N[ETL]|OC|PL|Q[TR]|S[PLR]|T[CSL]|VZ|YN|ZS)[B-DF-HJ-NP-TV-Z]{3}[A-Z\d])(\d)$',
    );
    if (value.isEmpty) {
      return 'Este campo es requerido';
    }
    if(!_rfcRegExp.hasMatch(value)) {
      return 'Introduce un CURP valido';
    }
    return null;
  }
} */

class GeneralValidatorsStreams {
  final isRequired =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value == null) {
      sink.addError(value);
    } else {
      if (value.isEmpty) {
        sink.addError("Este campo es requerido.");
      } else {
        sink.add(value);
      }
    }
  });
  final isGreaterThanZero1 =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value == null) {
      sink.addError(value);
    } else {
      if (value.isEmpty) {
        sink.addError("Este campo es requerido.");
      } else {
        print('val $value');
       if( double.tryParse(value) != null){
         print('isNumber');
         var val = double.tryParse(value);
        if (val < 0.1) {
          sink.addError("superficie  debe ser mayor igual que 0.1.");
          } else {
          sink.add(value);
          }
       }
        
      }
    }
  });
  final isGreaterThanZero2 =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value == null) {
      sink.addError(value);
    } else {
      if (value.isEmpty) {
        sink.addError("Este campo es requerido.");
      } else {
       
         if( double.tryParse(value) != null){
           var val = double.tryParse(value);
              if (val < 0.1) {
                sink.addError("volumen de producción  debe ser mayor igual que 0.1.");
              } else {
                sink.add(value);
              }
            }
          }
        }
      });
  final isGreaterThanZero3 =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value == null) {
      sink.addError(value);
    } else {
      if (value.isEmpty) {
        sink.addError("Este campo es requerido.");
      } else {

         if( double.tryParse(value) != null){
           var val = double.parse(value);
        if (val < 0.1) {
          sink.addError("precio debe ser mayor igual que 0.1.");
        } else {
          sink.add(value);
        }
         }
      }
    }
  });
  final isRequiredInt =
      StreamTransformer<int, int>.fromHandlers(handleData: (value, sink) {
    if (value == null) {
      sink.addError("Este campo es requerido.");
    } else {
      sink.add(value);
    }
  });

  final isRequiredDropdownString =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value == null) {
      sink.addError("Este campo es requerido.");
    } else {
      sink.add(value);
    }
  });

  final isValidCp =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    final int length = 5;
    if (value == null) {
      sink.addError(value);
    } else {
      if (value.isEmpty) {
        sink.addError("Este campo es requerido.");
      } else if (value.length < length) {
        sink.addError("Introduce $length dígitos");
      } else {
        sink.add(value);
      }
    }
  });
  final isValidExteriorNum =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    final int length = 8;
    if (value == null) {
      // sink.addError(value);
    } else {
      if (value.isEmpty) {
        //sink.addError("Este campo es requerido.");
      } else if (value.length > length) {
        sink.addError("Introduce maximo $length dígitos");
      } else {
        sink.add(value);
      }
    }
  });
  final isValidPhone =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    final length = 10;

    if (value == null) {
      sink.addError(value);
    } else {
      if (value.isEmpty) {
        sink.addError("Este campo es requerido.");
      } else {
        if (value.length < length) {
          sink.addError("Introduce $length dígitos");
        } else {
          if (value.length >= 11) {
            print('Length');
            print(value);
            print('subtsring');
            print(substr(value, 0, 10));
            sink.add(substr(value, 0, 10));
          } else {
            print('Length 2');
            print(value);
            sink.add(value);
          }
        }
      }
    }
  });

  final isValidPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    final length = 8;
    if (password == null) {
      sink.addError(password);
    } else {
      if (password.trim().length >= length) {
        sink.add(password);
      } else {
        sink.addError(
            "Introduce una contraseña mayor o igual a $length caracteres.");
      }
    }
  });

  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    final RegExp _emailRegExp = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
    );
    if (value == null) {
      sink.addError(value);
    } else {
      if (value.isEmpty) {
        sink.addError("Este campo es requerido.");
      }
      if (!_emailRegExp.hasMatch(value)) {
        sink.addError('Introduce un correo valido');
      } else {
        sink.add(value);
      }
    }
  });

  final validateRfc =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    final RegExp _rfcRegExp = RegExp(
      r'^([A-ZÑ&]{3}) ?(?:- ?)?(\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])) ?(?:- ?)?([A-Z\d]{2})([A\d])$',
    );
    if (value == null) {
      sink.addError(value);
    } else {
      if (value.isEmpty) {
        sink.addError("Este campo es requerido.");
      }
      if (!_rfcRegExp.hasMatch(value)) {
        sink.addError('Introduce un RFC valido');
      } else {
        sink.add(value);
      }
    }
  });

  final validateCurp =
      StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    final RegExp _curpRegExp = RegExp(
      r'^([A-Z][AEIOUX][A-Z]{2}\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])[HM](?:AS|B[CS]|C[CLMSH]|D[FG]|G[TR]|HG|JC|M[CNS]|N[ETL]|OC|PL|Q[TR]|S[PLR]|T[CSL]|VZ|YN|ZS)[B-DF-HJ-NP-TV-Z]{3}[A-Z\d])(\d)$',
    );
    if (value == null) {
      sink.addError(value);
    } else {
      if (value.isEmpty) {
        sink.addError("Este campo es requerido.");
      }
      if (!_curpRegExp.hasMatch(value)) {
        sink.addError('Introduce un CURP valido');
      } else {
        sink.add(value);
      }
    }
  });
}

String substr(String subject, [int start = 0, int length]) {
  if (subject is! String) {
    return '';
  }

  int _realEnd;
  int _realStart = start < 0 ? subject.length + start : start;
  if (length is! int || length < 0 || _realStart + length >= subject.length) {
    _realEnd = subject.length;
  } else {
    _realEnd = _realStart + length;
  }

  return subject.substring(_realStart, _realEnd);
}


import 'dart:async';

class IdentificacionVM {
  String valor;
  int tipoIdentificacion;

  IdentificacionVM({this.valor, this.tipoIdentificacion});
}

class IneValidator {

  // Se usa dentro de una validacion dentro del widget
  String isIneValid(String value, int tipoIdentificacion) {
    if (tipoIdentificacion == 1) {
      return _onValidateIne(value);
    }
    return null;
  }

  // Se usa en una validación dentro de un stream
  final isIneValidStream = StreamTransformer<IdentificacionVM, String>.fromHandlers(
    handleData: (item, sink) {
      if (item.valor == null) {
        sink.addError(item.valor);
      } else  {
        if (item.tipoIdentificacion == 1) {
          String validation = IneValidator()._onValidateIne(item.valor);
          if (validation == null) {
            sink.add(item.valor);
          } else {
            sink.addError(validation);
          }
        } else {
          String validation = IneValidator()._onValidatePassport(item.valor);
          if (item.valor.isEmpty) {
            sink.addError("Este campo es requerido.");
          }else if(validation == null) {
            sink.add(item.valor);
          } else {
            sink.addError(validation);
          }     
        } 
      }
  });
   final isValidPassport = StreamTransformer<String, String>.fromHandlers(
    handleData: (value, sink) {
      final int length = 10;
      if (value == null) {
        sink.addError(value);
      } else  {
        if (value.isEmpty) {
          sink.addError("Este campo es requerido.");
        }else if (value.length < length) {
          sink.addError("Introduce $length dígitos");
        } else {
          sink.add(value);
        }
      }
    }
  );
  String _onValidatePassport(String value){
    String cve = value;
    if(cve.length == 10){
      return null;
    }else {
      return "Introduce 10 caracteres";
    }
  }
  String _onValidateIne(String value) {
    String cve = value;

    if (cve.length == 18) {
        final int divisor = 10;
        RegExp regexp = RegExp(r'^([a-zA-Z]{6})([0-9]{6})([0-9]{2})(H|M{1})([0-9]{1})([0-9]{2})$');
        final allMatches = regexp.allMatches(cve).map((m) => m);
        final RegExpMatch subcve = (allMatches.length > 0) ? allMatches.first : null;

        if (subcve == null) {
            return "La clave no es válida";
        }
        else {
            final String claveTrunc = subcve.group(1) + subcve.group(2) + subcve.group(3);
            final int vIfe = int.parse(subcve.group(5));
            int pos = 1;
            int suma = 0;

            for (String item in claveTrunc.split("")) {
                suma = suma + _numera(item, pos);
                pos++;
            }

            var mod = ((suma % divisor) + divisor) % divisor;
            var verif = divisor - mod;

            if (verif == 10) {
                verif = 0;
            }

            if (vIfe == verif) {
                // Clave válida
                return null;
            } else {
                return "La clave no es válida";
            }
        }
    } else {
      return "Introduce 18 caracteres";
    }
  }

  _numera(val, pos){
    num mult;
    num valorConv;
    if ((pos % 2) == 0){
      mult=-3;
    }
    else {
      mult=3;
    }
    var numero = r'^-{0,1}(?:[0-9]+){0,1}(?:\.[0-9]+){0,1}$';
    var regexnum = RegExp(numero);

    if (regexnum.hasMatch(val) == true){
      valorConv = num.parse(val);
    }
    else {
      valorConv = _traduceLetra(val);
    }

    if (valorConv == null || mult == null) {
      return 0;
    }
    return valorConv * mult;
  }

  int _traduceLetra(String letraEntrada) {
    String letra = letraEntrada.toUpperCase();
    Map<String, int> trLetra = { "A": 1, "B": 2, "C": 3, "D": 4,"E":5, "F":6, "G":7, "H":8, "I":9, "J":10,
    "K":11, "L":12, "M":13, "N":14, "O":15, "P":16, "Q":17, "R":18, "S":19,
    "T":20, "U":21, "V":22, "W":23, "X":24, "Y":25, "Z":26 };

    return trLetra[letra];
  }
}
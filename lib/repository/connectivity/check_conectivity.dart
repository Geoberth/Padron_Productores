import 'dart:io';

class CheckConectivity {
  final  Duration _connectivityTimeOut = Duration(seconds: 8 );

  Future<bool>  checkConnectivity() async {
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(_connectivityTimeOut);
      if (result != null &&
          result.isNotEmpty &&
          result.first?.rawAddress?.isNotEmpty == true) {
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}

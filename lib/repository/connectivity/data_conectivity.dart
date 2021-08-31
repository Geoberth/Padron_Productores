import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';

class DataConnectivityService{
  StreamController<DataConnectionStatus> connectivityCtrl = StreamController<DataConnectionStatus>();
  DataConnectivityService(){
    DataConnectionChecker().onStatusChange.listen( ( dataConnectionStatus ){
      print("UpdateStatusNetwork");
      print(dataConnectionStatus);
      connectivityCtrl.add(dataConnectionStatus);
    });
  }
}
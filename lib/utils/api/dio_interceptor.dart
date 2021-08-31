import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/repository/auth/auth_repository.dart';
import 'package:siap/repository/register/register_repository.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/utils/navKey.dart';
import 'package:siap/utils/settings.dart';
import 'package:siap/utils/ui_data.dart';

class DioInterceptor {

  static DioInterceptor instance = DioInterceptor._();

  Dio dio;
  static final String _baseUrl = Settings.baseUrl;
  static const int _connectTimeout = Settings.connectTimeout;
  static const int _receiveTimeout = Settings.receiveTimeout;

  DioInterceptor._() {
    String token;
    dio = new Dio();
     final navigatorKey = NavKey.navKey;
    Dio tokenDio = new Dio();
    dio.options.baseUrl = _baseUrl;
    dio.options.connectTimeout = _connectTimeout;
    dio.options.receiveTimeout = _receiveTimeout;
    dio.options.headers["Accept"] = "application/json";
    tokenDio.options = dio.options;
    dio.interceptors.add(InterceptorsWrapper(
    onRequest:(RequestOptions options) async {
        // Do something before request is sent
        print("====================SENDING REQUEST=========================");
          print('PATH: ${options.path}');
          print('baseUrl: ${options.baseUrl}');
          print('contentType: ${options.contentType}');
          print('data: ${options.data}');
          print('extra: ${options.extra}');
          print('Headers: ${options.headers}');
        print("============================================================");
        List<String> splitPath = options.path.split("/");
        int index = (splitPath.length - 2);
         //"${Settings.apiSegment}/auth/store/1"
         //"/siap-v4/api/auth/store/1"
        if ( options.path ==  "${Settings.apiSegment}/auth/store/1"){
          index = (splitPath.length - 3);
        }
        
        String pathLastSplit = splitPath[index];
        if(pathLastSplit != "auth" && pathLastSplit != "wsdl") {
          print(' Token $token');
           if(token == null || token == "Bearer null") {
            dio.lock();            
            UserModel user = UserSingleton.instance.user;
            if(user == null) {
              /*Redirigir al usuario al login,
              verificar si podemos hacerlo mediante un bloc existente, o si
              en su defecto necesitamos crear uno nuevo
              */              
            }else {
              token = 'Bearer ${user.token}';
              options.headers["Authorization"] = token;
            }
            dio.unlock();            
          }else {
            options.headers["Authorization"] = token;            
          }
        }
        return options; //continue        
        // If you want to resolve the request with some custom data，
        // you can return a `Response` object or return `dio.resolve(data)`.
        // If you want to reject the request with a error message,
        // you can return a `DioError` object or return `dio.reject(errMsg)`
        },
        onResponse:(Response response) {          
        // Do something with response data
        return response; // continue
        },
        onError: (DioError error) async {
          print('ONERROR');
          print(error);
          UserModel user = UserSingleton.instance.user;
          RequestOptions options = error.response.request;
          if (error.response?.statusCode == 401) {
            
            // If the token has been updated, repeat directly.
            if (token != options.headers["Authorization"]) {
              options.headers["Authorization"] = token;
              //repeat
              return dio.request(options.path, options: options);
            }
            // update token and repeat
            // Lock to block the incoming request until the token updated
            dio.lock();
            dio.interceptors.responseLock.lock();
            dio.interceptors.errorLock.lock();
           /*
            * Corregir esta parte, hay que verificar que se ejecute correctamente la petición
              en caso de que no se ejecute correctamente, intentar un máximo de 3 veces y si despues de
              las 3 veces no obtenemos una respuesta satisfactoria, tenemos que ejecutar un bloc, para poder
              cerrar la sesión del usuario. (Verificar si podemos incluir esta en un bloc existente, o si necesitamos crear uno nuevo)
            */
            
            try {
             // UserModel user = UserSingleton.instance.user;
              Map<String, dynamic> data = { "type_person_id": user.tipoPersona };
              (user.tipoPersona == 1) ? data["curp"] = user.curp : data["rfc"] = user.rfc;
              String payload = json.encode(data);
              final response = await tokenDio.post("${Settings.apiSegment}/auth/login/refresh", data: payload); 
              print('responseRefresh()');
              print(response);             
              user.token = response.data["data"];
              RegisterRepository().setUser(json.encode(user));
              options.headers["Authorization"] = token = 'Bearer ${user.token}';
            } on DioError catch   ( error ) {
              print('DioError Code');
              print(error.response?.statusCode);
              if(error.response?.statusCode == 452){
              
                navigatorKey.currentState.pushNamedAndRemoveUntil(UiData.routeLogin, (e) => false);
                user.token = null;
                RegisterRepository().setUser(null);
                RegisterRepository().signOut();
                options.headers["Authorization"] = token = 'Bearer null';
                  Fluttertoast.showToast(
        msg: "El usuario no se encuentra disponible o se ha eliminado",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
              }
            } finally {
              dio.unlock();
              dio.interceptors.responseLock.unlock();
              dio.interceptors.errorLock.unlock();
            }
            return dio.request(options.path, data: options.data, options: options);
          }
          if (error.response?.statusCode == 452) {
           print('=====542=======');
             
            navigatorKey.currentState.pushNamedAndRemoveUntil(UiData.routeLogin, (e) => false);
             user.token = '';
             RegisterRepository().setUser(null);
             RegisterRepository().signOut();
            options.headers["Authorization"] = token = 'Bearer null';
                        Fluttertoast.showToast(
        msg: "El usuario no se encuentra disponible o se ha eliminado",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
            dio.unlock();
            dio.interceptors.responseLock.unlock();
            dio.interceptors.errorLock.unlock();
          }
        return  error;//continue
        }
    ));    
  }

}
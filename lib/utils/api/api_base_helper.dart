
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:siap/utils/api/app_exceptions.dart';
import 'package:siap/utils/api/dio_interceptor.dart';
class ApiBaseHelper {
  
  Future<dynamic> get(String url, {Map<String, dynamic> queryParameters}) async {
    var responseJson;
    try {
      DioInterceptor dioInterceptor = DioInterceptor.instance;
      final Response response = await dioInterceptor.dio.get(url, queryParameters: queryParameters);
      responseJson = _handleResponse(response);
    } on DioError catch(dioError) {
      _handleError(dioError);
    }
    catch (e) {
      throw FetchDataException("Ocurrió un error inesperado, $e");
    }
    return responseJson;
  }

  Future<dynamic> post(String endpoint, String jsonParams) async {    
    var responseJson;
    try {
      DioInterceptor dioInterceptor = DioInterceptor.instance;
      final Response response = await dioInterceptor.dio.post(endpoint, data: jsonParams);
      responseJson = _handleResponse(response);
    } on DioError catch(dioError) {
      _handleError(dioError);
    }
    catch (e) {
      throw FetchDataException("Ocurrió un error inesperado, $e");
    }
    return responseJson;
  }

  Future<dynamic> put(String endpoint, String jsonParams) async {    
    var responseJson;
    try {
      DioInterceptor dioInterceptor = DioInterceptor.instance;
      final Response response = await dioInterceptor.dio.put(endpoint, data: jsonParams);
      responseJson = _handleResponse(response);
    } on DioError catch(dioError) {
      _handleError(dioError);
    }
    catch (e) {
      throw FetchDataException("Ocurrió un error inesperado, $e");
    }
    return responseJson;
  }

  dynamic _handleError(DioError error) {
    print('handleError $error');
      switch (error.type) {
        case DioErrorType.CANCEL:
          throw FetchDataException("Se canceló la solicitud al servidor de API");
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          throw FetchDataException("Tiempo de espera de conexión con el servidor API");
          break;
        case DioErrorType.SEND_TIMEOUT:
          throw FetchDataException("Enviar tiempo de espera de conexión con el servidor API");
          break;
        case DioErrorType.DEFAULT:
          throw FetchDataException("El registro se debe realizar con conexión a Internet");
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          throw FetchDataException("Recibir tiempo de espera en conexión con el servidor API");
          break;
        case DioErrorType.RESPONSE:
          _handleResponse(error.response);
          break;
      } 
  }

  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        var responseJson = response.data;
        return responseJson;
      case 400:
      case 450: // Return error as a Array, here is need to parse to List
        String parsedError = _parsedArrayError(response.data);
        throw BadRequestException(parsedError);
      case 451: // Return error as a String
        throw BadRequestException((response.data["error"]["message"]) ?? response.data.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.data.toString());
      case 500:
      default:
      print("==============ERROR 500===================");
      print(response.data.toString());
        throw FetchDataException('Ocurrió un error durante la comunicación con el servidor con StatusCode : ${response.statusCode}');
    }
  }

  _parsedArrayError(data) {
    String errorParsed = "";
    data["error"].forEach((key, val) {
      errorParsed += "${val[0]} ";
    });
    return errorParsed;
  }
}
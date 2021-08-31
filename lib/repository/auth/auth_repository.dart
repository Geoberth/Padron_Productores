import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:siap/models/signin/signin_model.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/utils/api/api_base_helper.dart';
import 'package:siap/utils/settings.dart';

class AuthRepository {
  ApiBaseHelper _apiHelper;

  String _urlLogIn;
  String _urlSignIn;
  String _urlRecoveryPass;
  String _urlRefreshToken;

  AuthRepository(){
    _urlLogIn = "${Settings.apiSegment}/auth/login";
    _urlSignIn = "${Settings.apiSegment}/auth/store";
    _urlRecoveryPass = "${Settings.apiSegment}/auth/reset";
    _urlRefreshToken = "${Settings.apiSegment}/auth/login/refresh";
    _apiHelper = ApiBaseHelper();
  }

  Future<UserModel> logIn({UserMobile userMobile, String password}) async {
    Map<String, dynamic> data = {
      "type_person_id": userMobile.tipoPersona,
      "curp": userMobile.curp,
      "rfc": userMobile.rfc,
      "password": password,
    };
    (userMobile.tipoPersona == 1) ? data["curp"] = userMobile.curp : data["rfc"] = userMobile.rfc;
    String payload = json.encode(data);
    final response = await _apiHelper.post(_urlLogIn, payload);
    return UserModel.fromJson(response["data"]);
  }

  Future<void> signIn({UserMobile userMobile, String password }) async {
    Map<String, dynamic> data = {
      "type_person_id": userMobile.tipoPersona,
      "curp": userMobile.curp,
      "rfc": userMobile.rfc,
      "email": userMobile.email,
      "phone": userMobile.phone,
      "password": password,
    };
    (userMobile.tipoPersona == 1) ? data["curp"] = userMobile.curp : data["rfc"] = userMobile.rfc;
    String payload = json.encode(data);
    
    /* final response =  */return await _apiHelper.post(_urlSignIn, payload);
    // return SignInModel.fromJson(response).data;
  }
  Future<Map<String, dynamic>> signInOffline({UserMobile userMobile, String password }) async {
    Map<String, dynamic> data = {
      "type_person_id": userMobile.tipoPersona,
      "curp": userMobile.curp,
      "rfc": userMobile.rfc,
      "email": userMobile.email,
      "phone": userMobile.phone,
      "password": password,
    };
    (userMobile.tipoPersona == 1) ? data["curp"] = userMobile.curp : data["rfc"] = userMobile.rfc;
    String payload = json.encode(data);
    
     final response =   await _apiHelper.post("$_urlSignIn/1", payload);
     return response["data"];
    // return SignInModel.fromJson(response).data;
  }
  Future<String> recoveryPass({String email}) async {
    String payload = json.encode({"email": email});
    final response = await _apiHelper.post(_urlRecoveryPass, payload);
    return SignInModel.fromJson(response).data.email;
  }

  Future<String> refreshToken({@required int tipoPersona, String rfc, String curp}) async {
    Map<String, dynamic> data = { "type_person_id": tipoPersona };
    (tipoPersona == 1) ? data["curp"] = curp : data["rfc"] = rfc;
    String payload = json.encode(data);
    print('RefreshToken()');
    final response = await _apiHelper.post(_urlRefreshToken, payload);
    return response["data"];
  }
  
}
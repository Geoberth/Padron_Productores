import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:siap/models/offline/parcela_offline.dart';
import 'package:siap/models/user/user_model.dart';
import 'package:siap/repository/register/user_singleton.dart';
import 'package:siap/utils/api/api_base_helper.dart';
import 'package:siap/utils/settings.dart';

class RegisterRepository {
  FlutterSecureStorage _secureStorage;
  ApiBaseHelper _apiHelper;

  String _urlAddPadron;
  String _urlValidateRenapo;
  String _urlValidateRfc;
  String _urlallFilesGeo;
  String _urlUserShow;
  RegisterRepository(){
    _urlAddPadron = "${Settings.apiSegment}/users/store";
    _urlValidateRenapo = "${Settings.apiSegment}/wsdl/renapo";
    _urlValidateRfc = "${Settings.apiSegment}/wsdl/rfc";
    _urlallFilesGeo ="${Settings.apiSegment}/users/plot-geo/offline";
    _urlUserShow = "${Settings.apiSegment}/users/show";
    _apiHelper = ApiBaseHelper();
    _secureStorage = FlutterSecureStorage();
  }

  Future<UserModel> addPadron({UserModel user}) async {
    String payload = json.encode(user.toJson());
    final response = await _apiHelper.post(_urlAddPadron, payload);
    return UserModel.fromJson(response["data"]);
  }
  Future<UserModel> getUserData({@required int userId}) async {
    String url = _urlUserShow + '/$userId';
    final response = await _apiHelper.get(url);
    return UserModel.fromJson(response["data"]);
  }

  Future<Map<String, dynamic>> validateCurpWithRenapo({@required String curp, bool noValid}) async {
    Map<String, dynamic> params = { "curp": curp };
    if(noValid != null) params["noValid"] = true;
    final response = await _apiHelper.get(_urlValidateRenapo, queryParameters: params);
    return response["data"];
  }
  // Valida Curp Offline 
  Future<Map<String, dynamic>> validateCurpWithRenapo2({@required String curp, bool noValid,int legalId }) async {
    Map<String, dynamic> params = { "curp": curp };
    if(noValid != null) params["noValid"] = true;
    if(legalId != null ) params['legalId'] = legalId;
    final response = await _apiHelper.get(_urlValidateRenapo, queryParameters: params);
    return response;
  }
  Future<Map<String, dynamic>> saveAllFilesGeo({@required List<ParcelaOffline> filesFoodIndustry,   @required int idUser}) async {
    var url = "$_urlallFilesGeo/$idUser";
    String payload = json.encode({"list":filesFoodIndustry});
    
    final response = await _apiHelper.post(url,payload );
    return response;
  }
  Future<Map<String, dynamic>> validateRfc({@required String rfc}) async {
    final response = await _apiHelper.get(_urlValidateRfc, queryParameters: { "rfc": rfc });
    return response["data"];
  }

  Future<void> signOut() async {
    UserSingleton.instance.user = null;
    return Future.wait([
      //Add all methods that we used for signout user, like calls to Api's or/and clean storage.
      clearUser(),
    ]);
  }

  /// ***************************************************************
  /// ***********************SECURE STORAGE**************************
  /// ***************************************************************

  Future<void> setUser(String jsonUser) async {
    return await _secureStorage.write(key: "userInfo", value: jsonUser);
  }

  Future<void> clearUser() async {
    return await _secureStorage.delete(key: "userInfo");
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _secureStorage.read(key: "userInfo");
    return currentUser != null;
  }

  Future<UserModel> getUser() async {
    String userInfo = await _secureStorage.read(key: "userInfo");
    return (userInfo != null) ? UserModel.fromJson(json.decode(userInfo)) : null;
  }

}
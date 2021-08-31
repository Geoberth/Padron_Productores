import 'package:siap/models/user/user_model.dart';

class UserSingleton {

  /* User instance is created only one time when app start, 
   * and then is accesible to entire app, without wait any Future response.*/
   
  UserSingleton._privateConstructor();
  static final UserSingleton _instance = UserSingleton._privateConstructor();
  static UserSingleton get instance { return _instance;}
  
  UserModel user;

}
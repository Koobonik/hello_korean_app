import 'dart:convert';
import 'package:hellokorean/config/appConfig.dart';
import 'package:hellokorean/config/httpcontroller.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class Users {
  String userToken;
  String userNickName;
  String userFirebaseToken;
  String userImageUrl;
  Users({this.userToken, this.userNickName, this.userFirebaseToken,
      this.userImageUrl});


  factory Users.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return Users(
      userToken: map['userToken']?.toString(),
      userNickName: map['userNickName']?.toString(),
      userFirebaseToken: map['userFirebaseToken']?.toString(),
      userImageUrl: map['userImageUrl']?.toString(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'userToken': userToken,
      'userNickName': userNickName,
      'userFirebaseToken': userFirebaseToken,
      'userImageUrl': userImageUrl,
    };
  }

  static usersAutoLogin(Users users) async {
    Users users1 = Users.fromMap(jsonDecode(await HttpController.sendRequest("/autoLogin", users.toMap())));
    return users1;
  }

  static stopUser(Users users) async {
    String response = await HttpController.sendRequest("/stopUser", users.toMap());
    return response;
  }
}
Future<List<Users>> getUsersList(Users users) async {
  var list = List<Users>();
  List<dynamic> body = json.decode(await HttpController.sendRequest("/getUsersList", users.toMap()));
  print(body.length);
  for(var h in body){
    list.add(Users.fromMap(h));
  }
  return list;
}


Future<Users> getUserData() async {
  String token = await HttpController.sendRequest("renewalToken", null);
  if (token != "") {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    // Now you can use your decoded token
    print("토큰 이름");
    print(decodedToken["name"]);

    print(decodedToken["sub"]); // 유저 이름
    print(decodedToken["HEADER"]);
    /* isExpired() - you can use this method to know if your token is already expired or not.
  An useful method when you have to handle sessions and you want the user
  to authenticate if has an expired token */
    bool isTokenExpired = JwtDecoder.isExpired(token);

    if (!isTokenExpired) {
      // The user should authenticate
      print("토근 유효함");
    }

    /* getExpirationDate() - this method returns the expiration date of the token */
    DateTime expirationDate = JwtDecoder.getExpirationDate(token);
    print(expirationDate);
    AppConfig.users = Users(
        userToken: token, userNickName: decodedToken["userNickName"], userFirebaseToken: decodedToken["userFirebaseToken"], userImageUrl: decodedToken["userImageUrl"]);
    AppConfig.userLogin(AppConfig.users, true);
  }
}

import 'dart:convert';
import 'package:hellokorean/config/appConfig.dart';
import 'package:hellokorean/utils/httpcontroller.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class Users {
  String userToken;
  String userNickName;
  String userFirebaseToken;
  String userImageUrl;
  int seeAdTime; // 광고를 본 시간
  int seeAdMoney; // 광고를 보고 기부한 금액
  int money; // 실제 기부한 금액 ( 실제 돈을 얼마나 기부했는가 )
  Users(this.userToken, this.userNickName, this.userFirebaseToken,
      this.userImageUrl, this.seeAdTime, this.seeAdMoney, this.money);

  factory Users.fromJson(dynamic json){
    return Users(json['userToken'] as String, json['userNickName'] as String,
        json['userFirebaseToken'] as String, json['userImageUrl'] as String,
        json['seeAdTime'] as int, json['seeAdMoney'] as int, json['money'] as int);
  }
  Map<String, dynamic> toJson() =>
      {
        'userToken' : userToken,
        'userNickName' : userNickName,
        'userFirebaseToken' : userFirebaseToken,
        'userImageUrl' : userImageUrl,
        'seeAdTime' : seeAdTime,
        'seeAdMoney' : seeAdMoney,
        'money' : money
      };

  static usersAutoLogin(Users users) async {
    Users users1 = Users.fromJson(jsonDecode(await HttpController.sendRequest("/autoLogin", users.toJson())));
    return users1;
  }

  static stopUser(Users users) async {
    String response = await HttpController.sendRequest("/stopUser", users.toJson());
    return response;
  }
}
Future<List<Users>> getUsersList(Users users) async {
  var list = List<Users>();
  List<dynamic> body = json.decode(await HttpController.sendRequest("/getUsersList", users.toJson()));
  print(body.length);
  for(var h in body){
    list.add(Users.fromJson(h));
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
        token,
        decodedToken["userNickName"],
        decodedToken["userFirebaseToken"],
        decodedToken["userImageUrl"],
        decodedToken['seeAdTime'],
        decodedToken['seeAdMoney'],
        decodedToken['money']);
    AppConfig.userLogin(AppConfig.users, true);
  }
}


import 'package:flutter/material.dart';
import 'package:hellokorean/models/Users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AppConfig {
  static Color buttonColor = Colors.blue;
  static bool userLogined = false; // 유저가 로그인 했는지!
  static bool prAppear = true; // 광고 나타낼지 말지
  static Users users = null;
//   static String baseUrl = "http://192.168.219.100:8080/api/v1";
// static String baseUrl = "http://13.209.65.220:8080/api/v1";

  // ssl 쓰자
  static String baseUrl = "https://donda.shop:8084/donda/api/v1/";
//  static String baseUrl = "https://192.168.219.100:8080/api/v1";

  // 유저가 로그인 했을 경우.
  static void userLogin(Users users, bool remember) async {
    final prefs = await SharedPreferences.getInstance();



    if(remember){
      prefs.setString('userNickName', users.userNickName);
      prefs.setString('userToken', users.userToken);
      prefs.setString('userFirebaseToken', users.userFirebaseToken);
      prefs.setString('userImageUrl', users.userImageUrl);

      prefs.setBool('userLogined', true);
    }

    AppConfig.userLogined = true;
    AppConfig.users = users;
    print("유저가 로그인 함");
  }

  // 자동 로그인
  static void autoUserLogin() async {
    final prefs = await SharedPreferences.getInstance();

    Users(prefs.getString('userToken'), prefs.getString('userNickName'), prefs.getString('userFirebaseToken'), prefs.getString('userImageUrl'), prefs.getInt("seeAdTime"), prefs.getInt("seeAdMoney"), prefs.getInt("money"));

    prefs.getBool('userLogined');
    AppConfig.userLogined = true;
    AppConfig.users = users;
    print("유저가 로그인 함");
  }

  static void userLogout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("userToken", null);
    prefs.setString('userNickName', null);
    prefs.setString('userFirebaseToken', null);
    prefs.setString('userImageUrl', null);

    prefs.setBool('userLogined', false);
    AppConfig.userLogined = false;
    AppConfig.users = Users(prefs.getString('userToken'), prefs.getString('userNickName'), prefs.getString('userFirebaseToken'), prefs.getString('userImageUrl'), prefs.getInt("seeAdTime"), prefs.getInt("seeAdMoney"), prefs.getInt("money"));
    print("유저가 로그아웃 함");
    setShowPR();
    void showToast(String msg, {int duration, int gravity}) {
      Toast.show(msg, context, duration: duration, gravity: gravity);
    }
    showToast("로그아웃 되었습니다.");

  }

  static void autoUserLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("userToken", null);
    prefs.setStringList("roles", null);
    prefs.setString('userNickName', null);
    prefs.setString('userFirebaseToken', null);
    prefs.setString('userImageUrl', null);

    prefs.setBool('userLogined', false);
    AppConfig.userLogined = false;
    AppConfig.users = Users(prefs.getString('userToken'), prefs.getString('userNickName'), prefs.getString('userFirebaseToken'), prefs.getString('userImageUrl'), prefs.getInt("seeAdTime"), prefs.getInt("seeAdMoney"), prefs.getInt("money"));

    print("유저가 로그아웃 함");

  }

  static Future<Users> userRead() async {
    final prefs = await SharedPreferences.getInstance();
    Users users;

    users = Users(prefs.getString('userToken'), prefs.getString('userNickName'), prefs.getString('userFirebaseToken'), prefs.getString('userImageUrl'), prefs.getInt("seeAdTime"), prefs.getInt("seeAdMoney"), prefs.getInt("money"));
    if(users.userNickName == null){
      AppConfig.users = users;
      return users;
    }
    AppConfig.userLogined = prefs.getBool("userLogined");
    print("유저 정보 읽어옴");
    AppConfig.users = users;
    return users;
  }

  static Future getShowPR() async {
    final prefs = await SharedPreferences.getInstance();
    AppConfig.prAppear = prefs.getBool("prAppear");
    return AppConfig.prAppear;

  }

  static setNoShowPR() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("prAppear", false);
  }

  static setShowPR() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("prAppear", true);
  }
}
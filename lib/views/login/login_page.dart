import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hellokorean/config/appConfig.dart';
import 'package:hellokorean/models/Users.dart';
import 'package:hellokorean/utils/httpcontroller.dart';
import 'package:hellokorean/views/login/findID_page.dart';
import 'package:hellokorean/views/login/findPassword_page.dart';
import 'package:hellokorean/views/login/signUp_page.dart';
import 'package:toast/toast.dart';
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          centerTitle: true,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () { 
              Navigator.of(context).pop();
              
            },
          ),
        ),
        body: MyStatefulWidget(),
    );
  }
  

}
class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  List<String> list = [];
  // List<OfferJob> list = List<OfferJob>(); // 이런식으로 하기도 함
  bool loadingDone = false;
  TextEditingController titleController = new TextEditingController();
  TextEditingController bodyController = new TextEditingController();

  // 초기 세팅
  @override
  void initState() {
//    fetch().then((onValue){
//      setState(() {
//        //list.addAll(onValue);
//        print(onValue.length);
//        loadingDone = true;
//      });
//
//    });
    super.initState();
  }
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Container(
      // margin: const EdgeInsets.only(left: 50.0, right: 50.0, top: 30, bottom: 30),
      margin: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        children: <Widget>[
          Image.asset(
            "assets/gif/hanbok.gif",
            height: 125.0,
            width: 125.0,
          ),
          SizedBox(height: 30,),
          Container(
            color: Colors.blueGrey,
            child: Column(
              children: [

              ],
            ),
          ),
          new TextField(
            cursorColor: AppConfig.buttonColor,
            controller: titleController,
            decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                fillColor: const Color.fromRGBO(238, 232, 198, 1.0),
                /*hintText: "id",*/ labelText: '아이디'),
          ),
          new TextField(
            cursorColor: AppConfig.buttonColor,
            controller: bodyController,
            decoration: InputDecoration(
                icon: Icon(Icons.vpn_key),
                fillColor: const Color.fromRGBO(238, 232, 198, 1.0),
                /*hintText: "password",*/ labelText: '비밀번호'),
            obscureText: true,
          ),
          ButtonTheme(
            minWidth: double.infinity,
            child: new RaisedButton(
              color: AppConfig.buttonColor,
              child: const Text("로그인"),
              onPressed: () async {
                if(titleController.text.length <= 0){
                  showToast("아이디를 입력해주세요.");
                  return ;
                }
                else if(bodyController.text.length <= 0){
                  showToast("비밀번호를 입력해주세요.");
                  return ;
                }
//                var map = jsonEncode(realProperty.toJson());
//                print(map);
//                Map map2 = {"map" : map.toString()};
//                Map map3 = jsonDecode(map2['map']);
                Users users = null;//Users(null, titleController.text, null, bodyController.text, null, null, null, null, null, null, null, FirebaseController.firebaseToken, null);
                String response = await HttpController.sendRequest("/login", users.toJson());
                print(response);
                try{
                  Users users = Users.fromJson(json.decode(response));
                  AppConfig.userLogin(users, false);
                  if(users.userNickName != null){
                    Navigator.pop(context, true);
                  }
                } catch(e){
                  showToast("아이디와 비밀번호에 맞는 계정이 없습니다.");
                  return ;
                }



                showToast("로그인 되었습니다.");

              },// onpressed
            ),
          ),
          ButtonTheme(
              minWidth: double.infinity,
              child: new RaisedButton(
                color: AppConfig.buttonColor,
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                        return SignUpPage();
                      })
                  );

                },
                child: const Text("회원가입"),
              )
          ),
          ButtonTheme(
              minWidth: double.infinity,
              child: new RaisedButton(
                color: AppConfig.buttonColor,
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                        return FindIDPage();
                      })
                  );
                },
                child: const Text("아이디 찾기"),
              )
          ),
          ButtonTheme(
              minWidth: double.infinity,
              child: new RaisedButton(
                color: AppConfig.buttonColor,
                onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                        return FindPasswordPage();
                      })
                  );
                },
                child: const Text("비밀번호 찾기"),
              )
          ),
        ],
      ),
    );

  }
}
Future<List<dynamic>> fetch() async {
  var list = List<dynamic>();
  var response = await HttpController.sendRequest("/login", null);
  var body = json.decode(response);
  print(body.length);
  for(var h in body){
    //list.add(OfferJob.fromJson(h));
  }
  return list;
}
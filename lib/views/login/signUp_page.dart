import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hellokorean/config/appConfig.dart';
import 'package:hellokorean/utils/httpcontroller.dart';
import 'package:toast/toast.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
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
  TextEditingController id_box_text = new TextEditingController();
  TextEditingController pw_box_text = new TextEditingController();
  TextEditingController pw_box_text2 = new TextEditingController();
  TextEditingController nick_name_box_text = new TextEditingController();
  TextEditingController email_box_text = new TextEditingController();
  // TextEditingController birthday_box_text = new TextEditingController();

  // 초기 세팅
  @override
  void initState() {
    super.initState();
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Container(
      margin: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: new Column(
        children: <Widget>[
          new TextField(
            cursorColor: const Color.fromRGBO(238, 232, 198, 1.0),
            controller: id_box_text,
            decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                fillColor: const Color.fromRGBO(238, 232, 198, 1.0),
                hintText: "영문 및 숫자로만 입력해주세요. (4자 이상)",
                labelText: '로그인 아이디'),
          ),
          new TextField(
            cursorColor: const Color.fromRGBO(238, 232, 198, 1.0),
            controller: pw_box_text,
            decoration: InputDecoration(
                icon: Icon(Icons.vpn_key),
                fillColor: const Color.fromRGBO(238, 232, 198, 1.0),
                hintText: "9글자 이상으로 입력해주세요.",
                labelText: '비밀번호'),
            obscureText: true,
          ),
          new TextField(
            cursorColor: const Color.fromRGBO(238, 232, 198, 1.0),
            controller: pw_box_text2,
            decoration: InputDecoration(
                icon: Icon(Icons.vpn_key),
                fillColor: const Color.fromRGBO(238, 232, 198, 1.0),
                hintText: "9글자 이상으로 입력해주세요.",
                labelText: '비밀번호 확인'),
            obscureText: true,
          ),
          new TextField(
            cursorColor: const Color.fromRGBO(238, 232, 198, 1.0),
            controller: nick_name_box_text,
            decoration: InputDecoration(
                icon: Icon(Icons.account_circle),
                fillColor: const Color.fromRGBO(238, 232, 198, 1.0),
                hintText: "영문 및 숫자로만 입력해주세요. (3자 이상)",
                labelText: '닉네임'),
          ),
//          new TextField(
//            cursorColor: const Color.fromRGBO(238, 232, 198, 1.0),
//            controller: birthday_box_text,
//            decoration: InputDecoration(
//                icon: Icon(Icons.calendar_today),
//                fillColor: const Color.fromRGBO(238, 232, 198, 1.0),
//                hintText: "ex) 960130",
//                labelText: '생년월일'),
//          ),
          new TextField(
            cursorColor: const Color.fromRGBO(238, 232, 198, 1.0),
            controller: email_box_text,
            decoration: InputDecoration(
                icon: Icon(Icons.email),
                fillColor: const Color.fromRGBO(238, 232, 198, 1.0),
                labelText: '이메일 (아이디 비밀번호 찾을 때 이용)'),
          ),
          // 회원가입 버튼
          ButtonTheme(
              minWidth: double.infinity,
              child: new RaisedButton(
                color: AppConfig.buttonColor,
                onPressed: () async {
                  // 회원가입 버튼 클릭시 동작들

                  // 아이디
                  if (id_box_text.text.length < 4) {
                    showToast("로그인 아이디는 영문 및 숫자로 4자 이상으로 해주세요",
                        gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
                    return;
                  }

                  // 비밀번호
                  if (pw_box_text.text.length <= 9) {
                    showToast("비밀번호는 9자 이상으로 생성해주세요.");
                    return;
                  }

                  // 비밀번호 중복 체크
                  if (pw_box_text.text != pw_box_text2.text) {
                    showToast("비밀번호가 일치하지 않습니다.");
                    return;
                  }

                  //
                  if (nick_name_box_text.text.length < 3) {
                    showToast("닉네임은 3자 이상으로 지어주세요");
                    return;
                  }

                  if (email_box_text.text.length <= 0 ||
                      email_box_text.text == "") {
                    showToast("이메일을 입력해주세요.");
                    return;
                  }

//                  // 유저 인풋 예외처리
//                  if(birthday_box_text.text.length != 6){
//                    showToast("생년월일은 숫자 6자리만 입력해주세요");
//                    return ;
//                  }

                  //

                  // 회원가입 버튼 클릭시 동작

                  Map map = {
                    "data1": "${id_box_text.text}",
                    "data2": "${pw_box_text.text}",
                    "data3": "${pw_box_text2.text}",
                    "data4": "${nick_name_box_text.text}",
                    "data5": "${email_box_text.text}",
                    "data12": ""
                  };
                  String response =
                      await HttpController.sendRequest("/signUp", map);
                  if (response == "true") {
                    showToast("회원 가입이 성공적으로 완료 되었습니다.");
                    Navigator.of(context).pop();
                  } else {
                    showToast(response);
                  }
                },
                child: const Text("회원가입"),
              )),
        ],
      ),
    );
  }
}

Future<List<dynamic>> fetch() async {
  var list = List<dynamic>();
  var response = await HttpController.sendRequest("/getOfferList", null);
  var body = json.decode(response);
  print(body.length);
  for (var h in body) {
    //list.add(OfferJob.fromJson(h));
  }
  return list;
}

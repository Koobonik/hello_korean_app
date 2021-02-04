import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hellokorean/config/appConfig.dart';
import 'package:hellokorean/models/Users.dart';
import 'package:hellokorean/utils/httpcontroller.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
class FindPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("비밀번호 찾기"),
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
          SizedBox(height: 10,),
          Text("임의의 비밀번호로 바꾸어 드립니다.\n  아이디와 이메일을 입력해주세요.", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
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
                icon: Icon(Icons.alternate_email),
                fillColor: const Color.fromRGBO(238, 232, 198, 1.0),
                /*hintText: "password",*/ labelText: '이메일'),
          ),
          ButtonTheme(
            minWidth: double.infinity,
            child: new RaisedButton(
              color: AppConfig.buttonColor,
              child: const Text("임시 비밀번호 받기"),
              onPressed: () async {
                if(titleController.text.length <= 0){
                  showToast("아이디를 입력해주세요.");
                  return ;
                }
                else if(bodyController.text.length <= 0){
                  showToast("이메일 입력해주세요.");
                  return ;
                }
                ProgressDialog pr = new ProgressDialog(context);
                pr.style(
                    message: '임시 비밀번호를 발급중...',
                    borderRadius: 10.0,
                    backgroundColor: Colors.white,
                    progressWidget: CircularProgressIndicator(),
                    elevation: 10.0,
                    insetAnimCurve: Curves.easeInOut,
                    progress: 0.0,
                    maxProgress: 100.0,
                    progressTextStyle: TextStyle(
                        color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
                    messageTextStyle: TextStyle(
                        color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
                );
                pr.show();
                Users users = null;//Users(null, titleController.text, bodyController.text, null, null, null, null, null, null, null, null, null, null);
                var map = jsonEncode(users.toJson());
                Map map2 = {"map" : map.toString()};
                Map map3 = jsonDecode(map2['map']);
                String response = await HttpController.sendRequest("/resetPassword", map3);
                print(response);
                if(response == "true"){
                  pr.hide();
                  showToast("해당 이메일로 임시 비밀번호를 발급해드렸습니다.");
                  Navigator.of(context).pop();
                }
                else{
                  pr.hide();
                  showToast(response);
                }
              },// onpressed
            ),
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
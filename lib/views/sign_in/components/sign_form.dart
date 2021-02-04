
import 'package:flutter/material.dart';
import 'package:hellokorean/components/custom_surfix_icon.dart';
import 'package:hellokorean/components/default_button.dart';
import 'package:hellokorean/components/form_error.dart';
import 'package:hellokorean/config/appConfig.dart';
import 'package:hellokorean/config/constants.dart';
import 'package:hellokorean/config/size_config.dart';
import 'package:hellokorean/models/Users.dart';
import 'package:hellokorean/utils/httpcontroller.dart';
import 'package:hellokorean/views/forgot_password/forgot_password_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String Id;
  String password;
  bool remember = true;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
//              Checkbox(
//                value: remember,
//                activeColor: kPrimaryColor,
//                onChanged: (value) {
//                  setState(() {
//                    remember = value;
//                  });
//                },
//              ),
//              Text("자동 로그인"),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Find ID",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              Spacer(flex: 1),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Reset Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Login",
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                Map map = {"userLoginId": Id, "userLoginPassword": password};
                String token = await HttpController.sendRequest("login", map);
                // if all are valid then go to success screen
                /* token을 받아와서 null이면 기존화면 null이 아니면 로그인성공*/
                // print("token :"+token+"aaa");
                // print(token != null);
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
                  AppConfig.userLogin(AppConfig.users, remember);

                  print(AppConfig.users.userNickName);

//                  Navigator.pushNamed(context, HomeScreen.routeName);
                } else {
                  //아이디와 비밀번호가 일치하지 않을때의 스낵바
                  final snackBar = SnackBar(
                    content: Text('아이디 또는 비밀번호가 일치하지 않습니다.'),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                  // print("로그인하지 못했습니다.");
                }
              } else
                print("false");
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          //비밀번호는 8자리 이상
          final snackbar = SnackBar(
            content: Text('비밀번호는 8자리 이상 입력해주세요!'),
          );
          Scaffold.of(context).showSnackBar(snackbar);
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Input your password.",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => Id = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kUserIdNullError);
        }
        /*else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);*/
        /*}*/
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kUserIdNullError);
          return "";
        }
        /*else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }*/
        return null;
      },
      decoration: InputDecoration(
        labelText: "ID",
        hintText: "Input your ID",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}

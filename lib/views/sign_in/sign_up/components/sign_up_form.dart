import 'package:flutter/material.dart';
import 'package:hellokorean/components/custom_surfix_icon.dart';
import 'package:hellokorean/components/default_button.dart';
import 'package:hellokorean/components/form_error.dart';
import 'package:hellokorean/config/appConfig.dart';
import 'package:hellokorean/config/size_config.dart';
import 'package:hellokorean/models/Users.dart';
import 'package:hellokorean/models/dto/SignUpDto.dart';
import 'package:hellokorean/config/firebaseController.dart';
import 'package:hellokorean/config/httpcontroller.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../config/constants.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String receivedCode;
  String password;
  String conformPassword;
  String nickName;
  String userId;
  bool remember = true;

  // 검증 체크.
  bool _emailValid = false; // 이메일 형식인지 검증
  bool _sendEmailDone = true; // 이메일 버튼 눌러서 잘 보내졌을 경우
  bool _emailConfirmDone = false;
  bool _otherArea = false;
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

  sendCode(value) {
    print(value);
    setState(() {
      // 서버에 이메일 보내는 무언가의 요청을 해야함.
      _sendEmailDone = false;
      // 인증코드 입력하는 텍스트 폼이 나와야 함.


      // 이메일이
      _otherArea = true;

    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _sendEmailDone ?
              Column(
                children: [
                  buildEmailFormField(),
                  _emailValid
                      ? Padding(
                    padding:
                    EdgeInsets.only(top: getProportionateScreenHeight(10)),
                    child: DefaultButton(
                      text: "send code",
                      press: () {
                        sendCode(email);

                      },
                    ),
                  )
                      : Container(),
                ],
              ): Container(),

          Container(height: getProportionateScreenHeight(10),),
          _otherArea
              ? Column(
                  children: [
                    buildEmailAuthCodeFormField(),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    buildPasswordFormField(),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    buildConformPassFormField(),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    SizedBox(height: getProportionateScreenHeight(10)),
                    buildNickNameFormField(),
                    FormError(errors: errors),
                    SizedBox(height: getProportionateScreenHeight(20)),
                    defaultButton(),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  DefaultButton defaultButton(){
    return DefaultButton(
      text: "Try Join!",
      press: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          print("값 유효?" + email);
          SignUpDto signUpDto = SignUpDto(
              userId,
              conformPassword,
              nickName,
              email,
              "FirebaseController.firebaseToken",
              "hello");
          String token = await HttpController.sendRequest(
              "signUp", signUpDto.toJson());
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
            AppConfig.userLogin(AppConfig.users, remember);
            print(AppConfig.users.userNickName);
//                  Navigator.pushNamed(context, HomeScreen.routeName);
          }

          // if all are valid then go to success screen

        }
      },
    );
  }

  // 이메일 REX 체크
  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        print(emailValidatorRegExp.hasMatch(value));
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        if (emailValidatorRegExp.hasMatch(value)) {
          print("일치함");
          setState(() {
            _emailValid = true;
            email = value;
          });
        } else {
          print("일치하지 않음");
          setState(() {
            _emailValid = false;
          });
        }

        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "E-mail",
        hintText: "Please input your E-mail",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  // 받은 이메일 코드
  TextFormField buildEmailAuthCodeFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => nickName = newValue,
      onChanged: (value) {
        if (value.length >= 6) {
          removeError(error: kEmailCodeError);
          return "";
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty || value.length < 6) {
          addError(error: kEmailCodeError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Received code",
        hintText: "Please input received code",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  // 비밀번호 입력
  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length > 8) {
          print("에러 제거");
          removeError(error: kShortPassError);
        }
        password = value;
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          print("에러 추가");
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Please input your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  // 비밀번호 체크
  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conformPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == conformPassword) {
          removeError(error: kMatchPassError);
        }
        conformPassword = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
        removeError(error: kMatchPassError);
        return null;
      },
      decoration: InputDecoration(
        labelText: "password",
        hintText: "Please check your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  // 이메일 인증코드
  TextFormField buildEmailFormConfirmField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {


        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailCodeError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "E-mail",
        hintText: "Please input your E-mail",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }

  TextFormField buildNickNameFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => nickName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNickNameNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNickNameNullError);
          return "";
        }
        else if(value.length < 4){
          addError(error: kNickNameShortError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Nicename",
        hintText: "Please input your nickname",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildUserIDFormField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      onSaved: (newValue) => userId = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kUserIdNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kUserIdNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "아이디",
        hintText: "아이디를 입력하세요.",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}

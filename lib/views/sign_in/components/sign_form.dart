
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snack.dart';
import 'package:hellokorean/components/custom_surfix_icon.dart';
import 'package:hellokorean/components/default_button.dart';
import 'package:hellokorean/components/form_error.dart';
import 'package:hellokorean/components/util.dart';
import 'package:hellokorean/config/appConfig.dart';
import 'package:hellokorean/config/constants.dart';
import 'package:hellokorean/config/size_config.dart';
import 'package:hellokorean/models/Users.dart';
import 'package:hellokorean/config/httpcontroller.dart';
import 'package:hellokorean/models/dto/request/loginDto.dart';
import 'package:hellokorean/models/dto/response/jwt_response.dart';
import 'package:hellokorean/models/dto/response/profile_response.dart';
import 'package:hellokorean/views/forgot_password/forgot_password_screen.dart';
import 'package:hellokorean/views/home/main_page.dart';
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
          SizedBox(height: getProportionateScreenHeight(16)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(16)),
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

                JwtResponse response = JwtResponse.fromMap(await HttpController.sendRequestPost("api/v1/login", LoginDto(userEmail: Id,  userPassword: password).toMap()));
                if (response != null) {
                  Map<String, dynamic> decodedToken = JwtDecoder.decode(response.jwt);
                  // Now you can use your decoded token
                  print("토큰 이름");
                  print(decodedToken["sub"]); // 유저 이름
                  bool isTokenExpired = JwtDecoder.isExpired(response.jwt);

                  if (!isTokenExpired) {
                    // The user should authenticate
                    print("토근 유효함");
                  }
                  // 이 토큰

                  /* getExpirationDate() - this method returns the expiration date of the token */
                  DateTime expirationDate = JwtDecoder.getExpirationDate(response.jwt);
                  print(expirationDate);

                  AppConfig.users.userToken = response.jwt;

                 Profile profile = Profile.fromMap(await HttpController.sendRequestGet('api/v1/getProfile'));
                  print(profile.toString());
                  AppConfig.users = Users(
                      userToken: response.jwt, userNickName: profile.userNickname, userFirebaseToken: 'fire', userImageUrl: profile.imagUrl ?? '');
                  AppConfig.userLogin(AppConfig.users, remember);
                  await Util.setSharedBool("userLogined", true);
                  print(await Util.getSharedBool("userLogined"));
                  print(AppConfig.users.userNickName);
                  Get.offAll(MainPage());
//                  Navigator.pushNamed(context, HomeScreen.routeName);
                }
              } else
                print("false");
            },
          ),
        ],
      ),
    );
  }

  // 비밀번호 검증 필드
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
//          Scaffold.of(context).showSnackBar(snackbar);
          Get.snackbar("Hello Korean", "Please input password more than 8 character", snackPosition: SnackPosition.BOTTOM);
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

  // 이메일 입력 필드
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
        else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
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

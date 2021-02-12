
import 'package:flutter/material.dart';
import 'package:hellokorean/components/custom_surfix_icon.dart';
import 'package:hellokorean/components/default_button.dart';
import 'package:hellokorean/components/form_error.dart';
import 'package:hellokorean/config/appConfig.dart';
import 'package:hellokorean/config/size_config.dart';
import 'package:hellokorean/models/Users.dart';
import 'package:hellokorean/models/dto/SignUpDto.dart';
import 'package:hellokorean/utils/firebaseController.dart';
import 'package:hellokorean/utils/httpcontroller.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../config/constants.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String conform_password;
  String nickName;
  String userId;
  bool remember = true;

  // 검증 체크.
  bool _emailDone = false;
  bool _nicknameDone = false;
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
          SizedBox(height: getProportionateScreenHeight(10)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),
          buildConformPassFormField(),
          SizedBox(height: getProportionateScreenHeight(10)),

          SizedBox(height: getProportionateScreenHeight(10)),
          buildNickNameFormField(),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Try Join!",
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                print("값 유효?" + email);
                SignUpDto signUpDto = SignUpDto(userId, conform_password, nickName, email, "FirebaseController.firebaseToken", "hello");
                String token = await HttpController.sendRequest("signUp", signUpDto.toJson());
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
                }

                // if all are valid then go to success screen

              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conform_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.isNotEmpty && password == conform_password) {
          removeError(error: kMatchPassError);
        }
        conform_password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: kMatchPassError);
          return "";
        }
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

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 9) {
          removeError(error: kShortPassError);
        }
        password = value;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
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

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
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
        return null;
      },
      decoration: InputDecoration(
        labelText: "별명",
        hintText: "별명을 입력하세요.",
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




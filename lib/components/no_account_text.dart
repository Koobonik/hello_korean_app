import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellokorean/config/constants.dart';
import 'package:hellokorean/config/size_config.dart';
import 'package:hellokorean/views/sign_in/sign_in_screen.dart';
import 'package:hellokorean/views/sign_in/sign_up/sign_up_screen.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Don't you have an account?",
            style: TextStyle(fontSize: getProportionateScreenWidth(16)),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Join Us!",
                style: TextStyle(
                    fontSize: getProportionateScreenWidth(16),
                    color: kPrimaryColor),
              ),
            ),
          ),

        ],
      ),
      Container(height: 16,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "한국인이세요?",
            style: TextStyle(fontSize: getProportionateScreenWidth(16)),),
          GestureDetector(
            onTap: () => Get.to(SignUpScreen()),
//                Navigator.pushNamed(context, SignUpScreen.routeName),
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "회원가입 하기",
                style: TextStyle(
                    fontSize: getProportionateScreenWidth(16),
                    color: kPrimaryColor),
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}

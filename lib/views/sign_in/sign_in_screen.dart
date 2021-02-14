import 'package:flutter/material.dart';
import 'package:hellokorean/config/size_config.dart';
import 'components/body.dart';
import 'package:hellokorean/config/constants.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text("Login"),
      ),
      body: Body(),
    );
  }
}

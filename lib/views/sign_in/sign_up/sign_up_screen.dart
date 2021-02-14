import 'package:flutter/material.dart';
import 'package:hellokorean/config/constants.dart';

import 'components/body.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        title: Text("Join"),
      ),
      body: Body(),
    );
  }
}

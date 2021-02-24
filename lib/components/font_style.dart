import 'package:flutter/material.dart';
import 'package:hellokorean/config/size_config.dart';

class MTextStyle {
  static TextStyle bold20white = TextStyle(
    fontSize: getProportionateScreenWidth(20),
    fontWeight: FontWeight.bold,
    color: Colors.white
  );
}
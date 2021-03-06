import 'package:flutter/material.dart';
import 'package:hellokorean/config/constants.dart';
import 'package:hellokorean/config/size_config.dart';

import 'font_style.dart';


class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key key,
    this.text,
    this.press,
  }) : super(key: key);
  final String text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: getProportionateScreenHeight(56),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: press != null  ? kButtonColor : Colors.grey,
        onPressed: press != null ? press : null,
        child: Text(
          text,
          style: MTextStyle.bold20white
        ),
      ),
    );
  }
}

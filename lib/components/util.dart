import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Util {
  static ProgressDialog getLoadingProgressDialog(BuildContext context, String text, bool dismissible){
    ProgressDialog pr = new ProgressDialog(context, isDismissible: dismissible);

    pr.style(
        message: text,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Container(padding: EdgeInsets.all(10),child: CircularProgressIndicator()),
        elevation: 30.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    return pr;
  }
}
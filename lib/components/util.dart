import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
const int MAXIMUN_SEC = 60;
const int MAXIMUN_MIN = 60;
const int MAXIMUN_HOUR = 24;
const int MAXIMUN_DAY = 31;
const int MAXIMUN_DAY_MONTH = 365;
class Util {
  static Future<void> setSharedString(String key, value) async {
    if (key != null && value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    }
  }

  static Future<String> getSharedString(String key) async {
    if (key != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }
    return null;
  }

  static Future<void> setSharedInt(String key, value) async {
    if (key != null && value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, value);
    }
  }

  static Future<int> getSharedInt(String key) async {
    if (key != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt(key);
    }
    return null;
  }

  static Future<void> setSharedBool(String key, value) async {
    if (key != null && value != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    }
  }

  static Future<bool> getSharedBool(String key) async {
    if (key != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool(key);
    }
    return null;
  }

  static Future<void> addSharedCount(String key) async {
    if (key != null) {
      int a = await Util.getSharedInt(key) ?? 0;
      setSharedInt(key, ++a);
    }
  }

  static void delSharedString(String key) async {
    try {
      if (key != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove(key);
      }
    } on Exception {
      print('delExceptioni');
    }
  }

  static void allDeleteSharedString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static String dateString(DateTime dateTime) {
    final now = DateTime.now();
    //미래는 표시하지 않음
    if (dateTime.isAfter(now)) return '';

    final difference = now.difference(dateTime);
    if (difference.inSeconds < MAXIMUN_SEC) return '${difference.inSeconds}초 전';
    if (difference.inMinutes < MAXIMUN_MIN) return '${difference.inMinutes}분 전';
    if (difference.inHours < MAXIMUN_HOUR) return '${difference.inHours}시간 전';
    if (difference.inDays < MAXIMUN_DAY) return '${difference.inDays}일 전';
    if (difference.inDays < MAXIMUN_DAY_MONTH)
      return '${(difference.inDays / 30).round()}달 전';

    return '${(difference.inDays / 365).round()}년 전';
  }

  static String leftDateString(String dateTimeString ) {
    if(dateTimeString == null || dateTimeString.isEmpty)
      return '';
    final dateTime = DateTime.parse(dateTimeString);

    if(dateTime == null)
      return '';

    final now = DateTime.now();
    if (dateTime.isBefore(now)) return '종료됨';

    final difference = dateTime.difference(now);
    if (difference.inHours < MAXIMUN_HOUR) return '${difference.inHours}시간 전';
    if (difference.inDays < MAXIMUN_DAY) return '${difference.inDays}일 전';
    if (difference.inDays < MAXIMUN_DAY_MONTH)
      return '${(difference.inDays / 30).round()}달 전';

    return '${(difference.inDays / 365).round()}년 전';
  }


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
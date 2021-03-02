import 'dart:io';

import 'package:get/get.dart';
import 'package:hellokorean/config/httpcontroller.dart';

class SignUp {
  
  Future<bool> requestEmailCode(Map map) async {
    HttpClientResponse response = await HttpController.sendRequest("api/v1/sendEmailForAuthEmail", map);
    if(response.statusCode == 200)
      return true;
    return false;
  }
}

class Recipient{
  String recipient;

  Recipient(this.recipient);

  Map<String, dynamic> toMap() {
    return {
      'recipient': recipient,
    };
  }
}
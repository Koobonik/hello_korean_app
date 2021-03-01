import 'dart:convert';
import 'dart:io';

import '../config/appConfig.dart';



class HttpController {
  static sendRequest(String url, Map map) async{
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    //String url ='https://cafecostes.com/flutter/saveShopping';
    //Map map = { "userName" : name , "list" : order, "sum_cost" : money, "num" : nums};
    HttpClientRequest request = await client.postUrl(Uri.parse(AppConfig.baseUrl+url));
    request.headers.set('content-type', 'application/json');
    if(AppConfig.users.userToken != null){
      request.headers.set("JWT", AppConfig.users.userToken);
    }
    request.add(utf8.encode(json.encode(map)));
    print("map : " + map.toString());
    HttpClientResponse response = await request.close();
    String reply = "";
    if(response.statusCode == 200){
      reply = await response.transform(utf8.decoder).join();
      print("Response : " + reply);
      return reply;
    }
    else if(response.statusCode == 409) {
      reply = await response.transform(utf8.decoder).join();
      print(reply);
      DefaultResponse defaultResponse = DefaultResponse.fromMap(reply);
      return defaultResponse;
    }

  }


}
class DefaultResponse {
  int code;
  String message;


  DefaultResponse({this.code, this.message});

  Map<String, dynamic> toMap() {
    return {'code': code, 'message': message,};
  }

  factory DefaultResponse.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return DefaultResponse(
      code: null == (temp = map['code']) ? null : (temp is num
          ? temp.toInt()
          : int.tryParse(temp)),
      message: map['message']?.toString(),
    );
  }

}
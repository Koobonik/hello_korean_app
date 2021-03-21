import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'appConfig.dart';


class HttpController {
  static sendRequestPost(String url, Map map) async{

    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    //String url ='https://cafecostes.com/flutter/saveShopping';
    //Map map = { "userName" : name , "list" : order, "sum_cost" : money, "num" : nums};
    HttpClientRequest request = await client.postUrl(Uri.parse(AppConfig.getHostUrl()+url));
    request.headers.set('content-type', 'application/json');
    // if(AppConfig.users.userToken != null){
    //   request.headers.set("JWT", AppConfig.users.userToken);
    // }
    request.add(utf8.encode(json.encode(map)));
    print("map : " + map.toString());
    HttpClientResponse response = await request.close();
    print("response code -> ${response.statusCode}");
    final reply = await response.transform(utf8.decoder).join();
    print(reply);
    if(response.statusCode == 409){
      print("정상반환 되나?");
      DefaultResponse defaultResponse = DefaultResponse.fromMap(jsonDecode(reply));
      Get.snackbar("HelloKorean", '${defaultResponse.message}');
      throw DefaultResponse.fromMap(reply);
      // return null;
    }
    return reply;
    // if(response.statusCode == 200){
    //   reply = await response.transform(utf8.decoder).join();
    //   print("Response : " + reply);
    //   return reply;
    // }
    // else if(response.statusCode == 409) {
    //   reply = await response.transform(utf8.decoder).join();
    //   print(reply);
    //   DefaultResponse defaultResponse = DefaultResponse.fromMap(reply);
    //   return defaultResponse;
    // }

  }


}
class DefaultResponse {
  int code;
  String message;


  DefaultResponse({this.code, this.message});

  factory DefaultResponse.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return DefaultResponse(
      code: null == (temp = map['code'])
          ? null
          : (temp is num ? temp.toInt() : int.tryParse(temp)),
      message: map['message']?.toString(),
    );
  }
}
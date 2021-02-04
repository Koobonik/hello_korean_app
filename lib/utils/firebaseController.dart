import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseController {
  static FirebaseMessaging fi = FirebaseMessaging();
  static String firebaseToken;
  static void firebaseconfig(){

    // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    // var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    // var ios = new IOSInitializationSettings();
    // var platform = new InitializationSettings(android, ios);
    // flutterLocalNotificationsPlugin.initialize(platform);
    fi.configure(
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch called');
      },
      // 백그라운드에서 동작하고 있으며 푸시 알림 클릭해서 들어올 경우
      onResume: (Map<String, dynamic> message) async {
        print('onResume called');
        print(message['url']);
      },
      // 포그라운드에서
      onMessage: (Map<String, dynamic> message) async {
        //print(message['location']);
        print("음");
        if(message['url'] == "orderlist"){
          print("들어오는디");
        }
        else{
          print("왜안들어올까");

          print("hi");
        }

        print('onMessage calledd');
      },
    );
    fi.subscribeToTopic('all');
    fi.requestNotificationPermissions(IosNotificationSettings(
        alert: true,
        badge: true,
        sound: true
    ));
    fi.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('iOS Setting Registed');
    });

    // 얘가 토근 가져오는거
    fi.getToken().then((token) {
      print("--- firebase token ---");
      print(token); // Print the Token in Console
      firebaseToken = token;
    });
  }
}

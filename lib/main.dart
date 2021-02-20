import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellokorean/config/appConfig.dart';
import 'package:hellokorean/config/routes.dart';
import 'package:hellokorean/config/size_config.dart';
import 'package:hellokorean/views/sign_in/sign_in_screen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HelloKorean',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppConfig.userLogined ? MyHomePage(title: 'Hello Korean') : SignInScreen(),
      initialRoute: AppConfig.userLogined ? MyHomePage.routeName : SignInScreen.routeName,
      routes: routes,
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  static String routeName = "/sign_in";

  final String title;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: Platform.isIOS || Platform.isMacOS
          ? CupertinoNavigationBar(
              middle: Text(title),
            )
          : AppBar(
              centerTitle: true,
              title: Text(title),
            ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              "Provider.of<Users>(context).id.toString()",
              style: Theme.of(context).textTheme.headline4,
            ),
            RaisedButton(
              child: Text("hihi"),
                onPressed: (){

            })
          ],
        ),
      ),
      floatingActionButton:FloatingActionButton(
          onPressed: (){},
          tooltip: 'Increment',
          child: Icon(Icons.add)) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

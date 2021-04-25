import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hellokorean/config/colors.dart';
import 'package:hellokorean/config/size_config.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      top: false,
      bottom: false,
      child: Scaffold(
        body:
        _currentIndex == 0 ? Center(child: Text("홈"),) :
        _currentIndex == 1 ? Center(child: Text("어나더"),) :
            _currentIndex == 2 ? Center(child: Text("3페이지"),):
         Center(child: Text("4페이지"),),
        extendBody: true,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: MColors.red,
          title: Text("Hello Korean"),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom : SizeConfig.safeAreaBottom ?? 0),
          child: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i),
            items: [
              /// Home
              SalomonBottomBarItem(
                icon: Icon(Icons.home),
                title: Text("Home"),
                selectedColor: MColors.blue,
              ),

              /// Likes
              SalomonBottomBarItem(
                icon: Icon(Icons.favorite_border),
                title: Text("Likes"),
                selectedColor: MColors.blue,
              ),

              /// Search
              SalomonBottomBarItem(
                icon: Icon(Icons.search),
                title: Text("Search"),
                selectedColor: MColors.blue,
              ),

              /// Profile
              SalomonBottomBarItem(
                icon: Icon(Icons.person),
                title: Text("Profile"),
                selectedColor: MColors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

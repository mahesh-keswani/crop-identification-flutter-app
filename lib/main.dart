import 'package:flutter/material.dart';
import 'package:animated_splash/animated_splash.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';
import 'home_page.dart';
import 'about_page.dart';
import 'my_map.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AnimatedSplash(
        imagePath: 'assets/logo.jpeg',
        home: HomePage(),
        duration: 2500,
        type: AnimatedSplashType.StaticDuration
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: ShiftingTabBar(
            color: Colors.greenAccent,
            tabs: [
              ShiftingTab(
                icon: Icon(Icons.home),
                text: "Home"
              ),
              ShiftingTab(
                icon: Icon(Icons.account_circle),
                text: "Crops"
              ),
              ShiftingTab(
                icon: Icon(Icons.map),
                text: "Map"
              ),
              
            ],
          ),
          body: TabBarView(
            children: <Widget>[
              MyHomePage(),
              AboutPage(),
              Text("My Map"),
              
            ],
          ),
        ),
      ),
    );
  }
}


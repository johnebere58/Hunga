//FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
import 'dart:convert';
import 'dart:ui';

import 'package:Hunga/ListFoods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'AppEngine.dart';
import 'assets.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext c) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Hunga",
        color: white,
        theme: ThemeData(fontFamily: 'Nirmala', focusColor: app_red),
        home: MainHome() //MainHome()
        );
  }
}

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 1),(){

    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: app_color,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            getMyAsset("food_back", ext: "jpg",),
            fit: BoxFit.cover,
          ),
          Center(
            child: ClipRect(
              child: Container(
                height: 180,
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                    child: Container(
                      color: white.withOpacity(.7),
                    )),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  getMyAsset("ic_plain"),
                  color: Colors.black,
                ),
                addSpace(10),
                Container(
                  height: 40,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: FlatButton(
                    onPressed: (){
                      pushAndResult(context, ListFoods(),
                          transitionBuilder: fadeTransition);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                    ),
                    color: app_color,
                    child: Text("View Menu",style: textStyle(true, 16, white),),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
//        child:loadingLayout()
    );
  }
}

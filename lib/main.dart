import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/signin.dart';
import '../pages/signup.dart';
import '../pages/home.dart';
import '../pages/movieinfo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FreeTV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          textTheme: const TextTheme(
              bodyText1: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: "Rajdhani",
          ),
            bodyText2: TextStyle(
              // fontSize: 15,
              fontFamily: "Rajdhani"
            )

          ),

          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xFF0B314C)),
          ))),
      home: const Signin(),
      routes: {
        "/signup":(ctx)=>Signup(),
        "/home" : (ctx) => Home(),
        "/movieinfo" : (ctx) => MovieInfo(),
      },
    );
  }
}


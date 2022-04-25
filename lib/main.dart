import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../pages/signin.dart';
import '../pages/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          textTheme: const TextTheme(
              bodyText1: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          )),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xFF0B314C)),
          ))),
      home: const Signin(),
      routes: {"/signup":(ctx)=>Signup()},
    );
  }
}


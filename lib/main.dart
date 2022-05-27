import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../pages/movieinfo.dart';
import '../pages/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  /* TODO
    1. Let there be an alimght parameter to check so we can clear all movies record in app and refetch everything,
      just incase there is an error and we need to change the database.

   */
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<bool> checkPermissionfuture;

  Future<bool> checkPermission() async {
    bool status = false;

    try {
      if (await Permission.storage.status.isGranted) {
        status = true;
      } else {
        try {
          var result = await Permission.storage.request();
          // print ("the reuls of the requeist is $result");
          if (result == PermissionStatus.granted) {
            status = true;
          } else if (result == PermissionStatus.permanentlyDenied) {
            openAppSettings();
          } else {
            checkPermission();
          }
        } catch (e) {
          print("error granting permsission $e");
          checkPermission();
        }
      }
    } catch (e) {
      print("error checking premission status $e");
      status = false;
    }
    return status;
  }

  Future<void> createDatabaseAndTables() async {
    //TODO move this to the splash page, the splash page will be an animated Loading page
    // Create all the needed database and tables

    try {
      if (!(await databaseExists(
          join(await getDatabasesPath(), "moviesInfo.db")))) {
        // print("Creating the database");
        //if movies information database does not exist create it
        Database database = await openDatabase(
          join(await getDatabasesPath(), "moviesInfo.db"),
        );
        await database.execute(
            'CREATE TABLE info (movieId INTEGER PRIMARY KEY NOT NULL,title TEXT NOT NULL,year INTEGER NOT NULL,description TEXT NOT NULL,link TEXT NOT NULL,adult INTEGER NOT NULL)');
      }

      if (!(await databaseExists(
          join(await getDatabasesPath()) + "categories.db"))) {
        //if categories database does not exist create it
        final database =
            openDatabase(join(await getDatabasesPath() + "categories.db"));
      }
    } catch (e) {
      print("error in creating database $e");
    }
  }

  @override
  void initState() {
    super.initState();
    createDatabaseAndTables();
    checkPermissionfuture = checkPermission();
  }

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
                  fontFamily: "Rajdhani")),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xFF0B314C)),
          ))),
      home: FutureBuilder(
          future: checkPermissionfuture,
          builder: (context, snapShot) {
            if (snapShot.hasData) {
              bool data = snapShot.data as bool;
              if (data) {
                return Home();
              }
            }
            if (snapShot.hasError) {
              print("error checing permission ${snapShot.error}");
              return Text("Error");
            } else {
              print("error checing permission ${snapShot.error}");
              return Container();
            }
          }),
      routes: {
        // "/signup":(ctx)=> Signup(),
        "/home": (ctx) => Home(),
        // "/movieinfo": (ctx) => MovieInfo(),
      },
    );
  }
}

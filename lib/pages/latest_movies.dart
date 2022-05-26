import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../widgets/bannerAdWidget.dart';
import '../widgets/highest_rated_movies.dart';
import '../widgets/latest_movies_widget.dart';
import '../helpers/database_actions.dart';

Future<List<String>> getTopRatedMovies() async {
  //get the sorted list of top rated movies

  List<String> sortedResult = [];
  // List<MovieInfo> highRatedMoviesInfo = [];
  // FetchMovieInfo fetchMovieInfo = FetchMovieInfo();

  try {
    var response = await Dio()
        .get("https://freetv-7c1f4-default-rtdb.firebaseio.com/ratings.json");
    Map<String, dynamic> result = response.data;
    List<int> values = [];

    values = List.from(result.values);
    values.sort();
    values.reversed;
    values = List.from(values.reversed);

    values.forEach((element) {
      // result.containsValue(element);
      List<String> keys =
          List.from(result.keys.where((key) => result[key] == element));
      sortedResult.addAll(keys); //save all the ID of the top rated movies
      for (var element in keys) {
        //remove all the checked keys;
        result.removeWhere((key, value) => key == element);
      }
    });

    return sortedResult;

  } on DioError catch (e) {
    print("Error getting top rated movies $e");
    return sortedResult;
  } catch (e) {
    print("Non dio error occured fetching top rated movies $e");
    return sortedResult;
  }
}

Future<List<int>> getLatestMovies() async {
  Map<String, dynamic> result = {};
  List<int> moviesId = [];
  bool fetchFromRemote = await getFromRemote();

  if (fetchFromRemote) {
    //get from remote
    try {
      //get the movies id from firestore realtime db
      var response = await Dio()
          .get("https://freetv-7c1f4-default-rtdb.firebaseio.com/movies.json");
      result = response.data;

      result.forEach((key, value) {
        //get all the movies ID that exists;
        moviesId.addAll(List.from(value));
      });
      Dio().close();

      return moviesId;
    } on DioError catch (e) {
      print("Error fetching all movies $e");
      return moviesId;
    } catch (e) {
      print("Error filling the request $e");
      return moviesId;
    }
  } else {
    //get from local
    final moviesDatabase =
        await openDatabase(join(await getDatabasesPath(), "moviesInfo.db"));
    moviesId.addAll(
        List.from(await DatabaseActions().getLatestMoviesInfo(moviesDatabase)));
    return moviesId;
  }
}

Future<bool> getFromRemote() async {
  //compare the remote database version to the local version
  // this is so we know wether the remote database has changed
  // so we dont have to fetch the remote data everytime
  // instead we use the local version

  int version = 1;
  // print ("in getfrom remote function $version");
  final _localVersion = await SharedPreferences.getInstance();

  try {
    //get the movies id from firestore realtime db
    var response = await Dio()
        .get("https://freetv-7c1f4-default-rtdb.firebaseio.com/version.json");
    version = response.data;
    // print ("the version is $version");

    Dio().close();

    if (_localVersion.containsKey("version")) {
      // if the shared preference key is yet to be created
      if (_localVersion.getInt("version")! <= version) {
        //if local version is less than the remote version
        // then we should not fetch from remove database
        // so return false
        return false;
      } else {
        // else return true and fetch from the remote
        // database
        return true;
      }
    } else {
      //create it then fetch from the remote database
      // by returning true
      _localVersion.setInt("version", version);
      return true;
    }
  } on DioError catch (e) {
    // if there is an error then we return false
    // so we get the local version instead
    print("Error comparing versions $e");
    return false;
  } catch (e) {
    print("Error filling the comparing version request $e");
    return false;
  }
}

class LatestMovies extends StatefulWidget {
  const LatestMovies({Key? key}) : super(key: key);

  @override
  State<LatestMovies> createState() => _LatestMoviesState();
}

class _LatestMoviesState extends State<LatestMovies> {
  /*TODO save the images of the movies locally so we dont have to fetch from server everytime */

  Future<void> refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refresh,
      child: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                HighRatedMoviesWidget(),
                DisplayBannerAdWidget(),
                SizedBox(
                  width: 200,
                  height: 100,
                  child: SvgPicture.asset(
                    'assets/images/themoviedb.svg',
                    color: Colors.blue,
                    semanticsLabel: 'TheMovieDb logo',
                  ),
                ),
                LatestMoviesWidget(),
              ],
            ),
          )
        ],
      ),
    );
  }
}







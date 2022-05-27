import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../helpers/apikeys.dart';
import '../helpers/get_movie_info.dart';
import '../helpers/database_actions.dart';

// import '../helpers/movie_info.dart';
import '../pages/movieinfo.dart';

class MoviePoster extends StatefulWidget {
  final int movieId;

  const MoviePoster({Key? key, required this.movieId}) : super(key: key);

  @override
  State<MoviePoster> createState() => _MoviePosterState();
}

class _MoviePosterState extends State<MoviePoster> {
  final FetchMovieInfo fetchMovieInfo = FetchMovieInfo();
  final DatabaseActions _databaseActions = DatabaseActions();
  late Future<String> imageLink;
  late Future<bool> imageExists;

  // Future<void> initializeDatabase() async {
  //   try{
  //     _movieInfoDatabase = ,
  //     );
  //   }catch(e){
  //     print ("Error creating movie info database $e");
  //   }
  //   _categoryInfoDatabase =
  //   );
  // }

  Future<void> addRecordToDatabase() async {
    //for each successful data retrieved from the remote database
    // add the record to the database for offline retrieval
    final moviesDatabase =
        await openDatabase(join(await getDatabasesPath(), "moviesInfo.db"));
    if (!(await _databaseActions.movieExistsInDatabase(
        moviesDatabase, widget.movieId))) {
      // if record does not exist in database then fetch and add the record to the database
      _databaseActions.addMovieInfoToDatabase(moviesDatabase,
          await fetchMovieInfo.getMovieInformation(widget.movieId, myApiKey));
    }
  }

  Future<void> saveMoviePosterLocally(String link, String movieId) async {
    // WidgetsFlutterBinding.ensureInitialized();
    final temp = await getApplicationDocumentsDirectory();
    String path = temp.path;
    Response<List<int>> response;
    response = await Dio().get<List<int>>(link,
        options: Options(responseType: ResponseType.bytes));
    final file = File('$path/$movieId.jpeg');
    file.writeAsBytesSync(response.data!); //write the gotten image to disk
  }

  Future<bool> imageExistLocally(String movieId) async {
    final temp = await getApplicationDocumentsDirectory();
    String path = temp.path;
    if (File('$path/$movieId.jpeg').existsSync()) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> getImageLinkOrPath() async {
    addRecordToDatabase();
    if (await imageExistLocally(widget.movieId.toString())) {
      final temp = await getApplicationDocumentsDirectory();
      String path = temp.path;
      return '$path/${widget.movieId}.jpeg';
    } else {
      String image = await fetchMovieInfo.getImageLink(widget.movieId);
      saveMoviePosterLocally(
          image, widget.movieId.toString()); //save the image locally
      return image;
    }
  }

  @override
  void initState() {
    super.initState();
    imageLink = getImageLinkOrPath();
    imageExists = imageExistLocally(widget.movieId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: imageLink,
        builder: (ctx, asyncSnapShot) {
          if (asyncSnapShot.connectionState == ConnectionState.done) {
            if (asyncSnapShot.hasData) {
              String data = asyncSnapShot.data as String;

              if (data != "") {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            MovieInfo(movieId: widget.movieId)));
                  },
                  child: SizedBox(
                      width: 100,
                      height: 100,
                      child: FutureBuilder(
                        future: imageExists,
                        builder: (context, asyncSnapShot) {
                          if (asyncSnapShot.hasData) {
                            bool status = asyncSnapShot.data as bool;

                            if (status) {
                              return Image.file(File(data));
                            } else {
                              return Image.network(data);
                            }
                          } else if (asyncSnapShot.hasError) {
                            print("Error getting the local status of image");
                            return Container();
                          } else {
                            return Container();
                          }
                        },
                      )),
                );
              } else {
                return Container();
              }
            } else if (asyncSnapShot.hasError) {
              print(
                  "Error filling the image of the movie ${asyncSnapShot.error}");
              return SizedBox(
                width: 10,
                height: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      strokeWidth: 10,
                    )
                  ],
                ),
              );
            } else {
              return SizedBox(
                width: 100,
                height: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      strokeWidth: 1,
                    )
                  ],
                ),
              );
            }
          } else {
            return SizedBox(
              width: 100,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(
                    strokeWidth: 1,
                  )
                ],
              ),
            );
          }
        });
  }
}

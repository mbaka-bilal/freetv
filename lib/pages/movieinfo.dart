import 'dart:convert';
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:freetv/helpers/get_movie_info.dart';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freetv/helpers/database_actions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/apikeys.dart';
import '../helpers/movie_info.dart' as information;

class MovieInfo extends StatefulWidget {
  final int movieId;

  const MovieInfo({Key? key, required this.movieId}) : super(key: key);

  @override
  State<MovieInfo> createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfo> {
  // Future<Map<String, dynamic>>? movieInfo;
  final String apiKey = myApiKey;
  String? imageLink;
  DatabaseActions databaseActions = DatabaseActions();
  FetchMovieInfo fetchMovieInfo = FetchMovieInfo();
  late Future<information.MovieInfo> getMovie;
  late Future<bool> isImageLocal;

  Future<information.MovieInfo> getMovieInfo(int id) async {
    information.MovieInfo info = information.MovieInfo(movieId: id);

    if (await imageExistLocally(id.toString())) {
      final temp = await getApplicationDocumentsDirectory();
      String path = temp.path;
      imageLink = '$path/$id.jpeg';
    } else {
      imageLink = await fetchMovieInfo.getImageLink(widget.movieId);
    }

    try {
      final moviesDatabase =
          await openDatabase(join(await getDatabasesPath(), "moviesInfo.db"));

      if (await databaseActions.movieExistsInDatabase(moviesDatabase, id)) {
        print("Movie exist in database");
        info = await databaseActions.getMovieInformation(
            moviesDatabase, widget.movieId);
        return info;
      } else {
        info = await fetchMovieInfo.getMovieInformation(widget.movieId, apiKey);
        return info;
        // var response = await Dio()
        //     .get("https://api.themoviedb.org/3/movie/${id}?api_key=$apiKey");
        // // print ("the response ${response.data["adult"]}");
        // info["adult"] = response.data["adult"];
        // info["original_title"] = response.data["original_title"];
        // info["overview"] = response.data["overview"];
        // info["release_date"] = response.data["release_date"];
      }
      // print ("the info is $info");
    } catch (e) {
      print("error $e");
      return info;
    }
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

  @override
  void initState() {
    super.initState();
    getMovie = getMovieInfo(widget.movieId);
    isImageLocal = imageExistLocally(widget.movieId.toString());
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
          future: getMovie,
          builder: (ctx, asyncSnapShot) {
            if (asyncSnapShot.connectionState == ConnectionState.done) {
              if (asyncSnapShot.hasData) {
                information.MovieInfo data =
                    asyncSnapShot.data as information.MovieInfo;

                print("the data is ${data.toString()}");

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height / 1.7,
                      child: Stack(
                        children: [
                          FutureBuilder(
                            future: isImageLocal,
                            builder: (context, asyncSnapShot) {
                              if (asyncSnapShot.hasData) {
                                bool isLocal = asyncSnapShot.data as bool;

                                return SizedBox(
                                    height: height / 1.7,
                                    width: width,
                                    child: (isLocal)
                                        ? Image.file(
                                            File(imageLink!),
                                          )
                                        : Image.network(imageLink!));
                              } else if (asyncSnapShot.hasError) {
                                print(
                                    "Error checking if image exist locally in movieinfo.dart ${asyncSnapShot.error}");
                                print(
                                    "Error checking if image exist locally in movieinfo.dart ${asyncSnapShot.error}");
                                return Container();
                              } else {
                                return Container();
                              }
                            },
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 50.0, left: 40),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  icon: const Icon(Icons.arrow_back),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 30, left: 40),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Text("${data["original_title"]}",style: Theme.of(context).textTheme.bodyText1,),
                                        Text(
                                          "Release year: ${data.year}",
                                          // "Release year: ${DateTime.parse(data.year.toString()).year.toString()}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 50.0),
                                      child: (data.adult == 0)
                                          ? Text("18+",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1)
                                          : const Text(""),
                                    )
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 30,
                          child: IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.favorite,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 30,
                          child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.black,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(100),
                                          topRight: Radius.circular(100))),
                                  context: context,
                                  builder: (ctx) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Rate this movie",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        RatingsRow(
                                          movieId: widget.movieId,
                                        ),
                                      ],
                                    );
                                  });
                            },
                            icon: const Icon(
                              Icons.star,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                         CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 30,
                          child: IconButton(
                            onPressed: () async {
                              //add the movie to the queue
                              var response = await Dio().get("https://freetv-7c1f4-default-rtdb.firebaseio.com/download_links/${widget.movieId}.json");
                              String url = response.data;
                              //TODO add an alert to let the user know incase there is no data connection
                              //TODO refactor the code to fetch the url and save it locally
                              // print ("the url is $url");

                              List<DownloadTask>? _moviesList = await FlutterDownloader.loadTasks();

                              for (int i=0;i<_moviesList!.length;i++){
                                //if movie is already in queue
                                if (_moviesList[i].url == url){
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      duration: Duration(seconds: 1),
                                      content: (Text('Movie already in queue'))));
                                  return;
                                }
                              }

                             String? id =  await FlutterDownloader.enqueue(url:
                                  url,
                                  savedDir: '/storage/emulated/0/Download',
                                  showNotification: true,
                              );

                              // Future.delayed(Duration(seconds: 20));
                              //
                              FlutterDownloader.pause(taskId: id!);



                              // print ('the id is ${id}');
                            },
                            icon: Icon(
                              Icons.download,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: SvgPicture.asset(
                          'assets/images/themoviedb.svg',
                          color: Colors.blue,
                          semanticsLabel: 'TheMovieDb logo',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Description",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: SizedBox(
                            width: width / 1.2,
                            child: SingleChildScrollView(
                              child: Text(
                                data.description,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            )),
                      ),
                    )
                  ],
                );
              } else {
                return SizedBox(
                  height: height,
                  width: width,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50.0, left: 40),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.arrow_back),
                            ),
                          ),
                        ),
                      ),
                      const Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator()),
                    ],
                  ),
                );
              }
            } else {
              return SizedBox(
                height: height,
                width: width,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0, left: 40),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.white,
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back),
                          ),
                        ),
                      ),
                    ),
                    const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator()),
                  ],
                ),
              );
            }
          },
        ));
  }
}

class RatingsRow extends StatefulWidget {
  /* widget to handle draggable ratings */

  final int movieId;

  const RatingsRow({Key? key, required this.movieId}) : super(key: key);

  @override
  State<RatingsRow> createState() => _RatingsRowState();
}

class _RatingsRowState extends State<RatingsRow> {
  int ratingLevel = 0;
  int currentPosition = 0;
  bool done = true;

  @override
  Widget build(BuildContext context) {
    // print ("in here");
    return Column(
      children: [
        GestureDetector(
          onHorizontalDragStart: (dragStartDetails) {
            /* store the value of the starting position based on local value of the Row */
            currentPosition = dragStartDetails.localPosition.dx.toInt();
          },
          onHorizontalDragUpdate: (DragUpdateDetails dragUpdateDetails) {
            // print ("the chage is ${dragUpdateDetails.localPosition.dx.toInt() - currentPosition}");
            if ((dragUpdateDetails.localPosition.dx.toInt() - currentPosition) >
                10) {
              /* update the rating level everytime we move 10 positions from the localPosition */
              currentPosition = dragUpdateDetails.localPosition.dx.toInt();
              setState(() {
                ratingLevel++;
              });
            }
            if ((currentPosition - dragUpdateDetails.localPosition.dx.toInt()) >
                10) {
              /* handle the reverse drag direction */
              currentPosition = dragUpdateDetails.localPosition.dx.toInt();
              setState(() {
                ratingLevel--;
              });
            }
          },
          onHorizontalDragEnd: (DragEndDetails dragEndDetails) {
            //update the users ratings
            // print("the rating level is  ${ratingLevel}");
            currentPosition = 0;
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              if (index < ratingLevel) {
                /* build the ratings */
                return const Icon(
                  Icons.star,
                  color: Colors.yellow,
                );
              } else {
                return const Icon(
                  Icons.star,
                  color: Colors.white,
                );
              }
            }),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  (done) ? Colors.blue : Colors.transparent),
              fixedSize: MaterialStateProperty.all(const Size(300, 50)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)))),
          onPressed: (done)
              ? () async {
                  int currentRating = 0;

                  /* TODO MOVE THIS rating to another isolate so we can do it irrespective of user closing the bottombar */
                  setState(() {
                    done = false;
                  });

                  //fetch the current rating for the movie
                  try {
                    var response = await Dio().get(
                        "https://freetv-7c1f4-default-rtdb.firebaseio.com/ratings/${widget.movieId}.json");
                    (response.data != null)
                        ? currentRating = response.data
                        : null;
                    // increment the ratings by the number of stars given
                    try {
                      await Dio().patch(
                        "https://freetv-7c1f4-default-rtdb.firebaseio.com/ratings.json",
                        data: json.encode(
                            {"${widget.movieId}": ratingLevel + currentRating}),
                      );
                      setState(() {
                        done = true;
                      });
                    } on DioError catch (e) {
                      print("the error is $e");
                    }
                  } on DioError catch (e) {
                    if (e.message == "Http status error [404]") {
                      //create the url
                      var response = await Dio().post(
                          "https://freetv-7c1f4-default-rtdb.firebaseio.com/ratings.json",
                          data: json.encode({
                            "${widget.movieId}": ratingLevel + currentRating
                          }));
                      // return;
                    }
                  } catch (e) {
                    print("Unknown error while fetching rating");
                  }
                }
              : null,
          child: Text(
            "Submit",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        )
      ],
    );
  }
}

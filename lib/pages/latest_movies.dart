import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../helpers/movie_info.dart';
import '../helpers/apikeys.dart';

class LatestMovies extends StatefulWidget {
  const LatestMovies({Key? key}) : super(key: key);

  @override
  State<LatestMovies> createState() => _LatestMoviesState();
}

class _LatestMoviesState extends State<LatestMovies> {
  /*TODO save the images of the movies locally so we dont have to fetch from server everytime */
  /* TODO Hide my API from gitHUb */

  final String apiKey = myApiKey;
  Future<List<MovieInfo>>? getLatestMoviesFuture;
  Future<List<MovieInfo>>? getTopRatedMoviesFuture;

  // List<dynamic> moviesId = []; //store all the movies ID

  Future<String> getImageLink(int id) async {
    var response = await Dio()
        .get("https://api.themoviedb.org/3/movie/$id/images?api_key=$apiKey");
    return "http://image.tmdb.org/t/p/w300/${response.data["posters"][0]["file_path"]}";
  }

  Future<List<MovieInfo>> getLatestMovies() async {
    // List<String> moviesPosterUrl = []; //store the list of movie posters url
    List<dynamic> moviesId = [];
    List<MovieInfo> latestMovies = [];

    try {
      //get the movies id from firestore realtime db
      var response = await Dio()
          .get("https://freetv-7c1f4-default-rtdb.firebaseio.com/movies.json");
      // print ("the response is ${response.data}");
      // print ("the movies list is ${response.data}");
      moviesId = List.from(response.data);
      moviesId.removeAt(0); //remove the first item because it is null
      Dio().close();
      if (moviesId.isNotEmpty) {
        for (int i = 0; i < moviesId.length; i++) {
          latestMovies.add(MovieInfo(
              movieId: moviesId[i],
              movieImageLink: await getImageLink(moviesId[i])));
        }
        Dio().close();
      }
    } catch (e) {
      print("error is $e");
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("No Internet"),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); //pop the alert dialog and reload
                        setState(() {
                          //refresh the page and try again
                        });
                      },
                      child: Text("Retry"),
                    )
                  ],
                ),
              ));
    }
    // return moviesPosterUrl;
    return latestMovies;
  }

  Future<List<MovieInfo>> getTopRatedMovies() async {
    List<String> sortedResult = [];
    var response = await Dio()
        .get("https://freetv-7c1f4-default-rtdb.firebaseio.com/ratings.json");
    Map<String, dynamic> result = response.data;
    List<int> values = [];
    List<MovieInfo> highRatedMoviesInfo = [];

    values = List.from(result.values);
    values.sort();
    values.reversed;
    values = List.from(values.reversed);

    values.forEach((element) {
      // result.containsValue(element);
      List<String> keys =
          List.from(result.keys.where((key) => result[key] == element));
      sortedResult.addAll(keys); //save all the ID of the top rated movies
      keys.forEach((element) {
        //remove all the checked keys;
        result.removeWhere((key, value) => key == element);
      });
    });

    for (var element in sortedResult) {
      highRatedMoviesInfo.add(MovieInfo(
          movieId: int.tryParse(element)!,
          movieImageLink: await getImageLink(int.tryParse(element)!)));
    }

    return highRatedMoviesInfo;
  }

  Future<void> refreshPage() async {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTopRatedMoviesFuture = getTopRatedMovies();
    getLatestMoviesFuture = getLatestMovies();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      ///fix this to work
      onRefresh: refreshPage,
      child: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "High rated",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 15.0),
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                            future: getTopRatedMoviesFuture,
                            builder: (ctx, asyncSnapShot) {
                              if (asyncSnapShot.connectionState ==
                                  ConnectionState.done) {
                                if (asyncSnapShot.hasData) {
                                  List<MovieInfo> data =
                                      asyncSnapShot.data as List<MovieInfo>;

                                  return Container(
                                    height: 150,
                                    child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (ctx, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  "/movieinfo",
                                                  arguments: {
                                                    //pass in the movie id to handle downloads and ratings
                                                    //pass in the imageUrl so we can fetch the image
                                                    "id": data[index].movieId,
                                                    "imageUrl": data[index]
                                                        .movieImageLink,
                                                  });
                                            },
                                            child: SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: Image.network(
                                                  data[index].movieImageLink),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (index, ctx) =>
                                            const SizedBox(
                                              width: 10,
                                            ),
                                        itemCount: data.length),
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              } else {
                                return CircularProgressIndicator();
                              }
                            }),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Latest",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 15.0),
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                            future: getLatestMoviesFuture,
                            builder: (ctx, asyncSnapShot) {
                              if (asyncSnapShot.connectionState ==
                                  ConnectionState.done) {
                                if (asyncSnapShot.hasData) {
                                  List<MovieInfo> data =
                                      asyncSnapShot.data as List<MovieInfo>;
                                  // print("the data is $data");
                                  return Container(
                                    height: 150,
                                    child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (ctx, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  "/movieinfo",
                                                  arguments: {
                                                    //pass in the movie id to handle downloads and ratings
                                                    //pass in the imageUrl so we can fetch the image
                                                    "id": data[index].movieId,
                                                    "imageUrl": data[index]
                                                        .movieImageLink,
                                                  });
                                            },
                                            child: SizedBox(
                                              width: 100,
                                              height: 100,
                                              child: Image.network(
                                                  data[index].movieImageLink),
                                            ),
                                          );
                                        },
                                        separatorBuilder: (index, ctx) =>
                                            const SizedBox(
                                              width: 10,
                                            ),
                                        itemCount: data.length),
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
                              } else {
                                return CircularProgressIndicator();
                              }
                            })
                      ],
                    ),
                  ),
                  // SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Most Popular",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 15.0),
                              child: Icon(Icons.arrow_forward_ios),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: 150,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (index, ctx) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.white,
                                );
                              },
                              separatorBuilder: (index, ctx) => const SizedBox(
                                    width: 10,
                                  ),
                              itemCount: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

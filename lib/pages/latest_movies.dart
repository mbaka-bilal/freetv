import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../helpers/movie_info.dart';
import '../helpers/apikeys.dart';

Future<List<MovieInfo>> getTopRatedMovies() async {
  List<String> sortedResult = [];
  List<MovieInfo> highRatedMoviesInfo = [];

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
  } catch (e) {
    return highRatedMoviesInfo;
  }
  return highRatedMoviesInfo;
}

Future<String> getImageLink(int id) async {
  final String apiKey = myApiKey;
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
    return latestMovies;
  }
  return latestMovies;
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
                LatestMoviesWidget(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class DisplayBannerAdWidget extends StatelessWidget {
  //Display the Ad
  const DisplayBannerAdWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Container(
        color: Colors.blue,
      ),
    );
  }
}

class HighRatedMoviesWidget extends StatefulWidget {
  //Display the highest rated movies
  const HighRatedMoviesWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<HighRatedMoviesWidget> createState() => _HighRatedMoviesWidgetState();
}

class _HighRatedMoviesWidgetState extends State<HighRatedMoviesWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
              future: getTopRatedMovies(), //widget.getTopRatedMoviesFuture
              builder: (ctx, asyncSnapShot) {
                if (asyncSnapShot.connectionState == ConnectionState.done) {
                  if (asyncSnapShot.hasData) {
                    List<MovieInfo> data =
                        asyncSnapShot.data as List<MovieInfo>;

                    if (data.isEmpty || data == []) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No Internet",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {});
                              },
                              child: Text(
                                "Retry",
                                style: Theme.of(context).textTheme.bodyText1,
                              ))
                        ],
                      );
                    } else {
                      return Container(
                        height: 150,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed("/movieinfo", arguments: {
                                    //pass in the movie id to handle downloads and ratings
                                    //pass in the imageUrl so we can fetch the image
                                    "id": data[index].movieId,
                                    "imageUrl": data[index].movieImageLink,
                                  });
                                },
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child:
                                      Image.network(data[index].movieImageLink),
                                ),
                              );
                            },
                            separatorBuilder: (index, ctx) => const SizedBox(
                                  width: 10,
                                ),
                            itemCount: data.length),
                      );
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ],
      ),
    );
  }
}

class LatestMoviesWidget extends StatefulWidget {
  //Display the latest movies.
  const LatestMoviesWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<LatestMoviesWidget> createState() => _LatestMoviesWidgetState();
}

class _LatestMoviesWidgetState extends State<LatestMoviesWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
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
              future: getLatestMovies(),
              builder: (ctx, asyncSnapShot) {
                if (asyncSnapShot.connectionState == ConnectionState.done) {
                  if (asyncSnapShot.hasData) {
                    List<MovieInfo> data =
                        asyncSnapShot.data as List<MovieInfo>;
                    // print("the data is $data");
                    if (data.isEmpty || data == []) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No Internet",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {});
                              },
                              child: Text(
                                "Retry",
                                style: Theme.of(context).textTheme.bodyText1,
                              ))
                        ],
                      );
                    } else {
                      return Container(
                        height: 150,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed("/movieinfo", arguments: {
                                    //pass in the movie id to handle downloads and ratings
                                    //pass in the imageUrl so we can fetch the image
                                    "id": data[index].movieId,
                                    "imageUrl": data[index].movieImageLink,
                                  });
                                },
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child:
                                      Image.network(data[index].movieImageLink),
                                ),
                              );
                            },
                            separatorBuilder: (index, ctx) => const SizedBox(
                                  width: 10,
                                ),
                            itemCount: data.length),
                      );
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                } else {
                  return CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }
}

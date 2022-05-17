import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:freetv/helpers/get_movie_info.dart';

import '../helpers/movie_info.dart';
import '../helpers/apikeys.dart';
import '../helpers/get_movie_info.dart';

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

    // for (var element in sortedResult) {
    //   highRatedMoviesInfo.add(MovieInfo(
    //       movieId: int.tryParse(element)!,
    //       movieImageLink: await getImageLink(int.tryParse(element)!)));
    // }
  } on DioError catch (e) {
    print("Error getting top rated movies $e");
    return sortedResult;
  } catch (e) {
    print("Non dio error occured fetching top rated movies $e");
    return sortedResult;
  }
  // return sortedResult;
}

// Future<String> getImageLink(int id) async {
//   final String apiKey = myApiKey;
//   var response = await Dio()
//       .get("https://api.themoviedb.org/3/movie/$id/images?api_key=$apiKey");
//   return "http://image.tmdb.org/t/p/w300/${response.data["posters"][0]["file_path"]}";
// }

Future<List<int>> getLatestMovies() async {
  // List<String> moviesPosterUrl = []; //store the list of movie posters url
  List<int> moviesId = [];
  // List<MovieInfo> latestMovies = [];
  Map<String, dynamic> result = {};

  try {
    //get the movies id from firestore realtime db
    var response = await Dio()
        .get("https://freetv-7c1f4-default-rtdb.firebaseio.com/movies.json");
    result = response.data;
    // print("the result is $result");

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
              children: const [
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
                    List<String> data = asyncSnapShot.data as List<String>;

                    if (data.isEmpty || data == []) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No Internet",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const SizedBox(
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
                      return SizedBox(
                        height: 150,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, index) {
                              return MoviePoster(
                                  movieId: int.tryParse(data[index])!);
                            },
                            separatorBuilder: (index, ctx) => const SizedBox(
                                  width: 10,
                                ),
                            itemCount: data.length),
                      );
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                } else {
                  return const CircularProgressIndicator();
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
                    List<int> data = asyncSnapShot.data as List<int>;
                    // print("the data is $data");
                    if (data.isEmpty || data == []) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No Internet",
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          const SizedBox(
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
                      return SizedBox(
                        height: 150,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, index) {
                              return MoviePoster(
                                movieId: data[index],
                              );
                            },
                            separatorBuilder: (index, ctx) => const SizedBox(
                                  width: 10,
                                ),
                            itemCount: data.length),
                      );
                    }
                  } else {
                    return const CircularProgressIndicator();
                  }
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }
}

class MoviePoster extends StatefulWidget {
  final int movieId;

  const MoviePoster({Key? key, required this.movieId}) : super(key: key);

  @override
  State<MoviePoster> createState() => _MoviePosterState();
}

class _MoviePosterState extends State<MoviePoster> {
  FetchMovieInfo fetchMovieInfo = FetchMovieInfo();
  late Future<String> imageLink;

  Future<String> getImageLink() async {
    String image = await fetchMovieInfo.getImageLink(widget.movieId);
    return image;
  }

  @override
  void initState() {
    super.initState();
    imageLink = getImageLink();
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
                    Navigator.of(context).pushNamed("/movieinfo", arguments: {
                      //pass in the movie id to handle downloads and ratings
                      //pass in the imageUrl so we can fetch the image
                      "id": widget.movieId,
                      "imageUrl": data,
                    });
                  },
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(data),
                  ),
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

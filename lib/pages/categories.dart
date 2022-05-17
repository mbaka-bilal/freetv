import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../helpers/apikeys.dart';
import '../helpers/get_movie_info.dart';
import '../helpers/movie_info.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late Future<Map<String, dynamic>> fetchFromDatabase;

  Future<Map<String, dynamic>> fetchMovies() async {
    Map<String, dynamic> data = {};
    try {
      var result = await Dio()
          .get("https://freetv-7c1f4-default-rtdb.firebaseio.com/movies.json");
      data = result.data;
    } on DioError catch (e) {
      print("Error fetching movie from firebase $e");
      return data;
    }

    try {
      var result = await Dio()
          .get("https://freetv-7c1f4-default-rtdb.firebaseio.com/ratings.json");
      data["categories"] = result.data;
    } on DioError catch (e) {
      print("Error fetching categories $e");
      return data;
    }
    return data;
  }

  @override
  void initState() {
    super.initState();
    fetchFromDatabase = fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, top: 20),
            child: FutureBuilder(
                future: fetchFromDatabase,
                builder: (ctx, asyncSnapShot) {
                  if (asyncSnapShot.connectionState == ConnectionState.done) {
                    if (asyncSnapShot.hasData) {
                      Map<String, dynamic> data =
                          asyncSnapShot.data as Map<String, dynamic>;

                      return Column(
                        children: data.entries.map((e) {
                          if (e.key != "categories") {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      e.key,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(right: 15.0),
                                      child: Icon(Icons.arrow_forward_ios),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: width,
                                  height: 300,
                                  child: GridView.builder(
                                      itemCount: e.value.length,
                                      scrollDirection: Axis.horizontal,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              mainAxisSpacing: 2,
                                              crossAxisSpacing: 2,
                                              childAspectRatio:
                                                  (width) / (height / 0.59)),
                                      itemBuilder: (ctx, index) {
                                        return MovieCard(
                                          movieId: e.value[index],
                                          allRatings: data["categories"],
                                        );
                                      }),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }).toList(),
                      );
                    } else {
                      return SizedBox(
                        height: height,
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                          ],
                        ),
                      );
                    }
                  } else {
                    return SizedBox(
                      height: height,
                      width: width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(),
                        ],
                      ),
                    );
                  }
                }),
          ),
        ));
  }
}

class MovieCard extends StatefulWidget {
  final int movieId;
  final Map<String, dynamic> allRatings;

  const MovieCard({Key? key, required this.movieId, required this.allRatings})
      : super(key: key);

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  late Future<MovieInfo> movieInfo;
  FetchMovieInfo fetchMovieInfo = FetchMovieInfo();

  Future<MovieInfo> getMovieInfo() async {
    MovieInfo result;
    result = MovieInfo(
      movieId: widget.movieId,
      movieName: await fetchMovieInfo.getMovieName(widget.movieId, myApiKey),
      movieImageLink: await fetchMovieInfo.getImageLink(widget.movieId),
      rating: await fetchMovieInfo.getMovieRating(widget.movieId.toString()),
    );
    return result;
  }

  @override
  void initState() {
    super.initState();
    movieInfo = getMovieInfo();
    // print ("the categories is ${widget.allRatings}");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: movieInfo,
        builder: (ctx, asyncSnapShot) {
          if (asyncSnapShot.connectionState == ConnectionState.done) {
            if (asyncSnapShot.hasData) {
              MovieInfo data = asyncSnapShot.data as MovieInfo;

              return (data.movieImageLink == "")
                  ? Container()
                  : Card(
                      color: Colors.black,
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.network(data.movieImageLink),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: SizedBox(
                                  width: 150,
                                  child: Text(
                                    data.movieName,
                                    softWrap: true,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text("${data.rating}")
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          const IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.download_sharp,
                              color: Color(0xFF0D70C4),
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    );
            } else if (asyncSnapShot.hasError) {
              print("Error in asyncSnapShot ${asyncSnapShot.error}");
              return Container();
            } else {
              return Column(children: const [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ]);
            }
          } else {
            return const Center(
              child: SizedBox(
                height: 10,
                width: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              ),
            );
          }
        });
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../helpers/apikeys.dart';

class MovieInfo extends StatefulWidget {
  const MovieInfo({Key? key}) : super(key: key);

  @override
  State<MovieInfo> createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfo> {
  Future<Map<String, dynamic>>? movieInfo;
  final String apiKey = myApiKey;
  var arguments;
  String? url;
  int? id = 0;

  Future<Map<String, dynamic>> getMovieInfo(int id) async {
    Map<String, dynamic> info = {};

    try {
      var response = await Dio()
          .get("https://api.themoviedb.org/3/movie/${id}?api_key=$apiKey");
      // print ("the response ${response.data["adult"]}");
      info["adult"] = response.data["adult"];
      info["original_title"] = response.data["original_title"];
      info["overview"] = response.data["overview"];
      info["release_date"] = response.data["release_date"];
      // print ("the info is $info");
    } catch (e) {
      print("error $e");
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("No Internet"),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.dependOnInheritedWidgetOfExactType();
                      },
                      child: Text("Retry"),
                    )
                  ],
                ),
              ));
    }
    return info;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("in depenediceis chage");
    arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    url = arguments["imageUrl"];
    id = arguments["id"];
    // print ("the id is $id");
    movieInfo = getMovieInfo(id!);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.black,
        body: FutureBuilder(
          future: movieInfo,
          builder: (ctx, asyncSnapShot) {
            if (asyncSnapShot.connectionState == ConnectionState.done) {
              if (asyncSnapShot.hasData) {
                Map<String, dynamic> data =
                    asyncSnapShot.data as Map<String, dynamic>;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height / 1.7,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: height / 1.7,
                            width: width,
                            child: Image.network(
                              url!,
                            ),
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
                                          "Release year: ${DateTime.parse(data["release_date"]).year.toString()}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 50.0),
                                      child: (data["adult"])
                                          ? Text("18+",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1)
                                          : Text(""),
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
                            icon: const Icon(
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
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)),
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
                                          movieId: id!,
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
                        const CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 30,
                          child: const IconButton(
                            onPressed: null,
                            icon: Icon(
                              Icons.download,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: SizedBox(
                          width: width / 1.2,
                          child: Text(
                            "${data["overview"]}",
                            style: Theme.of(context).textTheme.bodyText1,
                          )),
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
                      Align(
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
                    Align(
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
                  /* TODO MOVE THIS rating to another isolate so we can do it irrespective of user closing the bottombar */
            setState(() {
                    done = false;
                  });

                  //

                  //fetch the current rating for the movie
                  var response = await Dio().get(
                      "https://freetv-7c1f4-default-rtdb.firebaseio.com/ratings/${widget.movieId}.json");
                  int current_rating = response.data;

                  // print ("the current_rating is $current_rating");

                  // increment the ratings by the number of stars given
                  try {
                    await Dio().patch(
                      "https://freetv-7c1f4-default-rtdb.firebaseio.com/ratings.json",
                      data: json.encode(
                          {"${widget.movieId}": ratingLevel + current_rating}),
                    );
                    setState(() {
                      done = true;
                    });
                  } on DioError catch (e) {
                    print("the erorr is $e");
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



import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class LatestMovies extends StatefulWidget {
  const LatestMovies({Key? key}) : super(key: key);

  @override
  State<LatestMovies> createState() => _LatestMoviesState();
}

class _LatestMoviesState extends State<LatestMovies> {
  /*TODO save the images of the movies locally so we dont have to fetch from server everytime */
  /* TODO Hide my API from gitHUb */

  final String apiKey = "b0b4c88b9cc87565d49a0037bcebed00";
  Future<List<String>>? getMoviesPostersFuture;
  List<dynamic> moviesId = []; //store all the movies ID

  Future<List<String>> getMoviesPosters() async {
    List<String> moviesPosterUrl = []; //store the list of movie posters url

    try {
      //get the movies id from firestore realtime db
      var response = await Dio()
          .get("https://freetv-7c1f4-default-rtdb.firebaseio.com/movies.json");
      moviesId.addAll(response.data);
      moviesId.removeAt(0); //remove the first item because it is null
      Dio().close();
      if (moviesId.isNotEmpty) {
        for (int i = 0; i < moviesId.length; i++) {
          var response = await Dio().get(
              "https://api.themoviedb.org/3/movie/${moviesId[i]}/images?api_key=$apiKey");
          moviesPosterUrl.add(
              "http://image.tmdb.org/t/p/w300/${response.data["posters"][0]["file_path"]}");
        }
        Dio().close();
      }
    } catch (e) {
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
    return moviesPosterUrl;
  }

  Future<void> refreshPage() async {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMoviesPostersFuture = getMoviesPosters();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshPage,
      child: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
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
                          Container(
                            height: 150,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (index, ctx) {
                                  return GestureDetector(
                                    onTap: () {
                                      print("Tapped info");
                                      Navigator.of(context)
                                          .pushNamed("/movieinfo");
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                                separatorBuilder: (index, ctx) =>
                                    const SizedBox(
                                      width: 10,
                                    ),
                                itemCount: 10),
                          ),
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
                              future: getMoviesPostersFuture,
                              builder: (ctx, asyncSnapShot) {
                                if (asyncSnapShot.connectionState ==
                                    ConnectionState.done) {
                                  if (asyncSnapShot.hasData) {
                                    List<String> data =
                                        asyncSnapShot.data as List<String>;
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
                                                      "id": moviesId[index],
                                                      "imageUrl": data[index],
                                                    });
                                              },
                                              child: SizedBox(
                                                width: 100,
                                                height: 100,
                                                child:
                                                    Image.network(data[index]),
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
                                separatorBuilder: (index, ctx) =>
                                    const SizedBox(
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
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../widgets/movie_poster_widget.dart';
import '../pages/latest_movies.dart';

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
                    // List<MovieInfo> moviesList = data["MoviesId"];
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

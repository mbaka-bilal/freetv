import 'package:dio/dio.dart';

import '../helpers/apikeys.dart';
import '../helpers/movie_info.dart';

class FetchMovieInfo {
  Future<MovieInfo> getMovieInformation(int id, String apiKey) async {
    try {
      var response = await Dio()
          .get("https://api.themoviedb.org/3/movie/${id}?api_key=$apiKey");

      // print ("the response is ${response.data["release_date"]}");

      return MovieInfo(
          movieId: id,
          movieImageLink: await getImageLink(id),
          movieName: response.data["original_title"],
          year: int.tryParse(
              DateTime.parse(response.data["release_date"]).year.toString())!,
          description: response.data["overview"],
          adult: (response.data["adult"] as bool) ? 0 : 1);
    } on DioError catch (e) {
      if (e.message == "Http status error [404]") {
        print("error fetching the movie information $e");
        return MovieInfo(movieId: id, movieImageLink: "");
      } else {
        print("error fetching the movie information $e");
        return MovieInfo(movieId: id, movieImageLink: "");
      }
    } catch (e) {
      print("error fetching the movie information $e");
      return MovieInfo(movieId: id, movieImageLink: "");
    }
  }

  Future<String> getImageLink(int id) async {
    final String apiKey = myApiKey;
    var response;

    try {
      response = await Dio()
          .get("https://api.themoviedb.org/3/movie/$id/images?api_key=$apiKey");
    } on DioError catch (e) {
      if (e.message == "Http status error [404]") {
        // print ("image does not exist");
        return "";
      }
    } catch (e) {
      print("Error fetching the image link");
    }
    return "http://image.tmdb.org/t/p/w300/${response.data["posters"][0]["file_path"]}";
  }

  Future<String> getMovieName(int id, String apiKey) async {
    // print ("getting movie name");
    String movieName = "";

    try {
      var response = await Dio()
          .get("https://api.themoviedb.org/3/movie/$id?api_key=$apiKey");
      movieName = response.data["original_title"];
    } catch (e) {
      print("error fetching movie information $e");
    }
    return movieName;
  }

  Future<int> getMovieRating(String movieId) async {
    int rating = 0;

    try {
      var response = await Dio().get(
          "https://freetv-7c1f4-default-rtdb.firebaseio.com/ratings/$movieId.json");
      // print ("the resposne is ${response.data}");
      if (response.data == null) {
        return rating;
      } else {
        rating = response.data;
      }
    } on DioError catch (e) {
      print("Error getting movie rating ");
      return rating;
    } catch (e) {
      print("Error getting movie rating${e}");
      return rating;
    }
    return rating;
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
      print("error getting latest movies $e");
      return latestMovies;
    }
    return latestMovies;
  }
}

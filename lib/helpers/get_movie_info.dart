import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../helpers/apikeys.dart';
import '../helpers/movie_info.dart';

class FetchMovieInfo {
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
      print("error $e");
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

  // Future<Map<String, dynamic>> getMovieInfo(int id) async {
  //   Map<String, dynamic> info = {};
  //
  //   try {
  //     var response = await Dio()
  //         .get("https://api.themoviedb.org/3/movie/${id}?api_key=$apiKey");
  //     // print ("the response ${response.data["adult"]}");
  //     info["adult"] = response.data["adult"];
  //     info["original_title"] = response.data["original_title"];
  //     info["overview"] = response.data["overview"];
  //     info["release_date"] = response.data["release_date"];
  //     // print ("the info is $info");
  //   } catch (e) {
  //     print("error $e");
  //   }
  //   return info;
  // }

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
}

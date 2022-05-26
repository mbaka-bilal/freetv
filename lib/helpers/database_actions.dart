import 'package:freetv/helpers/movie_info.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/category_info.dart';

class DatabaseActions {
  Future<bool> movieExistsInDatabase(Database db, int id) async {
    //check if record already exists
    try {
      List<Map> result =
          await db.query("info", where: 'movieId = ?', whereArgs: [id]);
      if (result.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Unable to check if record exist in info table $e");
      return false;
    }
  }

  void addMovieInfoToDatabase(Database db, MovieInfo info) async {
    try {
      await db.insert("info", info.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print("Error adding record to the movie tables info $e");
    }
  }

  Future<List<int>> getLatestMoviesInfo(Database db) async {
    List<int> movieInfo = [];
    List<Map> result = await db.query("info", columns: ["movieId"]);
    for (var element in result) {
      movieInfo.add(element["movieId"]);
    }
    return movieInfo;
  }

  void addCategoryToDatabase(
      Database db, CategoryInfo info, String tableName) async {
    var result =
        await db.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
    print("the list of tables is $result");
    // return;
    // await db.insert(tableName, info.toMap());
  }

  void createCategoryTable(Database db, String tableName) async {
    //create the category table in the category database
    db.execute(
        "CREATE TABLE $tableName ( movieId INTEGER PRIMARY KEY NOT NULL)");
  }
}

class MovieInfo {
  final int movieId;
  final String movieImageLink;
  String movieName;
  int rating;
  int year;
  String description;
  int adult;

  MovieInfo({
    required this.movieId,
    this.movieName = "",
    this.rating = 0,
    this.year = 2020,
    this.description = "",
    this.adult = 1,
    this.movieImageLink = "",
  });

  Map<String, dynamic> toMap() {
    return {
      "movieId": movieId,
      "title": movieName,
      "year": year,
      "description": description,
      "link": movieImageLink,
      "adult": adult
    };
  }
}

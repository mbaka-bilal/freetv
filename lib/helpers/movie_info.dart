class MovieInfo {
  final int movieId;
  final String movieImageLink;
  String movieName;
  int rating;

  MovieInfo({
    required this.movieId,
    this.movieName = "",
    this.rating = 0,
    required this.movieImageLink,
  });
}

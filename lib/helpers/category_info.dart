class CategoryInfo {
  final int movieId;

  CategoryInfo({
    required this.movieId,
  });

  Map<String, dynamic> toMap() {
    return {
      "movieId": movieId,
    };
  }
}

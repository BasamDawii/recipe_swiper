class Recipe {
  final String id;
  final String name;
  final String images;
  final double rating;
  final String totalTime;
  final String directionsUrl;

  Recipe({
    required this.id,
    required this.name,
    required this.images,
    required this.rating,
    required this.totalTime,
    required this.directionsUrl,
  });

  factory Recipe.fromJson(dynamic json) {
    return Recipe(
      id: json['id'] as String,
      name: json['displayName'] as String,
      images: json['images'][0]['hostedLargeUrl'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalTime: json['totalTime'] as String,
      directionsUrl: json['directionsUrl'] as String,
    );
  }

  static List<Recipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toList();
  }

  @override
  String toString() {
    return 'Recipe {id: $id, name: $name, image: $images, rating: $rating, totalTime: $totalTime, directionsUrl: $directionsUrl}';
  }
}

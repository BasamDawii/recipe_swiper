class Recipe {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String totalTime;
  final String instructions;
  final String youtubeUrl;


  Recipe({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.totalTime,
    required this.instructions,
    required this.youtubeUrl,
  });


  factory Recipe.fromJson(dynamic json) {
    return Recipe(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      imageUrl: json['strMealThumb'] as String,
      rating: 4.5,
      totalTime: "30 mins",
      instructions: json['strInstructions'] as String,
      youtubeUrl: json['strYoutube'] as String? ?? '',
    );
  }


  static List<Recipe> recipesFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Recipe.fromJson(data);
    }).toList();
  }


  @override
  String toString() {
    return 'Recipe {id: $id, name: $name, image: $imageUrl, rating: $rating, totalTime: $totalTime, instructions: $instructions, youtubeUrl: $youtubeUrl}';
  }
}


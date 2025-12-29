class Recipe {
  final String id;
  final String title;
  final String image;
  final String category;
  final String instructions;

  Recipe({
    required this.id,
    required this.title,
    required this.image,
    required this.category,
    required this.instructions,
  });

  // Factory constructor to create Recipe from JSON
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['idMeal'] ?? '',
      title: json['strMeal'] ?? '',
      image: json['strMealThumb'] ?? '',
      category: json['strCategory'] ?? '',
      instructions: json['strInstructions'] ?? '',
    );
  }

  // ✅ Convert Recipe to JSON (for SharedPreferences)
  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': title,
      'strMealThumb': image,
      'strCategory': category,
      'strInstructions': instructions,
    };
  }
}

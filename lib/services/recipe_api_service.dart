import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class RecipeApiService {
  static const _baseUrl = "https://www.themealdb.com/api/json/v1/1";

  Future<List<Recipe>> fetchByCategory(String category) async {
    final res = await http.get(
      Uri.parse("$_baseUrl/filter.php?c=$category"),
    );

    final data = json.decode(res.body);
    return (data['meals'] as List)
        .map((e) => Recipe(
      id: e['idMeal'],
      title: e['strMeal'],
      image: e['strMealThumb'],
      category: category,
      instructions: '',
    ))
        .toList();
  }

  Future<Recipe> fetchRecipeDetail(String id) async {
    final res = await http.get(
      Uri.parse("$_baseUrl/lookup.php?i=$id"),
    );

    final data = json.decode(res.body);
    return Recipe.fromJson(data['meals'][0]);
  }

  Future<List<Recipe>> searchRecipe(String query) async {
    final res = await http.get(
      Uri.parse("$_baseUrl/search.php?s=$query"),
    );

    final data = json.decode(res.body);
    if (data['meals'] == null) return [];

    return (data['meals'] as List)
        .map((e) => Recipe.fromJson(e))
        .toList();
  }
}

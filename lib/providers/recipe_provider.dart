import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_api_service.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeApiService _api = RecipeApiService();

  List<Recipe> recipes = [];
  bool isLoading = false;
  String selectedCategory = 'All';

  /// 🟢 Browse all recipes (FR2)
  Future<void> loadAll() async {
    isLoading = true;
    notifyListeners();

    recipes = await _api.fetchByCategory('All');

    isLoading = false;
    notifyListeners();
  }

  /// 🏷 Filter by category (FR2)
  Future<void> loadCategory(String category) async {
    selectedCategory = category;
    isLoading = true;
    notifyListeners();

    recipes = await _api.fetchByCategory(category);

    isLoading = false;
    notifyListeners();
  }

  /// 🔍 Search recipes (FR2)
  Future<void> search(String query) async {
    if (query.isEmpty) {
      await loadCategory(selectedCategory);
      return;
    }

    isLoading = true;
    notifyListeners();

    recipes = await _api.searchRecipe(query);

    isLoading = false;
    notifyListeners();
  }
}

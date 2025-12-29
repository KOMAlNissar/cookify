import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class FavoritesProvider with ChangeNotifier {
  List<Recipe> _favorites = [];

  List<Recipe> get favorites => _favorites;

  FavoritesProvider() {
    loadFavorites();
  }

  // Load favorites from SharedPreferences
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favString = prefs.getString('favorites');
    if (favString != null) {
      final List decoded = jsonDecode(favString);
      _favorites = decoded.map((e) => Recipe.fromJson(e)).toList();
      notifyListeners();
    }
  }

  // Save favorites to SharedPreferences
  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(_favorites.map((e) => e.toJson()).toList());
    await prefs.setString('favorites', encoded);
  }

  bool isFavorite(String id) {
    return _favorites.any((r) => r.id == id);
  }

  void toggleFavorite(Recipe recipe) {
    if (isFavorite(recipe.id)) {
      _favorites.removeWhere((r) => r.id == recipe.id);
    } else {
      _favorites.add(recipe);
    }
    saveFavorites();
    notifyListeners();
  }
}

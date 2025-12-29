import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/recipe.dart';

class FavoritesProvider with ChangeNotifier {
  List<Recipe> favorites = [];

  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  /// 🔹 User-specific key
  String get _favKey => 'favorites_$_uid';

  FavoritesProvider() {
    loadFavorites();
  }

  /// 🔹 Load favorites for CURRENT USER
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_favKey) ?? [];

    favorites = data
        .map((e) => Recipe.fromJson(json.decode(e)))
        .toList();

    notifyListeners();
  }

  /// 🔹 Add / Remove favorite (per user)
  Future<void> toggleFavorite(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();

    final exists = favorites.any((r) => r.id == recipe.id);

    if (exists) {
      favorites.removeWhere((r) => r.id == recipe.id);
    } else {
      favorites.add(recipe);
    }

    await prefs.setStringList(
      _favKey,
      favorites.map((e) => json.encode({
        'idMeal': e.id,
        'strMeal': e.title,
        'strMealThumb': e.image,
        'strCategory': e.category,
        'strInstructions': e.instructions,
      })).toList(),
    );

    notifyListeners();
  }

  /// 🔹 Check if recipe is favorite
  bool isFavorite(String id) {
    return favorites.any((r) => r.id == id);
  }

  /// 🔹 Optional: Clear favorites for current user
  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favKey);
    favorites.clear();
    notifyListeners();
  }
}

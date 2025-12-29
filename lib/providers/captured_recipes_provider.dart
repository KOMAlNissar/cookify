import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class CapturedRecipe {
  final String id;
  final String imagePath;
  final String title;
  final String instructions;

  CapturedRecipe({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.instructions,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'imagePath': imagePath,
    'title': title,
    'instructions': instructions,
  };

  factory CapturedRecipe.fromJson(Map<String, dynamic> json) {
    return CapturedRecipe(
      id: json['id'],
      imagePath: json['imagePath'],
      title: json['title'],
      instructions: json['instructions'],
    );
  }
}

class CapturedRecipesProvider extends ChangeNotifier {
  final List<CapturedRecipe> _recipes = [];

  List<CapturedRecipe> get recipes => _recipes;

  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  String get _storageKey => 'captured_recipes_$_uid';

  CapturedRecipesProvider() {
    loadRecipes();
  }

  Future<void> loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_storageKey) ?? [];

    _recipes
      ..clear()
      ..addAll(data.map((e) => CapturedRecipe.fromJson(json.decode(e))));

    notifyListeners();
  }

  Future<void> addRecipe(
      File imageFile, {
        required String title,
        required String instructions,
      }) async {
    final recipe = CapturedRecipe(
      id: const Uuid().v4(),
      imagePath: imageFile.path,
      title: title,
      instructions: instructions,
    );

    _recipes.add(recipe);
    await _save();
    notifyListeners();
  }

  Future<void> deleteRecipe(String id) async {
    _recipes.removeWhere((recipe) => recipe.id == id);
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _storageKey,
      _recipes.map((e) => json.encode(e.toJson())).toList(),
    );
  }

  Future<void> clearRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    _recipes.clear();
    notifyListeners();
  }
}

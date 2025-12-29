import 'dart:io';
import 'package:flutter/material.dart';
import '../providers/captured_recipes_provider.dart';

class CapturedRecipeDetail extends StatelessWidget {
  final CapturedRecipe recipe;

  const CapturedRecipeDetail({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFE), // ✅ Set background color
      appBar: AppBar(
        title: Text(recipe.title),
        backgroundColor: const Color(0xFF007AA5),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.file(
              File(recipe.imagePath),
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 24),
            Text(
              recipe.title,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              recipe.instructions,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

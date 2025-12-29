import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/captured_recipes_provider.dart';

class ScanPreviewScreen extends StatefulWidget {
  final File imageFile;

  const ScanPreviewScreen({super.key, required this.imageFile});

  @override
  State<ScanPreviewScreen> createState() => _ScanPreviewScreenState();
}

class _ScanPreviewScreenState extends State<ScanPreviewScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFE), // Background color
      appBar: AppBar(
        title: const Text("Add Recipe Details"),
        titleTextStyle: const TextStyle(
          color: Colors.white, // ✅ Set AppBar title text color to white
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: const Color(0xFF007AA5),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.file(
                widget.imageFile,
                height: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 24),

              // Recipe Title
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Recipe Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Recipe Instructions
              TextField(
                controller: instructionsController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Recipe Instructions",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Recipe Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AA5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (titleController.text.isEmpty ||
                        instructionsController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please fill all fields"),
                        ),
                      );
                      return;
                    }

                    // Save recipe to provider
                    context.read<CapturedRecipesProvider>().addRecipe(
                      widget.imageFile,
                      title: titleController.text,
                      instructions: instructionsController.text,
                    );

                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Save Recipe",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

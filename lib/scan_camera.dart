import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/captured_recipes_provider.dart';

class ScanCameraScreen extends StatefulWidget {
  const ScanCameraScreen({super.key});

  @override
  State<ScanCameraScreen> createState() => _ScanCameraScreenState();
}

class _ScanCameraScreenState extends State<ScanCameraScreen> {
  @override
  void initState() {
    super.initState();
    openCamera();
  }

  Future<void> openCamera() async {
    final picker = ImagePicker();
    final XFile? pickedImage =
    await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      final File imageFile = File(pickedImage.path);

      // Navigate to Preview Screen with Continue button
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ScanPreviewScreen(imageFile: imageFile),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

// ----------------------
// ScanPreviewScreen with Recipe Details
// ----------------------
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
      appBar: AppBar(
        title: const Text("Add Recipe Details"),
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

              // Continue Button
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
                            content: Text("Please fill all fields")),
                      );
                      return;
                    }

                    // Save recipe to CapturedRecipesProvider
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

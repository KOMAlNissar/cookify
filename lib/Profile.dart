import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/favorites_provider.dart';
import '../providers/captured_recipes_provider.dart';
import '../providers/profile_provider.dart';

import 'Home.dart';
import 'Notification.dart';
import 'RecipeDetail.dart';
import 'scan_camera.dart';
import 'Search.dart';
import 'captured_recipe_detail.dart';
import 'OnboardingScreen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  int currentIndex = 4;
  bool showLiked = true;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  void onNavTap(int index) {
    if (index == currentIndex) return;
    setState(() => currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Home()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const Search()));
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ScanCameraScreen()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
        break;
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final likedRecipes = context.watch<FavoritesProvider>().favorites;
    final capturedRecipes = context.watch<CapturedRecipesProvider>().recipes;
    final profile = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFE),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 32),

              /// PROFILE IMAGE
              CircleAvatar(
                radius: 55,
                backgroundColor: const Color(0xFF007AA5),
                child: CircleAvatar(
                  radius: 52,
                  backgroundImage: (_selectedImage != null)
                      ? FileImage(_selectedImage!)
                      : (profile.image.startsWith("http")
                      ? NetworkImage(profile.image)
                      : (File(profile.image).existsSync()
                      ? FileImage(File(profile.image))
                      : const AssetImage('assets/images/user.png'))) as ImageProvider,
                ),
              ),

              const SizedBox(height: 12),

              /// NAME
              Text(
                profile.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D5480),
                ),
              ),

              const SizedBox(height: 8),

              /// EDIT PROFILE
              TextButton.icon(
                onPressed: _showEditProfileDialog,
                icon: const Icon(Icons.edit, size: 18),
                label: const Text("Edit Profile"),
              ),

              /// LOGOUT BUTTON
              TextButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                        (route) => false,
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.red),
                ),
              ),

              const SizedBox(height: 24),
              Container(color: const Color(0xFFF4F5F7), height: 8),
              const SizedBox(height: 24),

              /// TABS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    tabButton("Liked Recipes", showLiked, () => setState(() => showLiked = true)),
                    tabButton("My Recipes", !showLiked, () => setState(() => showLiked = false)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// TAB CONTENT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: showLiked
                    ? likedRecipes.isEmpty
                    ? const Center(child: Text("No liked recipes yet."))
                    : recipeGrid(likedRecipes, false)
                    : capturedRecipes.isEmpty
                    ? const Center(child: Text("No captured dishes yet."))
                    : recipeGrid(capturedRecipes, true),
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onNavTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF007AA5),
        unselectedItemColor: const Color(0xFF9FA5C0),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFF007AA5),
              child: Icon(Icons.camera_alt, color: Colors.white),
            ),
            label: "Camera",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notification"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  /// EDIT PROFILE DIALOG
  void _showEditProfileDialog() {
    final profile = context.read<ProfileProvider>();
    final nameController = TextEditingController(text: profile.name);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Edit Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo),
              label: const Text("Pick Image"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                final imagePath = _selectedImage != null ? _selectedImage!.path : profile.image;
                profile.updateProfile(nameController.text, imagePath);
                Navigator.pop(ctx);
              },
              child: const Text("Save")),
        ],
      ),
    );
  }

  /// RECIPE GRID (VERTICAL) with delete fix
  Widget recipeGrid(List items, bool isFile) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (_, index) {
        final item = items[index];
        return GestureDetector(
          onTap: isFile
              ? () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => CapturedRecipeDetail(recipe: item)))
              : () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => RecipeDetail(recipeId: item.id))),
          onLongPress: isFile
              ? () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Delete Recipe"),
                content: const Text("Are you sure you want to delete this recipe?"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text("Cancel")),
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text("Delete")),
                ],
              ),
            );
            if (confirm == true) {
              await context.read<CapturedRecipesProvider>().deleteRecipe(item.id);
            }
          }
              : null,
          child: recipeCard(
            image: isFile ? item.imagePath : item.image,
            title: item.title,
            isFile: isFile,
          ),
        );
      },
    );
  }

  /// TAB BUTTON
  Widget tabButton(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: active ? const Color(0xFF007AA5) : const Color(0xFF9FA5C0),
              fontWeight: FontWeight.bold,
            ),
          ),
          if (active)
            Container(
              margin: const EdgeInsets.only(top: 6),
              height: 3,
              width: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF007AA5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
        ],
      ),
    );
  }

  /// RECIPE CARD
  Widget recipeCard({required String image, required String title, bool isFile = false}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              image: DecorationImage(
                image: isFile ? FileImage(File(image)) : NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

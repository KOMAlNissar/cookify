import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import 'RecipeDetail.dart';
import 'Notification.dart';
import 'Profile.dart';
import 'scan_camera.dart';
import 'Home.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController searchController = TextEditingController();
  final List<String> categories = ['All', 'Breakfast', 'Lunch', 'Dinner'];
  int currentIndex = 1;

  @override
  void initState() {
    super.initState();
    context.read<RecipeProvider>().loadAll();
  }

  void onNavTap(int index) {
    if (index == currentIndex) return;

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ScanCameraScreen(),
        ),
      );
      return;
    }

    setState(() => currentIndex = index);

    if (index == 1) return;

    if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const NotificationScreen(),
        ),
      );
      return;
    }

    if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Profile(),
        ),
      );
      return;
    }

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Home(),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RecipeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFE),

      /// 🔹 HEADER
      appBar: AppBar(
        backgroundColor: const Color(0xFF007AA5),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Search Recipes',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Column(
        children: [
          /// 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search recipe...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                provider.search(value.trim());
              },
            ),
          ),

          /// 🏷 CATEGORY FILTER
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (_, index) {
                final category = categories[index];
                final isSelected = provider.selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      searchController.clear();
                      context.read<RecipeProvider>().loadCategory(category);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF007AA5)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF007AA5)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color:
                          isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          /// 📋 RECIPE LIST
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.recipes.isEmpty
                ? const Center(child: Text('No recipes found'))
                : ListView.builder(
              itemCount: provider.recipes.length,
              itemBuilder: (_, index) {
                final recipe = provider.recipes[index];

                return Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: Image.network(
                      recipe.image,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(recipe.title),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              RecipeDetail(recipeId: recipe.id),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

      /// 🔹 BOTTOM NAV BAR
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 20,
              offset: Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onNavTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF007AA5),
          unselectedItemColor: const Color(0xFF9FA5C0),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFF007AA5),
                child: Icon(Icons.camera_alt, color: Colors.white),
              ),
              label: "Camera",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: "Notification",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}

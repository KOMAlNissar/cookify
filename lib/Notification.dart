import 'package:flutter/material.dart';
import 'Home.dart';
import 'Profile.dart';
import 'scan_camera.dart';
import 'Search.dart';
import 'services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationState createState() => NotificationState();
}

class NotificationState extends State<NotificationScreen> {
  int currentIndex = 3;
  bool showDailyRecipe = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        showDailyRecipe = true;
      });

      NotificationService.showDailyRecipeNotification(
        recipeName: "Spicy Chicken Biryani",
      );
    });
  }

  void onNavTap(int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
      return;
    }

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Search()),
      );
      return;
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ScanCameraScreen()),
      );
      return;
    }

    if (index == 3) return;

    if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Profile()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              if (showDailyRecipe)
                notificationItem(
                  profileUrl:
                  "https://cdn-icons-png.flaticon.com/512/1830/1830839.png",
                  title: "Daily Recipe",
                  subtitle:
                  "Spicy Chicken Biryani is ready for you 🍽️",
                ),




            ],
          ),
        ),
      ),

      /// 🔹 BOTTOM NAV BAR (NO PINK – SAFE FIX)
      bottomNavigationBar: Container(
        color: Colors.white, // ✅ hard white
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onNavTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white, // ✅ force white
            elevation: 0, // ✅ removes tint/shadow
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
                  child:
                   Icon(Icons.camera_alt, color: Colors.white),
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
      ),
    );
  }

  static Widget notificationItem({
    required String profileUrl,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13, left: 15, right: 28),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(profileUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF3D5480),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF9FA5C0),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

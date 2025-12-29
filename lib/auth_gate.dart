import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'OnboardingScreen.dart';
import 'Home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const OnboardingScreen();
        }

        return const Home(); // Providers are already available from main.dart
      },
    );
  }
}

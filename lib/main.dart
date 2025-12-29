import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'OnboardingScreen.dart';
import 'Home.dart';

// Providers
import 'providers/recipe_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/captured_recipes_provider.dart';
import 'providers/profile_provider.dart';

// Notifications
import 'services/notification_service.dart';
import 'auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.init();
  NotificationService.listenForPush();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()..loadFavorites()),
        ChangeNotifierProvider(create: (_) => CapturedRecipesProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      home: const AuthGate(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/theme_controller.dart';
import 'controllers/profile_controller.dart'; // Import ProfileController
import 'views/screens/OnboardingScreen1.dart';
import 'views/screens/OnboardingScreen2.dart';
import 'views/screens/Login.dart';
import 'views/screens/Register.dart';
import 'views/screens/Home.dart';
import 'views/screens/Profile.dart'; // Import ProfileScreen

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileController()), // Add ProfileController
        ChangeNotifierProvider(create: (_) => ThemeController()), // Add ThemeController
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter App',
          theme: themeController.isDarkMode ? ThemeData.dark() : ThemeData.light(), // Dynamic theme
          initialRoute: '/onboarding1', // Set initial route
          routes: {
            '/onboarding1': (context) => const OnboardingScreen1(),
            '/onboarding2': (context) => const OnboardingScreen2(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomeScreen(),
            '/profile': (context) => const ProfileScreen(), // Add ProfileScreen route
          },
        );
      },
    );
  }
}

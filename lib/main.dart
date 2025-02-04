import 'package:flutter/material.dart';
import 'package:mad/views/screens/cart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/theme_controller.dart';
import 'controllers/profile_controller.dart'; // Import ProfileController
import 'views/screens/OnboardingScreen1.dart';
import 'views/screens/OnboardingScreen2.dart';
import 'views/screens/Login.dart';
import 'views/screens/Register.dart';
import 'views/screens/Home.dart';
import 'views/screens/Profile.dart'; // Import ProfileScreen
import 'views/screens/Store.dart'; // Import StoreScreen
import 'views/components/bottomNav.dart';
import 'views/screens/wishlist.dart'; // Import MainScreen
import 'views/screens/cart.dart';

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

  Future<String> _getInitialRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
    String? token = prefs.getString('token');

    if (isFirstRun) {
      await prefs.setBool('isFirstRun', false);
      return '/onboarding1';
    } else if (token != null) {
      return '/main';
    } else {
      return '/login';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return Consumer<ThemeController>(
            builder: (context, themeController, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter App',
                theme: themeController.isDarkMode ? ThemeData.dark() : ThemeData.light(), // Dynamic theme
                initialRoute: snapshot.data,
                routes: {
                  '/onboarding1': (context) => const OnboardingScreen1(),
                  '/onboarding2': (context) => const OnboardingScreen2(),
                  '/login': (context) => const LoginScreen(),
                  '/register': (context) => const RegisterScreen(),
                  '/home': (context) => const HomeScreen(), // Wrap HomeScreen with MainScreen
                  '/profile': (context) => const ProfileScreen(), // Wrap ProfileScreen with MainScreen
                  '/store': (context) => const StoreScreen(), // Wrap StoreScreen with MainScreen
                  '/wishlist': (context) => const WishlistScreen(), // Wrap WishlistScreen with MainScreen
                  '/main': (context) => const MainScreen(), // Add MainScreen route
                  '/cart': (context) => CartScreen(),
                },
              );
            },
          );
        }
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:mad/views/screens/cart.dart';
import 'package:mad/views/screens/checkout.dart';
import 'package:provider/provider.dart';
import 'controllers/theme_controller.dart';
import 'controllers/profile_controller.dart';
import 'views/screens/OnboardingScreen1.dart';
import 'views/screens/OnboardingScreen2.dart';
import 'views/screens/Login.dart';
import 'views/screens/Register.dart';
import 'views/screens/Home.dart';
import 'views/screens/Profile.dart';
import 'views/screens/Store.dart';
import 'views/screens/wishlist.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light, // Use themeMode for dynamic switching
      initialRoute: '/onboarding1',
      routes: {
        '/onboarding1': (context) => const OnboardingScreen1(),
        '/onboarding2': (context) => const OnboardingScreen2(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/store': (context) => const StoreScreen(),
        '/wishlist': (context) => const WishlistScreen(),
        '/cart': (context) => CartScreen(),
        '/checkout': (context) => CheckoutScreen(total: 0), // Provide the required 'total' parameter
      },
    );
  }
}
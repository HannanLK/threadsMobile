import 'package:flutter/material.dart';
import 'package:mad/views/screens/cart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/theme_controller.dart';
import 'controllers/profile_controller.dart';
import 'views/screens/OnboardingScreen1.dart';
import 'views/screens/OnboardingScreen2.dart';
import 'views/screens/Login.dart';
import 'views/screens/Register.dart';
import 'views/screens/Home.dart';
import 'views/screens/Profile.dart';
import 'views/screens/Store.dart';
import 'views/components/bottomNav.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? initialRoute;

  @override
  void initState() {
    super.initState();
    _determineInitialRoute();
  }

  // Check login status and determine initial route
  Future<void> _determineInitialRoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
    String? token = prefs.getString('auth_token');

    if (isFirstRun) {
      await prefs.setBool('isFirstRun', false);
      setState(() => initialRoute = '/onboarding1');
    } else if (token != null) {
      setState(() => initialRoute = '/home');
    } else {
      setState(() => initialRoute = '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (initialRoute == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter App',
          theme: themeController.isDarkMode ? ThemeData.dark() : ThemeData.light(),
          initialRoute: initialRoute,
          routes: {
            '/onboarding1': (context) => const OnboardingScreen1(),
            '/onboarding2': (context) => const OnboardingScreen2(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomeScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/store': (context) => const StoreScreen(),
            '/wishlist': (context) => const WishlistScreen(),
            '/main': (context) => const MainScreen(),
            '/cart': (context) => CartScreen(),
          },
        );
      },
    );
  }
}

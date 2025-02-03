import 'package:flutter/material.dart';
import 'views/screens/OnboardingScreen1.dart';
import 'views/screens/OnboardingScreen2.dart';
import 'views/screens/Login.dart';
import 'views/screens/Register.dart';
import 'views/screens/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/onboarding1', // First screen to show
      routes: {
        '/onboarding1': (context) => const OnboardingScreen1(),
        '/onboarding2': (context) => const OnboardingScreen2(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart'; // Import HomeScreen
import 'Register.dart'; // Import RegisterScreen
import '../../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  Future<void> login() async {
    try {
      final response = await apiService.login(
        emailController.text,
        passwordController.text,
      );

      // Debug: Print the API response
      print('API Response: $response');

      // Check if the response contains a token
      if (response['token'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response['token']);

        // Debug: Print the token
        print('Token saved: ${response['token']}');

        // Navigate to HomeScreen using MaterialPageRoute
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Show error message if token is not present
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Login Failed')),
        );
      }
    } catch (e) {
      // Debug: Print any exceptions
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to RegisterScreen using MaterialPageRoute
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              child: const Text('Not registered? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}
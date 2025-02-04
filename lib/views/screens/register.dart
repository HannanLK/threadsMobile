import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart'; // Import HomeScreen
import '../../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController retypePasswordController = TextEditingController();
  final ApiService apiService = ApiService();

  Future<void> register() async {
    try {
      // Check if passwords match
      if (passwordController.text != retypePasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      // Call the API to register the user
      final response = await apiService.register(
        nameController.text,
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
      } else if (response['message'] == 'Email already registered') {
        // Handle "already registered" error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email is already registered')),
        );
      } else {
        // Handle other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Registration Failed')),
        );
      }
    } catch (e) {
      // Debug: Print any exceptions
      print('Error during registration: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: retypePasswordController,
              decoration: const InputDecoration(labelText: 'Retype Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
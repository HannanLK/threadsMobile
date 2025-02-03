import 'package:flutter/material.dart';

class ArrowButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ArrowButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Align(
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(), backgroundColor: Colors.black,
            padding: const EdgeInsets.all(20), // Background color
          ),
          child: const Icon(Icons.arrow_forward, color: Colors.white),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int index) onTap; // Accept the onTap function as a parameter

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap, // Make sure onTap is passed as required
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap, // Pass the onTap handler directly
      backgroundColor: isDarkTheme ? Colors.black : Colors.white,
      selectedItemColor: Colors.grey, // Grey color for the active item
      unselectedItemColor: isDarkTheme ? Colors.white70 : Colors.black54,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Store',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Wishlist',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          ///title: const Text('Store'),
          backgroundColor: Colors.indigo, // Dark blue color for the app bar
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Mens'),
              Tab(text: 'Womens'),
              Tab(text: 'Accessories'),
            ],
            indicatorColor: Colors.white, // Indicator color for the active tab
            labelColor: Colors.white, // Text color for the active tab
            unselectedLabelColor: Colors.white70, // Text color for inactive tabs
          ),
        ),
        body: const TabBarView(
          children: [
            // Content for Mens tab
            Center(
              child: Text(
                'Mens Section',
                style: TextStyle(fontSize: 24),
              ),
            ),
            // Content for Womens tab
            Center(
              child: Text(
                'Womens Section',
                style: TextStyle(fontSize: 24),
              ),
            ),
            // Content for Accessories tab
            Center(
              child: Text(
                'Accessories Section',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
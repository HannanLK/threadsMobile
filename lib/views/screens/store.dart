import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import '../components/product_details.dart'; // Import the ProductDetailsScreen
import 'cart.dart'; // Import the CartScreen
import 'package:mad/views/components/bottomNav.dart';

class StoreScreen extends StatelessWidget {
  final int? initialTab;

  const StoreScreen({super.key, this.initialTab});

  // Fetch products from the API
  Future<List<dynamic>> fetchProducts(String category) async {
    final response = await http.get(Uri.parse('https://threadstore.shop/api/products/$category'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

    void _onNavTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home'); // Replace with actual route name
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/store'); // Stay on the store page
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/wishlist'); // Replace with actual route name
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile'); // Replace with actual route name
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: initialTab ?? 0, // Set the initial tab index
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text('Store'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Mens'),
              Tab(text: 'Womens'),
              Tab(text: 'Accessories'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Mens Tab
            FutureBuilder<List<dynamic>>(
              future: fetchProducts('men'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 products per row
                      childAspectRatio: 0.8, // Adjust aspect ratio
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var product = snapshot.data![index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
            // Womens Tab
            FutureBuilder<List<dynamic>>(
              future: fetchProducts('women'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var product = snapshot.data![index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
            // Accessories Tab
            FutureBuilder<List<dynamic>>(
              future: fetchProducts('accessory'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var product = snapshot.data![index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
        
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  CartScreen(),
              ),
            );
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.shopping_cart, color: Colors.white),
        ),
        bottomNavigationBar: BottomNav(
          currentIndex: 1,
          onTap: (index) => _onNavTapped(context, index),
        ),
      ),
    );
  }
}

// ProductCard Widget
class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: product['images'][0],
              fit: BoxFit.cover,
              height: 180, // Increased height
              width: double.infinity,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.error, size: 40),
            ),
          ),
          // Product Details with reduced padding
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  product['category'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '\$${product['price'].toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                Text(
                  product['stock'] > 0 ? '${product['stock']} in Stock' : 'Out of Stock',
                  style: TextStyle(
                    fontSize: 14,
                    color: product['stock'] > 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

}
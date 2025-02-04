import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mad/views/screens/productDetails.dart';
import '../components/product_card.dart'; // Import the ProductCard component

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  Future<List<dynamic>> fetchProducts(String category) async {
    final response = await http.get(Uri.parse('https://threadstore.shop/api/products/$category'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Mens'),
              Tab(text: 'Womens'),
              Tab(text: 'Accessories'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
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
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var product = snapshot.data![index];
                      return ProductCard(
                        name: product['name'],
                        category: product['category'],
                        price: product['price'].toDouble(),
                        imageUrl: product['images'][0],
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
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var product = snapshot.data![index];
                      return ProductCard(
                        name: product['name'],
                        category: product['category'],
                        price: product['price'].toDouble(),
                        imageUrl: product['images'][0],
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
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var product = snapshot.data![index];
                      return ProductCard(
                        name: product['name'],
                        category: product['category'],
                        price: product['price'].toDouble(),
                        imageUrl: product['images'][0],
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
      ),
    );
  }
}
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'productDetails.dart'; // Import the ProductDetailsScreen

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Map<String, dynamic>> wishlist = [];

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  // Method to load wishlist from SharedPreferences
  void _loadWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> wishlistString = prefs.getStringList('wishlist') ?? [];
    setState(() {
      wishlist = wishlistString.map((item) => jsonDecode(item) as Map<String, dynamic>).toList();
    });
  }

  // Method to remove item from wishlist
  void _removeFromWishlist(Map<String, dynamic> product) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> wishlistString = prefs.getStringList('wishlist') ?? [];
    wishlistString.remove(jsonEncode(product));
    await prefs.setStringList('wishlist', wishlistString);
    setState(() {
      wishlist.remove(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from wishlist')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: wishlist.isEmpty
          ? const Center(
              child: Text(
                'Your wishlist is empty',
                style: TextStyle(fontSize: 24),
              ),
            )
          : ListView.builder(
              itemCount: wishlist.length,
              itemBuilder: (context, index) {
                final product = wishlist[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: product['images'][0],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(product: product),
                        ),
                      );
                    },
                    child: Text(product['name']),
                  ),
                  subtitle: Text('\$${product['price'].toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeFromWishlist(product),
                  ),
                );
              },
            ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mad/views/components/bottomNav.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CartScreen extends StatefulWidget {

  static List<Map<String, dynamic>> cartItems = [];

  static Future<void> addToCart({
    required String id,
    required String name,
    required double price,
    required String color,
    required String size,
    required String image,
    required int quantity,
  }) async {
    final token = await getToken(); // Fetch the token dynamically

    if (token == null) {
      throw Exception('User is not logged in');
    }

    final response = await http.post(
      Uri.parse('https://threadstore.shop/api/cart/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'product_id': id,
        'quantity': quantity,
        'size': size,
        'color': color,
      }),
    );

    if (response.statusCode == 200) {
      cartItems.add({
        'id': id,
        'name': name,
        'price': price,
        'color': color,
        'size': size,
        'image': image,
        'quantity': quantity,
      });
    } else {
      throw Exception('Failed to add product to cart');
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<List<Map<String, dynamic>>> fetchCartItems() async {
    final token = await getToken(); // Fetch the token dynamically

    if (token == null) {
      throw Exception('User is not logged in');
    }

    final response = await http.get(
      Uri.parse('https://threadstore.shop/api/cart'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['items']);
    } else {
      throw Exception('Failed to fetch cart items');
    }
  }

  static Future<void> removeFromCart(String id, BuildContext context) async {
    final token = await getToken(); // Fetch the token dynamically

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User is not logged in')),
      );
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('https://threadstore.shop/api/cart/remove/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        cartItems.removeWhere((item) => item['id'] == id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item removed successfully.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to remove item. Please try again later.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove item. Please try again later.')),
      );
    }
  }

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCartItems();
  }

  Future<void> _fetchCartItems() async {
    try {
      final items = await CartScreen.fetchCartItems();
      setState(() {
        CartScreen.cartItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch cart items: $e')),
      );
    }
  }

  double getTotalPrice() {
    return CartScreen.cartItems.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  void removeItem(BuildContext context, int index) async {
    final item = CartScreen.cartItems[index];

    try {
      await CartScreen.removeFromCart(item['id'], context);
      setState(() {
        CartScreen.cartItems.removeAt(index);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove item from cart: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: CartScreen.cartItems.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Your cart is empty'),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Continue Shopping'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: CartScreen.cartItems.length,
                          itemBuilder: (context, index) {
                            final item = CartScreen.cartItems[index];
                            return ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: item['image'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(item['name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Size: ${item['size']}, Color: ${item['color']}'),
                                  Text('Quantity: ${item['quantity']}'),
                                  Text('Price: \$${(item['price'] * item['quantity']).toStringAsFixed(2)}'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => removeItem(context, index),
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Total: \$${getTotalPrice().toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Implement checkout functionality
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomNav(
              currentIndex: 1, // Store tab is active
              onTap: (index) {
                // Handle navigation
                switch (index) {
                  case 0:
                    Navigator.pushNamed(context, '/home');
                    break;
                  case 1:
                    Navigator.pushNamed(context, '/store');
                    break;
                  case 2:
                    Navigator.pushNamed(context, '/wishlist');
                    break;
                  case 3:
                    Navigator.pushNamed(context, '/profile');
                    break;
                }
              },
            ),
    );
  }
}
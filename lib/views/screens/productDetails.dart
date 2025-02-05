import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'cart.dart'; // Import the CartScreen

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  // ignore: library_private_types_in_public_api
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int selectedQuantity = 1;
  String? selectedSize;
  String? selectedColor;
  bool isWishlisted = false;

  @override
  void initState() {
    super.initState();
    _checkWishlistStatus();
  }

  // Helper method to convert color string to Color object
  Color _getColorFromString(String color) {
    switch (color.toLowerCase()) {
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow;
      case 'pink':
        return Colors.pink;
      case 'white':
        return Colors.white;
      default:
        return Colors.black;
    }
  }

  // Method to add the product to the cart
  void addToCart() async {
    if (selectedSize == null || selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select size and color')),
      );
      return;
    }

    if (selectedQuantity > widget.product['stock']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quantity exceeds available stock')),
      );
      return;
    }

    try {
      await CartScreen.addToCart(
        id: widget.product['id'].toString(),
        name: widget.product['name'],
        price: widget.product['price'],
        color: selectedColor!,
        size: selectedSize!,
        image: widget.product['images'][0],
        quantity: selectedQuantity,
      );

      // Fetch updated cart items from the backend
      final items = await CartScreen.fetchCartItems();
      setState(() {
        CartScreen.cartItems = items;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added to cart')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product to cart: $e')),
      );
    }
  }

  // Method to check if the product is in the wishlist
  void _checkWishlistStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> wishlist = prefs.getStringList('wishlist') ?? [];
    setState(() {
      isWishlisted = wishlist.contains(jsonEncode(widget.product));
    });
  }

  // Method to toggle wishlist status
  void _toggleWishlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> wishlist = prefs.getStringList('wishlist') ?? [];

    if (isWishlisted) {
      wishlist.remove(jsonEncode(widget.product));
    } else {
      wishlist.add(jsonEncode(widget.product));
    }

    await prefs.setStringList('wishlist', wishlist);
    setState(() {
      isWishlisted = !isWishlisted;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isWishlisted ? 'Added to wishlist' : 'Removed from wishlist')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product['name']),
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite_outlined : Icons.favorite_border_outlined,
              color: isWishlisted ? Colors.red : Colors.white,
            ),
            onPressed: _toggleWishlist,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primary Image
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: CachedNetworkImage(
                      imageUrl: widget.product['images'][0],
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: widget.product['images'][0],
                fit: BoxFit.cover,
                height: 400,
                width: double.infinity,
              ),
            ),
            // Other Images
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.product['images']?.length ?? 0,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: CachedNetworkImage(
                            imageUrl: widget.product['images'][index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.product['images'][index],
                        fit: BoxFit.cover,
                        width: 100,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Product Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.product['price'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Category: ${widget.product['category']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.product['description'],
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  // Sizes
                  Text(
                    'Sizes:',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children: (widget.product['sizes'] as List<dynamic>?)
                            ?.map<Widget>((size) {
                          return ChoiceChip(
                            label: Text(size),
                            selected: selectedSize == size,
                            onSelected: (selected) {
                              setState(() {
                                selectedSize = size;
                              });
                            },
                          );
                        }).toList() ??
                        [],
                  ),
                  const SizedBox(height: 16),
                  // Colors
                  Text(
                    'Colors:',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children: (widget.product['colors'] as List<dynamic>?)
                            ?.map<Widget>((color) {
                          return ChoiceChip(
                            label: Text(color),
                            selected: selectedColor == color,
                            onSelected: (selected) {
                              setState(() {
                                selectedColor = color;
                              });
                            },
                            backgroundColor: _getColorFromString(color),
                          );
                        }).toList() ??
                        [],
                  ),
                  const SizedBox(height: 16),
                  // Quantity Selector
                  Row(
                    children: [
                      const Text('Quantity:'),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (selectedQuantity > 1) {
                              selectedQuantity--;
                            }
                          });
                        },
                      ),
                      Text(selectedQuantity.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            if (selectedQuantity < widget.product['stock']) {
                              selectedQuantity++;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Add to Cart Button
                  ElevatedButton(
                    onPressed: addToCart,
                    child: const Text('Add to Cart'),
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
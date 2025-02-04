import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cart.dart'; // Import the CartScreen

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int selectedQuantity = 1;
  String? selectedSize;
  String? selectedColor;

  void addToCart() {
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

    // Add product to cart
    CartScreen.addToCart(
      name: widget.product['name'],
      price: widget.product['price'],
      color: selectedColor!,
      size: selectedSize!,
      image: widget.product['images'][0],
      quantity: selectedQuantity,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Primary Image
            CachedNetworkImage(
              imageUrl: widget.product['images'][0],
              fit: BoxFit.cover,
              height: 400,
              width: double.infinity,
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
                    children: widget.product['sizes'].map<Widget>((size) {
                      return ChoiceChip(
                        label: Text(size),
                        selected: selectedSize == size,
                        onSelected: (selected) {
                          setState(() {
                            selectedSize = size;
                          });
                        },
                      );
                    }).toList(),
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
                    children: widget.product['colors'].map<Widget>((color) {
                      return ChoiceChip(
                        label: Text(color),
                        selected: selectedColor == color,
                        onSelected: (selected) {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                      );
                    }).toList(),
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
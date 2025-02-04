import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsScreen({super.key, required this.product});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
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
                      imageUrl: product['images'][0],
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: product['images'][0],
                fit: BoxFit.cover,
                height: 400, // Increased height
                width: double.infinity,
              ),
            ),
            // Other Images
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: product['images'].length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          child: CachedNetworkImage(
                            imageUrl: product['images'][index],
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: product['images'][index],
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
                    product['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product['price'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Category: ${product['category']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product['description'],
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
                    children: product['sizes'].map<Widget>((size) {
                      return OutlinedButton(
                        onPressed: () {
                          // Handle size selection
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          size,
                          style: const TextStyle(color: Colors.black),
                        ),
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
                    children: product['colors'].map<Widget>((color) {
                      return CircleAvatar(
                        backgroundColor: _getColorFromString(color),
                        radius: 16,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Add to Cart Button
                  ElevatedButton(
                    onPressed: () {
                      // Add to cart logic
                    },
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
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // For efficient image loading

class ProductCard extends StatelessWidget {
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final int stock;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.stock,
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
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                height: 200, // Increased height
                width: double.infinity,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            // Product Details
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stock > 0 ? '$stock in Stock' : 'Out of Stock',
                    style: TextStyle(
                      fontSize: 14,
                      color: stock > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            // Add to Cart Icon
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Add to cart logic
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
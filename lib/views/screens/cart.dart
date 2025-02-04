import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  static List<Map<String, dynamic>> cartItems = [];

  const CartScreen({super.key});

  static void addToCart({
    required String name,
    required double price,
    required String color,
    required String size,
    required String image,
    required int quantity,
  }) {
    cartItems.add({
      'name': name,
      'price': price,
      'color': color,
      'size': size,
      'image': image,
      'quantity': quantity,
    });
  }

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double getTotalPrice() {
    return CartScreen.cartItems.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  void updateQuantity(int index, int change) {
    setState(() {
      CartScreen.cartItems[index]['quantity'] += change;
      if (CartScreen.cartItems[index]['quantity'] < 1) {
        CartScreen.cartItems[index]['quantity'] = 1;
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      CartScreen.cartItems.removeAt(index);
    });
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
      body: Column(
        children: [
          Expanded(
            child: CartScreen.cartItems.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to the store
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text(
                      'Let\'s add products',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: CartScreen.cartItems.length,
              itemBuilder: (context, index) {
                final item = CartScreen.cartItems[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item['image'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      item['name'],
                      style:
                      const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Color: ${item['color']}'),
                        Text('Size: ${item['size']}'),
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove,
                                  color: Colors.black),
                              onPressed: () =>
                                  updateQuantity(index, -1),
                            ),
                            Text(item['quantity'].toString()),
                            IconButton(
                              icon: const Icon(Icons.add,
                                  color: Colors.black),
                              onPressed: () =>
                                  updateQuantity(index, 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                    onLongPress: () => removeItem(index),
                  ),
                );
              },
            ),
          ),
          if (CartScreen.cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: \$${getTotalPrice().toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Proceeding to Checkout')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
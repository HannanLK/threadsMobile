import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/product_card.dart'; // Import the ProductCard widget
import 'store.dart' as store; // Import the StoreScreen with alias
import 'wishlist.dart'; // Import the WishlistScreen
import 'cart.dart'; // Import the CartScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerIndex = 0;
  final List<String> banners = [
    'assets/images/Banner/banner1.png',
    'assets/images/Banner/banner2.png',
    'assets/images/Banner/banner3.png',
  ];

  final List<Map<String, dynamic>> categories = [
    {'icon': Icons.man, 'label': 'Mens', 'tab': 0},
    {'icon': Icons.coffee_rounded, 'label': 'Women', 'tab': 1},
    {'icon': Icons.watch_rounded, 'label': 'Accessories', 'tab': 2},
    {'icon': Icons.checkroom, 'label': 'Featured', 'tab': null},
    {'icon': Icons.bookmark_rounded, 'label': 'Favourite', 'tab': 1},
    {'icon': Icons.account_balance_wallet_rounded, 'label': 'Wallets', 'tab': 2},
    {'icon': Icons.sports_basketball_rounded, 'label': 'Sports Wear', 'tab': 0},
    {'icon': Icons.bookmark, 'label': 'Saved', 'tab': null},
    {'icon': Icons.add_a_photo_rounded, 'label': 'Best for you', 'tab': 1},
  ];

  Future<List<dynamic>> fetchProducts(String filter) async {
    final response = await http.get(Uri.parse('https://threadstore.shop/api/products'));

    if (response.statusCode == 200) {
      List<dynamic> allProducts = json.decode(response.body);

      if (filter == 'latest') {
        return allProducts.take(6).toList(); // Get first 6 products
      } else if (filter == 'featured') {
        return allProducts.where((product) => product['is_featured'] == true).toList();
      }

      return allProducts;
    } else {
      throw Exception('Failed to load products');
    }
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Good day for shopping,',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          const Text(
            'Hannan Munas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search in Store',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Popular Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (categories[index]['label'] == 'Saved') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WishlistScreen()),
                      );
                    } else if (categories[index]['label'] == 'Featured') {
                      // Scroll to the Featured section in Home Page
                      // Implement the logic to scroll to the Featured section
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => store.StoreScreen(initialTab: categories[index]['tab']),
                        ),
                      );
                    }
                  },
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Icon(categories[index]['icon'], size: 30, color: Colors.black),
                      ),
                      Text(
                        categories[index]['label'],
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerSection() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            itemCount: banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(banners[index], fit: BoxFit.cover),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => Container(
              margin: const EdgeInsets.all(4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentBannerIndex == index ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductSection(String title, Future<List<dynamic>> productsFuture) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        FutureBuilder<List<dynamic>>(
          future: productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var product = snapshot.data![index];
                    return ProductCard(product: product);
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Wrap the entire body in a SingleChildScrollView
        child: Column(
          children: [
            _buildAppBar(),
            _buildCategorySection(),
            _buildBannerSection(),
            _buildProductSection('New Arrivals', fetchProducts('latest')),
            _buildProductSection('Is Featured', fetchProducts('featured')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen()));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.shopping_cart, color: Colors.white),
      ),
    );
  }
}

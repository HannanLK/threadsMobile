import 'package:flutter/material.dart';

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
    {'icon': Icons.watch, 'label': 'Watch'},
    {'icon': Icons.change_history, 'label': 'Limited'},
    {'icon': Icons.card_giftcard, 'label': 'Gifts'},
    {'icon': Icons.checkroom, 'label': 'Clothes'},
    {'icon': Icons.sports_basketball, 'label': 'Sports Wear'},
    {'icon': Icons.percent, 'label': 'Special Offer'},
    {'icon': Icons.laptop, 'label': 'Electronics'},
    {'icon': Icons.bookmark, 'label': 'Blogs'},
    {'icon': Icons.man, 'label': 'Mens'},
    {'icon': Icons.woman, 'label': 'Womens'},
  ];

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
                return Column(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAppBar(),
            _buildCategorySection(),
            const SizedBox(height: 10),
            _buildBannerSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(Icons.shopping_cart, color: Colors.white),
      ),
    );
  }
}

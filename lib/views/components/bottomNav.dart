import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../screens/home.dart';
import '../screens/store.dart';
import '../screens/wishlist.dart';
import '../screens/profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  late PersistentTabController _controller;
  bool _isLandscape = false;
  int _currentIndex = 0; // Track the selected tab index

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    WidgetsBinding.instance.addObserver(this); // Add observer for orientation changes
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // Called when the device orientation changes
    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape && !_isLandscape) {
      setState(() {
        _isLandscape = true;
      });
    } else if (orientation == Orientation.portrait && _isLandscape) {
      setState(() {
        _isLandscape = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLandscape
          ? _buildScreens()[_currentIndex] // Show only the selected screen in landscape
          : PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineToSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index; // Update the selected index
            _controller.index = index;
          });
        },
        navBarStyle: NavBarStyle.style1,
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const StoreScreen(),
      const WishlistScreen(),
      const ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: "Home",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.store),
        title: "Store",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.favorite),
        title: "Wishlist",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: "Profile",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}
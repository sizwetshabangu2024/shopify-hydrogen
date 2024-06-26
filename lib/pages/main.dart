import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shopify_hydrogen/pages/cart_screen.dart';
import 'package:shopify_hydrogen/pages/collections.dart';
import 'package:shopify_hydrogen/pages/home_screen.dart';
import 'package:shopify_hydrogen/providers/shopify_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const CollectionsPage(),
    const CartScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: SizedBox(
        height: 80,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag),
                  label: 'Products',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.category),
                  label: 'Collections',
                ),
                BottomNavigationBarItem(
                  icon: Consumer<ShopifyProvider>(
                    builder: (ctx, shopifyProvider, _) {
                      if (shopifyProvider.cart.isEmpty) {
                        return const Icon(Icons.shopping_cart_outlined);
                      } else {
                        return const Icon(Icons.shopping_cart);
                      }
                    },
                  ),
                  label: 'Cart',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.blue,
              onTap: _onItemTapped,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_flutter/shopify_flutter.dart';
import 'package:shopify_hydrogen/pages/cart_screen.dart';
import 'package:shopify_hydrogen/pages/home_screen.dart';
import 'package:shopify_hydrogen/pages/order_confirmation_screen.dart';
import 'package:shopify_hydrogen/pages/success_screen.dart';
import './providers/shopify_provider.dart';

void main() {
  ShopifyConfig.setConfig(
      storefrontAccessToken: "16078089379d9bc48515ab671a39bbc3",
      storeUrl: "quickstart-b7d1dbcd.myshopify.com",
      storefrontApiVersion: "2023-07",
    language: 'en',
    cachePolicy: CachePolicy.cacheAndNetwork,
  );

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ShopifyProvider(),
      child: MaterialApp(
        title: 'Shopify Hydrogen',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
        routes: {
          '/cart': (context) => const CartScreen(),
          '/success': (context) => const SuccessScreen(),
          '/order-confirmation': (context) => const OrderConfirmationScreen(),
        },
      ),
    );
  }
}

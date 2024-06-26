import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_flutter/shopify_flutter.dart';
import 'package:shopify_hydrogen/pages/main.dart';
import './providers/shopify_provider.dart';

void main() {
  ShopifyConfig.setConfig(
      storefrontAccessToken: "16078089379d9bc48515ab671a39bbc3",
      storeUrl: "quickstart-b7d1dbcd.myshopify.com",
      storefrontApiVersion: "2023-07",
    language: 'en',
    cachePolicy: CachePolicy.cacheAndNetwork, //TODO: THINK ABOUT OFFLINE ACCESS
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
        home: MainPage(),
/*        routes: {
          '/cart': (context) => CartScreen(),
          '/success': (context) => const SuccessScreen(),
          '/order-confirmation': (context) => OrderConfirmationScreen(),
        }*/
      ),
    );
  }
}

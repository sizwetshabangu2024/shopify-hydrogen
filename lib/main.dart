import 'package:flutter/material.dart';
import 'package:shopify_flutter/shopify_flutter.dart';
import 'pages/cart.dart'; // Import the cart page

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
    return MaterialApp(
      title: 'Shopify Hydrogen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Welcome to Shopify hydrogen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List<Product> products = [];
  ShopifyStore shopifyStore = ShopifyStore.instance;

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  void _getProducts() async {
    var results = await shopifyStore.getAllProducts();
    setState(() {
      products = results;
    });
  }

  void _goToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CheckoutCartPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _goToCart,
              child: const Text('Go to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}

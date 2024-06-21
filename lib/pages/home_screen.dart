import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shopify_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopifyProvider = Provider.of<ShopifyProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Snowboard Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: shopifyProvider.fetchProducts(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print('Waiting for products...');
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Error fetching products: ${snapshot.error}');
            return const Center(child: Text('Error fetching products'));
          } else {
            return Consumer<ShopifyProvider>(
              builder: (ctx, shopifyProvider, _) {
                if (shopifyProvider.products.isEmpty) {
                  print('No products found');
                  return const Center(child: Text('No products found'));
                } else {
                  return ListView.builder(
                    itemCount: shopifyProvider.products.length,
                    itemBuilder: (ctx, i) {
                      final product = shopifyProvider.products[i];
                      return ListTile(
                        title: Text(product.title),
                        subtitle: Text('${product.currencyCode} ${product.price.toStringAsFixed(2)}'),
                        leading: product.imageUrl.isNotEmpty
                            ? Image.network(product.imageUrl)
                            : null,
                        trailing: IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            shopifyProvider.addToCart(product);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

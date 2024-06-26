import 'package:flutter/material.dart';
import 'package:shopify_flutter/models/models.dart';
import 'package:shopify_flutter/shopify/shopify.dart';
import 'package:shopify_hydrogen/widgets/product_card.dart';
import 'package:shopify_hydrogen/widgets/related_products_scrollview.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key, required this.productId, required this.productTitle});

  final List<String> productId;
  final String productTitle;

  Future<List<Product>?> fetchProducts() {
    return ShopifyStore.instance.getProductsByIds(productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        title: Text(productTitle),
        titleTextStyle: const TextStyle(
          color: Colors.white
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No products available'));
            }
          final products = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleProductCardWidget(product: products.first),
                const SizedBox(height: 32.0),
                const Text(
                  'Related Products',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                RelatedProductsWidget(productTitle: products.first.title, productCollections: products.first.collectionList ?? []),
              ],
            )
          ),
          );
        },
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:shopify_flutter/models/models.dart';
import 'package:shopify_hydrogen/widgets/product_card.dart';
import 'package:shopify_hydrogen/widgets/related_products_scrollview.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        title: Text(product.title),
        titleTextStyle: const TextStyle(
          color: Colors.white
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleProductCardWidget(product: product),
            const SizedBox(height: 32.0),
            const Text(
              'Related Products',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            RelatedProductsWidget(productTitle: product.title, productCollections: product.collectionList ?? []),
          ],
        )
        ),
      ),
    );
  }
}


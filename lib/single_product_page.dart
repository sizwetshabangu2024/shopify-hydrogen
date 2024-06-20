import 'package:flutter/material.dart';
import 'package:shopify_flutter/models/models.dart';
import 'package:shopify_flutter/models/src/product/product.dart';
import 'package:shopify_flutter/shopify/shopify.dart';
import 'package:shopify_flutter/shopify/src/shopify_store.dart';

class SingleProductPage extends StatelessWidget {
  const SingleProductPage({super.key, this.product});
  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white12,
        title: const Text('Product'),
          titleTextStyle: const TextStyle(color: Colors.white),
        leading: IconButton(
          icon: const Icon(
            Icons.navigate_before,
            color: Colors.white70,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            children: [
              NameSection(name: product!.title),
            ],
          )
      )
    );
  }
}

class SingleProductCard extends StatefulWidget {
  const SingleProductCard({super.key});

  @override
  State<SingleProductCard> createState() => SingleProductCardState();
}

class SingleProductCardState extends State<SingleProductCard> {
  List<Product> products = [];

  ShopifyStore shopifyStoreInstance = ShopifyStore.instance;

   void _getProducts() {
    setState(() async {
      products = await shopifyStoreInstance.getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Column(
          children: <Widget>[
            ImageSection(image: '',),
            NameSection(name: 'Product Name'),
            ButtonSection(),
          ],
        ),
    );
  }
}

class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      width: 600,
      height: 240,
      fit: BoxFit.cover,
    );
  }
}

class NameSection extends StatelessWidget {
  const NameSection({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
    );
  }
}

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.only(top: 8),
      child: Icon(Icons.shopping_cart)
    );
  }
}
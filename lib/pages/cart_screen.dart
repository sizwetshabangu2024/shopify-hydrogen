import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shopify_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopifyProvider = Provider.of<ShopifyProvider>(context);
    final cartItems = shopifyProvider.cart;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, i) {
                final item = cartItems[i];
                return ListTile(
                  title: Text(item.product.title),
                  subtitle: Text('R${item.product.price.toStringAsFixed(2)} x ${item.quantity}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      shopifyProvider.removeFromCart(item.product.id);
                    },
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'R${shopifyProvider.cart.fold(0.0, (double sum, item) => sum + (item.product.price * item.quantity)).toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                shopifyProvider.createOrder().then((_) {
                  Navigator.pushReplacementNamed(context, '/success');
                });
              },
              child: const Text('Pay'),
            ),
          ),
        ],
      ),
    );
  }
}

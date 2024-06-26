import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopify_hydrogen/pages/product.dart';

import '../models/cart.dart';
import '../providers/shopify_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopifyProvider = Provider.of<ShopifyProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dariel Swag Shop')
      ),
      body: FutureBuilder(
        future: shopifyProvider.fetchAllProducts(),
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
                      final cartItem = shopifyProvider.cart.firstWhere(
                            (item) => item.product.id == product.id,
                        orElse: () => CartItem(product: product, quantity: 0),
                      );
                      final int quantity = cartItem.quantity;

                      return ListTile(
                        title: Text(product.title),
                        onTap: (){
                          List<String> productIds = [];
                          productIds.add(product.id);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductPage(productId: productIds, productTitle: product.title,)));
                        },
                        subtitle: Text('${product.currencyCode} ${product.price.toStringAsFixed(2)}'),
                        leading: product.imageUrl.isNotEmpty
                            ? Image.network(product.imageUrl)
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (quantity > 0)
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  shopifyProvider.removeFromCart(product.id);
                                },
                              ),
                            if (quantity > 0)
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  if (quantity > 1) {
                                    shopifyProvider.updateQuantity(product.id, quantity - 1);
                                  } else {
                                    shopifyProvider.removeFromCart(product.id);
                                  }
                                },
                              ),
                            if (quantity > 0)
                              Text('$quantity'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {

                                shopifyProvider.addToCart(product);
                              },
                            ),
                          ],
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

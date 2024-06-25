import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../providers/shopify_provider.dart';
import 'checkout_webview_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  CartScreenState createState() => CartScreenState();
}

class CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final shopifyProvider = Provider.of<ShopifyProvider>(context);
    final cartItems = shopifyProvider.cart;
    final totalAmount = cartItems.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 150, color: Colors.blue),
            SizedBox(height: 20),
            Text('Your cart is empty', style: TextStyle(fontSize: 20, color: Colors.black)),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, i) {
                final cartItem = cartItems[i];
                final itemTotal = cartItem.product.price * cartItem.quantity;
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 15),
                  child: ListTile(
                    leading: cartItem.product.imageUrl.isNotEmpty
                        ? Image.network(cartItem.product.imageUrl)
                        : null,
                    title: Text(cartItem.product.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${cartItem.product.currencyCode} ${cartItem.product.price.toStringAsFixed(2)} each',
                        ),
                        Text(
                          'Item Total: ${cartItem.product.currencyCode} ${itemTotal.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (cartItem.quantity > 0)
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              shopifyProvider.removeFromCart(
                                  cartItem.product.id);
                            },
                          ),
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            if (cartItem.quantity > 1) {
                              shopifyProvider.updateQuantity(
                                  cartItem.product.id,
                                  cartItem.quantity - 1);
                            } else {
                              shopifyProvider.removeFromCart(
                                  cartItem.product.id);
                            }
                          },
                        ),
                        Text('${cartItem.quantity}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            shopifyProvider.addToCart(
                                cartItem.product);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Remove all items from cart'),
                onPressed: () async {
                  final confirm = await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Confirm'),
                      content: const Text(
                          'Do you really want to remove all items from the cart?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          },
                          child: const Text('Yes'),
                        ),
                      ],
                    ),
                  );
                  if (confirm) {
                    shopifyProvider.clearCart();
                  }
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${cartItems.isNotEmpty ? cartItems[0].product.currencyCode : ''} ${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          if (cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  Fluttertoast.showToast(
                    msg: "Processing...",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                  );
                  final checkoutUrl =
                  await shopifyProvider.createOrder();
                  if (checkoutUrl != null) {
                    Future.delayed(const Duration(seconds: 3), () {
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutWebviewScreen(
                            checkoutUrl: checkoutUrl,
                          ),
                        ),
                      );
                    });
                  } else {
                    setState(() {
                      _isLoading = false;
                    });
                    Fluttertoast.showToast(
                      msg: "Failed to create order",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                    );
                  }
                },
                child: const Text('Pay'),
              ),
            ),
        ],
      ),
    );
  }
}

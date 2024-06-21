import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../main.dart';
import '../providers/shopify_provider.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopifyProvider = Provider.of<ShopifyProvider>(context, listen: false);
    final cartItems = shopifyProvider.cart;
    final double totalAmount = cartItems.fold(0, (sum, item) => sum + (item.product.price * item.quantity));

    String generateOrderNumber() {
      var rng = Random();
      return (rng.nextInt(90000) + 10000).toString(); // 5-digit order number
    }

    String generateRandomAddress() {
      var streets = ['Main St', 'High St', 'Church St', 'Station Rd', 'London Rd'];
      var cities = ['New York', 'Los Angeles', 'Chicago', 'Houston', 'Phoenix'];
      var rng = Random();
      return '${rng.nextInt(9999) + 1} ${streets[rng.nextInt(streets.length)]}, ${cities[rng.nextInt(cities.length)]}';
    }

    String orderNumber = generateOrderNumber();
    String address = generateRandomAddress();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Order Number: $orderNumber',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                'Order Status: Order Received',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Text(
                'Shipping Address: $address',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Text(
                'Order Summary:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          cartItems[index].product.title,
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          '(R${cartItems[index].product.price.toStringAsFixed(2)})',
                                          style: const TextStyle(fontSize: 18),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Quantity:',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          '${cartItems[index].quantity}',
                                          style: const TextStyle(fontSize: 18),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Total:',
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'R${(cartItems[index].product.price * cartItems[index].quantity).toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 18),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Text(
                'Total Amount: R${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()), // Adjust this to your actual home page widget
                  );
                },
                child: const Text('Go to Homepage'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

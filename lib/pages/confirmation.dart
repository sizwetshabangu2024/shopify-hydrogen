import 'package:flutter/material.dart';
import '../main.dart';
import 'dart:math';
import 'cart.dart';

class OrderConfirmationPage extends StatelessWidget {
  final List<CartItem> cartItems;
  final double totalAmount;

  const OrderConfirmationPage({
    super.key,
    required this.cartItems,
    required this.totalAmount});

  String generateOrderNumber() {
    var rng = Random();
    return (rng.nextInt(90000) + 10000).toString(); // 5-digit order number
  }

  String generateRandomAddress() {
    var streets = ['Main St', 'High St', 'Church St', 'Jan Smuts Av', 'Beach Rd'];
    var cities = ['Pretoria', 'Johannesburg', 'Cape Town', 'Durban', 'Gqeberha', 'Bloemfontein'];
    var rng = Random();
    return '${rng.nextInt(9999) + 1} ${streets[rng.nextInt(streets.length)]}, ${cities[rng.nextInt(cities.length)]}';
  }

  @override
  Widget build(BuildContext context) {
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
                                          cartItems[index].name,
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          '(R${cartItems[index].price.toStringAsFixed(2)})',
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
                                          'R${(cartItems[index].price * cartItems[index].quantity).toStringAsFixed(2)}',
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
                    MaterialPageRoute(builder: (context) => const MyApp()),
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

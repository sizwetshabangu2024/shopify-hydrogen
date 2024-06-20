import 'package:flutter/material.dart';
import 'cart.dart';
import 'confirmation.dart';

class SuccessPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final double totalAmount;

  const SuccessPage({
    super.key,
    required this.cartItems,
    required this.totalAmount});

  @override
  SuccessPageState createState() => SuccessPageState();
}

class SuccessPageState extends State<SuccessPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationPage(
            cartItems: widget.cartItems,
            totalAmount: widget.totalAmount,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Successful'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              'Payment Successful',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'You will be redirected to the order confirmation page shortly.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderConfirmationPage(
                      cartItems: widget.cartItems,
                      totalAmount: widget.totalAmount,
                    ),
                  ),
                );
              },
              child: const Text('Go to Order Confirmation'),
            ),
          ],
        ),
      ),
    );
  }
}

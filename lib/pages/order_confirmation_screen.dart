import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopify_provider.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final shopifyProvider = Provider.of<ShopifyProvider>(context);
    final order = shopifyProvider.lastOrder;

    if (order.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Order Confirmation'),
        ),
        body: const Center(
          child: Text('No order details available.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Confirmation',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Order ID: ${order['id']}'),
            const SizedBox(height: 10),
            Text(
              'Total Price: ${order['totalPriceV2'] != null ? order['totalPriceV2']['currencyCode'] : ''} ${order['totalPriceV2'] != null ? order['totalPriceV2']['amount'] : ''}',
            ),
            const SizedBox(height: 20),
            const Text(
              'Items:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (order['lineItems'] != null && order['lineItems']['edges'] != null)
              ...order['lineItems']['edges'].map<Widget>((item) {
                return ListTile(
                  title: Text(item['node']['title']),
                  subtitle: Text('Quantity: ${item['node']['quantity']}'),
                  trailing: Text(
                    '${item['node']['variant']['priceV2']['currencyCode']} ${item['node']['variant']['priceV2']['amount']} each',
                  ),
                );
              }).toList(),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

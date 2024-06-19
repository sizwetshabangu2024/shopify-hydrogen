import 'package:flutter/material.dart';
import 'success.dart'; // Add this import for the success page

class CheckoutCartPage extends StatefulWidget {
  const CheckoutCartPage({super.key});

  @override
  CheckoutCartPageState createState() => CheckoutCartPageState();
}

class CheckoutCartPageState extends State<CheckoutCartPage> {
  List<CartItem> cartItems = [
    CartItem(
      name: 'T-Shirt',
      price: 20.0,
      quantity: 2,
    ),
    CartItem(
      name: 'Jeans',
      price: 35.0,
      quantity: 1,
    ),
    CartItem(
      name: 'Jacket',
      price: 50.0,
      quantity: 3,
    ),
  ];

  void _removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  void _addQuantity(int index) {
    setState(() {
      cartItems[index].quantity++;
    });
  }

  void _subtractQuantity(int index) {
    setState(() {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
      } else {
        _removeItem(index);
      }
    });
  }

  void _removeAllItems() {
    setState(() {
      cartItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalAmount = cartItems.fold(
        0, (sum, item) => sum + (item.price * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: cartItems.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    size: 100,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return CartItemWidget(
                  cartItem: cartItems[index],
                  onRemove: () => _removeItem(index),
                  onAdd: () => _addQuantity(index),
                  onSubtract: () => _subtractQuantity(index),
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
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'R${totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (cartItems.isNotEmpty)
                  Tooltip(
                    message: 'Empty cart',
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Empty cart'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm'),
                              content: const Text('Are you sure you want to remove all items from the cart?'),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Remove All'),
                                  onPressed: () {
                                    _removeAllItems();
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                Tooltip(
                  message: cartItems.isEmpty
                      ? 'Add items to cart before paying'
                      : 'Proceed to payment',
                  child: ElevatedButton(
                    onPressed: cartItems.isEmpty
                        ? null
                        : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payment in progress...')),
                      );
                      Future.delayed(const Duration(seconds: 3), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SuccessPage(
                              cartItems: cartItems,
                              totalAmount: totalAmount,
                            ),
                          ),
                        );
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      backgroundColor: cartItems.isEmpty ? Colors.grey : null,
                    ),
                    child: const Text('Pay'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartItem {
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
  });
}

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onRemove;
  final VoidCallback onAdd;
  final VoidCallback onSubtract;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    required this.onRemove,
    required this.onAdd,
    required this.onSubtract,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'R${cartItem.price.toStringAsFixed(2)} each',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: onSubtract,
                    ),
                    Text(
                      'x${cartItem.quantity}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: onAdd,
                    ),
                  ],
                ),
                Text(
                  'Item Total: R${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

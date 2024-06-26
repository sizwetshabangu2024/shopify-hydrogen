import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shopify_flutter/models/models.dart';
import 'package:shopify_hydrogen/models/product_model.dart';
import 'package:shopify_hydrogen/pages/cart_screen.dart';
import 'package:shopify_hydrogen/widgets/product_image_scrollview.dart';
import '../providers/shopify_provider.dart';

class SingleProductCardWidget extends StatelessWidget {
  const SingleProductCardWidget({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final shopifyProvider = Provider.of<ShopifyProvider>(context);
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ProductImageScrollview(images: product.images),
              )
            ),
            const SizedBox(height: 16.0),
            ListTile(
              title: Text(
                product.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  product.description ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              product.formattedPrice,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    shopifyProvider.addToCart(ProductModel.fromProduct(product));
                        Fluttertoast.showToast(
                          msg: "Added to cart ",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),

                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    shopifyProvider.addToCart(ProductModel.fromProduct(product));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    //backgroundColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: const BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.black,
                        width: 2
                      ),
                    ),
                  ),
                  child: const Text(
                    'Checkout',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),

                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

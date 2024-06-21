import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/product_model.dart';
import '../models/cart.dart';

class ShopifyProvider with ChangeNotifier {
  final String _storefrontApiUrl = 'https://quickstart-b7d1dbcd.myshopify.com/api/2023-07/graphql.json'; // Ensure the URL is correct
  final String _accessToken = '16078089379d9bc48515ab671a39bbc3';

  List<ProductModel> _products = [];
  List<CartItem> _cart = [];

  List<ProductModel> get products => _products;
  List<CartItem> get cart => _cart;

  Future<void> fetchAllProducts() async {
    print('Fetching all products...');
    String? endCursor;
    bool hasNextPage = true;

    while (hasNextPage) {
      final response = await http.post(
        Uri.parse(_storefrontApiUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-Shopify-Storefront-Access-Token': _accessToken,
        },
        body: json.encode({
          'query': '''
          {
            products(first: 50, after: ${endCursor != null ? '"$endCursor"' : 'null'}) {
              edges {
                node {
                  id
                  title
                  description
                  variants(first: 1) {
                    edges {
                      node {
                        priceV2 {
                          amount
                          currencyCode
                        }
                      }
                    }
                  }
                  images(first: 1) {
                    edges {
                      node {
                        src
                      }
                    }
                  }
                }
              }
              pageInfo {
                hasNextPage
                endCursor
              }
            }
          }
          '''
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final productsData = responseData['data']['products'];

        if (productsData != null) {
          productsData['edges'].forEach((productData) {
            _products.add(ProductModel.fromJson(productData['node']));
          });

          hasNextPage = productsData['pageInfo']['hasNextPage'];
          endCursor = productsData['pageInfo']['endCursor'];
        } else {
          hasNextPage = false;
        }

        notifyListeners();
      } else {
        print('Failed to fetch products: ${response.statusCode}');
        print('Response body: ${response.body}');
        break;
      }
    }
    print('Total products loaded: ${_products.length}');
  }

  void addToCart(ProductModel product) {
    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cart[index].quantity += 1;
    } else {
      _cart.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  Future<void> createOrder() async {
    final response = await http.post(
      Uri.parse(_storefrontApiUrl),
      headers: {
        'Content-Type': 'application/json',
        'X-Shopify-Storefront-Access-Token': _accessToken,
      },
      body: json.encode({
        'query': '''
          mutation {
            checkoutCreate(input: {
              lineItems: [
                ${_cart.map((item) => '{ variantId: "${item.product.id}", quantity: ${item.quantity} }').join(',')}
              ]
            }) {
              checkout {
                id
                webUrl
              }
            }
          }
        '''
      }),
    );

    if (response.statusCode == 200) {
      clearCart();
    } else {
      throw Exception('Failed to create order');
    }
  }
}

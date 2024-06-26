import 'package:flutter/foundation.dart';
import 'package:shopify_flutter/models/models.dart';

class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currencyCode;
  final String imageUrl;
  final String variantId;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currencyCode,
    required this.imageUrl,
    required this.variantId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    var price = 0.0;
    var currencyCode = '';
    var variantId = '';
    if (json['variants']['edges'].isNotEmpty) { //TODO: THINK ABOUT HOW TO HANDLE DIFFERENT VARIATIONS OF A PRODUCT,
                                              // LIKE SMALL, LARGE AND MEDIUM, OR DIFF COLOURS
      price = double.parse(json['variants']['edges'][0]['node']['priceV2']['amount']);
      currencyCode = json['variants']['edges'][0]['node']['priceV2']['currencyCode'];
      variantId = json['variants']['edges'][0]['node']['id'];
    }

    var imageUrl = '';
    if (json['images']['edges'].isNotEmpty) {
      imageUrl = json['images']['edges'][0]['node']['src'];
    }

    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: price,
      currencyCode: currencyCode,
      imageUrl: imageUrl,
      variantId: variantId,
    );
  }

  factory ProductModel.fromProduct(Product product) {
    return ProductModel(
        id: product.id,
        title: product.title,
        description: product.description ?? '',
        price: product.price,
        currencyCode: product.currencyCode,
        imageUrl: product.image,
        variantId: product.productVariants.first.id
    );
  }
}

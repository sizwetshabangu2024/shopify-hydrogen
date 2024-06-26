import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shopify_flutter/models/models.dart';
import 'package:shopify_flutter/shopify/shopify.dart';
import 'package:shopify_hydrogen/pages/product.dart';
import 'package:shopify_hydrogen/widgets/related_product_card.dart';

class RelatedProductsWidget extends StatelessWidget {
  const RelatedProductsWidget({super.key, required this.productTitle, required this.productCollections});

  final String productTitle;
  final List<AssociatedCollections> productCollections;

  Future<List<Product>> _getRelatedProducts() async {
    try {
      return await ShopifyStore.instance.getAllProducts();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getRelatedProducts(),
        builder: (context, relatedProductsSnapShot) {
          if (relatedProductsSnapShot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (relatedProductsSnapShot.hasError) {
            return const Center(
              child: Text('Error: ---'),
            );
          } else if (relatedProductsSnapShot.hasData) {
            final relatedProducts = relatedProductsSnapShot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: relatedProducts.map((relatedProduct) {
                  if(relatedProduct.collectionList == null ||
                      relatedProduct.collectionList!.isEmpty ||
                      relatedProduct.title == productTitle
                  ){
                    return const Center(
                      child: SizedBox.shrink(),
                    );
                  }
                  List<AssociatedCollections>relatedProductCollections = relatedProduct.collectionList!;
                  if( listEquals(relatedProductCollections, productCollections)){}
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child:   GestureDetector(
                      onTap: (){
                        List<String> productIds = [];
                        productIds.add(relatedProduct.id);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductPage(productId: productIds)));
                      },
                      child: RelatedProductCardWidget(relatedProduct: relatedProduct,),
                    ));
                }).toList(),
              ),
            );
          } else {
            return const Center(
              child: Text('No related products found'),
            );
          }
        });
  }
}



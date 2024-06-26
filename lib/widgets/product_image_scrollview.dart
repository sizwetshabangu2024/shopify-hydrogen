import 'package:flutter/cupertino.dart';
import 'package:shopify_flutter/models/models.dart';

class ProductImageScrollview extends StatelessWidget{
  const ProductImageScrollview({super.key, required this.images});

  final List<ShopifyImage> images;

  @override
  Widget build(BuildContext context) {
   return SingleChildScrollView(
     scrollDirection: Axis.horizontal,
     child: Padding(
       padding: EdgeInsets.zero,
       child: Row(
         children: images.map((image){
           if(images.length> 1){

           }
           return ClipRRect(
             borderRadius: BorderRadius.circular(5.0),
             child: Image.network(
               image.originalSrc,
               width: 400,
               height: 400,
               fit: BoxFit.cover,
             ),
           );
         }).toList(),
       ),
     ),
   );


  }
}
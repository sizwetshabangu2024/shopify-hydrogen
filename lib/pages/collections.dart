import 'package:flutter/material.dart';
import 'package:shopify_flutter/models/models.dart';
import 'package:shopify_flutter/shopify/shopify.dart';
import 'package:shopify_hydrogen/widgets/collection_card.dart';

class CollectionsPage extends StatelessWidget {
  const CollectionsPage({super.key});

  Future<List<Collection>> _getCollections() {
    return ShopifyStore.instance.getAllCollections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Collections'),
        ),
        body: FutureBuilder<List<Collection>> (
            future: _getCollections(),
            builder: (context, collectionsSnapshot) {
              if (collectionsSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (collectionsSnapshot.hasError) {
                return const Center(
                  child: Text('Error: ---'),
                );
              } else if (collectionsSnapshot.hasData) {
                final collections = collectionsSnapshot.data!;
                return SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: collections.map((collection){
                        return Card(
                          child: CollectionCard(
                              imageUrl: collection.imageUrl,
                              title: collection.title,
                              onTap: (){

                              }),
                        );
                      }).toList(),
                      ),
                    ),
                );
              }else {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.category_outlined,
                          size: 150, color: Colors.blue),
                      SizedBox(height: 20),
                      Text('No collections',
                          style: TextStyle(fontSize: 20, color: Colors.black)),
                    ],
                  ),
                );
              }
            }
            )
    );
  }
}

class ProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String currencyCode;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.currencyCode,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    var price = 0.0;
    var currencyCode = '';
    if (json['variants']['edges'].isNotEmpty) {
      price = double.parse(json['variants']['edges'][0]['node']['priceV2']['amount']);
      currencyCode = json['variants']['edges'][0]['node']['priceV2']['currencyCode'];
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
    );
  }
}

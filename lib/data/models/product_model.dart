class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String? imageUrl2;
  final List<String>? tags;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.imageUrl2,
    this.tags,
  });

  String get primaryImage => imageUrl;
  List<String> get images => [imageUrl, if (imageUrl2 != null) imageUrl2!];
}

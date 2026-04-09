class StoreModel {
  final String id;
  final String name;
  final String category;
  final double rating;
  final int discount;
  final String address;
  final String imageUrl;
  final bool isOpen;

  StoreModel({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.discount,
    required this.address,
    required this.imageUrl,
    required this.isOpen,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      rating: (json['rating'] as num).toDouble(),
      discount: json['discount'] as int,
      address: json['address'] as String,
      imageUrl: json['imageUrl'] as String,
      isOpen: json['isOpen'] as bool,
    );
  }
}

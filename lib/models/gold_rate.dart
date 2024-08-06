class GoldRate {
  final int id;
  final String itemSize;
  final String price;
  final String imagePath;

  GoldRate({
    required this.id,
    required this.itemSize,
    required this.price,
    required this.imagePath,
  });

  factory GoldRate.fromJson(Map<String, dynamic> json) {
    return GoldRate(
      id: int.tryParse(json['id'].toString()) ?? 0, // Ensure id is an integer
      itemSize: json['item_size'] ?? '',
      price: json['price'] ?? '',
      imagePath: json['image_path'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_size': itemSize,
      'price': price,
      'image_path': imagePath,
    };
  }
}

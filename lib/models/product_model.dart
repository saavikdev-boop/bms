class Product {
  final String id;
  final String name;
  final String? category;
  final double rating;
  final String reviews;
  final int mrp;
  final int price;
  final int discount;
  final String imageUrl;
  final List<String> sizes;
  final String description;
  final String? size;

  Product({
    required this.id,
    required this.name,
    this.category,
    this.rating = 0.0,
    this.reviews = '',
    required this.mrp,
    required this.price,
    required this.imageUrl,
    this.sizes = const [],
    this.description = '',
    this.size,
  }) : discount = ((mrp - price) / mrp * 100).round();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'rating': rating,
      'reviews': reviews,
      'mrp': mrp,
      'price': price,
      'discount': discount,
      'imageUrl': imageUrl,
      'sizes': sizes,
      'description': description,
      'size': size,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviews: json['reviews'] ?? '',
      mrp: json['mrp'] ?? 0,
      price: json['price'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      sizes: List<String>.from(json['sizes'] ?? []),
      description: json['description'] ?? '',
      size: json['size'],
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? category,
    double? rating,
    String? reviews,
    int? mrp,
    int? price,
    String? imageUrl,
    List<String>? sizes,
    String? description,
    String? size,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
      mrp: mrp ?? this.mrp,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      sizes: sizes ?? this.sizes,
      description: description ?? this.description,
      size: size ?? this.size,
    );
  }
}
class Product {
  String? id; // Use nullable to handle cases where id might not be present
  String name;
  String description;
  double price;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  /// Factory method to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['_id'], // Map `_id` to `id`
        name: json['name'],
        description: json['description'],
        price: (json['price'] as num).toDouble(), 
      );

  /// Convert a Product object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'description': description,
      'price': price,
    };
    if (id != null) {
      data['_id'] = id; 
    }
    return data;
  }
}

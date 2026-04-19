import 'dart:math';

/// Represents the core data structure for a product in the shopping feature. 🛍️
///
/// This entity contains all the essential properties of a product, such as its
/// name, price, category, and images. It's designed to be a clean, data-only
/// object, often used in the domain layer of a clean architecture setup.
///
/// For value equality, this class should ideally extend `Equatable`.
class ProductEntity {
  /// The unique identifier for the product.
  final String id;

  /// The category the product belongs to (e.g., 'food', 'toy', 'health').
  final String category;

  /// The display name of the product.
  final String name;

  /// The standard price of the product.
  final double price;

  /// A list of URLs for the product's images.
  final List<String> picsUrls;

  /// The available stock quantity of the product.
  final int quantity;

  /// A detailed description of the product. Can be null.
  final String? description;

  /// The promotional or sale price. Can be null if there is no promotion.
  final double? promoPrice;

  /// Creates an instance of [ProductEntity].
  const ProductEntity({
    required this.id,
    required this.category,
    required this.name,
    required this.price,
    required this.picsUrls,
    required this.quantity,
    this.description,
    this.promoPrice,
  });

  /// A list of the object's properties for equality comparison.
  ///
  /// This is typically used with the `equatable` package to override `==` and `hashCode`.
  List<Object?> get props => [
    id,
    category,
    name,
    price,
    picsUrls,
    quantity,
    description,
    promoPrice,
  ];

  /// A factory constructor to create a [ProductEntity] from a JSON map.
  ///
  /// This is a common pattern for deserializing data from an API.
  ///
  /// **Note:** In a clean architecture, this logic would typically reside in a
  /// `ProductModel` class in the data layer, which then converts to a
  /// `ProductEntity`. The `promoPrice` is also randomly generated here for
  /// demonstration purposes and should be part of the actual data in a real app.
  static ProductEntity fromJson(Map<String, dynamic> data) {
    return ProductEntity(
      id: data['id'],
      category: data['type'],
      name: data['name'],
      price: data['price'],
      picsUrls: [data['image']],
      quantity: data['quantity'],
      description: data['description'],

      /// The promo price is randomly generated for demonstration purposes.
      promoPrice: Random().nextBool()
          ? (data['price'] * ((Random().nextInt(4) + 1.0) / 10))
          : null,
    );
  }
}

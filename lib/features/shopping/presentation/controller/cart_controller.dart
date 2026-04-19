import 'package:get/get.dart';
import 'package:peticare/dummy_data/dummy_data.dart';
import 'package:peticare/features/shopping/domain/entities/product_entity.dart';

/// Manages the state and business logic for the user's shopping cart. 🛒
///
/// This controller handles all operations related to the shopping cart, including
/// adding, removing, and updating the quantity of products. It also calculates
/// the total price of the items in the cart.
///
/// It uses `GetX` for state management, calling `update()` to notify listeners
/// and rebuild the UI whenever the cart's state changes.
class CartController extends GetxController {
  // ===========================================================================
  // 🚀 State Variables
  // ===========================================================================

  /// A list of items currently in the cart, initialized with dummy data.
  ///
  /// Each item is a map containing a single `ProductEntity` as the key and its
  /// quantity as the value.
  ///
  /// **Note:** A more robust implementation might use a custom `CartItem` class
  /// (e.g., `class CartItem { final ProductEntity product; int quantity; }`)
  /// instead of a `Map` to improve type safety and code readability.
  List<Map<ProductEntity, int>> cartContent = [
    {ProductEntity.fromJson(DummyData.listOfGrommingProducts[3]): 1},
    {ProductEntity.fromJson(DummyData.listOfFood[6]): 2},
    {ProductEntity.fromJson(DummyData.listOfMedecines[7]): 1},
  ];

  /// The total calculated price of all items in the cart.
  late double cartTotal;

  // ===========================================================================
  // ⚙️ Business Logic & State Management
  // ===========================================================================

  /// Increases the quantity of a product at a specific index in the cart.
  ///
  /// After updating the quantity, it recalculates the cart total and notifies listeners.
  void increaseProductQTE(int itemIndex) {
    cartContent[itemIndex] = {
      cartContent[itemIndex].keys.first:
          cartContent[itemIndex].values.first + 1,
    };
    _recalculateTotal();
    update();
  }

  /// Decreases the quantity of a product at a specific index in the cart.
  ///
  /// If the quantity drops to 1, it removes the product from the cart entirely.
  /// Otherwise, it decrements the quantity. After any change, it recalculates
  /// the cart total and notifies listeners.
  void decreaseProductQTE(int itemIndex) {
    final currentQuantity = cartContent[itemIndex].values.first;
    if (currentQuantity > 1) {
      cartContent[itemIndex] = {
        cartContent[itemIndex].keys.first: currentQuantity - 1,
      };
    } else {
      // If quantity is 1, remove the item instead of going to 0.
      removeProductFromCart(itemIndex);
    }
    _recalculateTotal();
    update();
  }

  /// Calculates the total price of all items in the cart.
  ///
  /// This method iterates through each item, multiplies its price by its quantity,
  /// and sums the results. It prioritizes `promoPrice` over the regular `price`
  /// if a promotional price is available.
  double _calcCartTotal() {
    double total = 0.0;
    for (var cartProduct in cartContent) {
      total +=
          (cartProduct.keys.first.promoPrice ?? cartProduct.keys.first.price) *
          cartProduct.values.first;
    }
    return total;
  }

  /// Removes a product from the cart at the given index.
  ///
  /// After removal, it recalculates the cart total and notifies listeners.
  void removeProductFromCart(int productIndex) {
    cartContent.removeAt(productIndex);
    _recalculateTotal();
    update();
  }

  /// A private helper to recalculate and update the `cartTotal` state.
  void _recalculateTotal() {
    cartTotal = _calcCartTotal();
  }

  // ===========================================================================
  // ♻️ Lifecycle Methods
  // ===========================================================================

  @override
  /// Initializes the controller when it is first created.
  ///
  /// This method calculates the initial total price of the items in the cart.
  void onInit() {
    super.onInit();
    cartTotal = _calcCartTotal();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peticare/dummy_data/dummy_data.dart';
import 'package:peticare/features/shopping/domain/entities/product_entity.dart';

/// Manages the state and logic for the product search page. 🔍
///
/// This controller handles user input from the search field, performs searches
/// against a local list of products, and manages the display of search results.
/// It uses a debounce mechanism to prevent excessive search operations while the
/// user is typing.
class ProductSearchController extends GetxController {
  // ===========================================================================
  // 🚀 State Variables & Controllers
  // ===========================================================================

  /// Controller for the search input field.
  late TextEditingController searchFieldController;

  /// A comprehensive list of all available products, compiled from various categories.
  ///
  /// In a real-world application, this data would likely be fetched from a
  /// backend service or a local database.
  late List<ProductEntity> listOfAllProducts;

  /// A list containing the products that match the current search query.
  /// It is `null` initially, indicating that no search has been performed yet.
  List<ProductEntity>? searchResultList;

  /// A timer used to implement a debounce mechanism for the search functionality.
  /// This prevents the search from running on every keystroke.
  Timer? autocompleteTimer;

  // ===========================================================================
  // ⚙️ Business Logic & State Management
  // ===========================================================================

  /// Initializes [listOfAllProducts] by combining and shuffling products from dummy data.
  void initAllProducts() {
    listOfAllProducts = [
      ...List.generate(
        DummyData.listOfMedecines.length,
        (index) => ProductEntity.fromJson(DummyData.listOfMedecines[index]),
      ),
      ...List.generate(
        DummyData.listOfFood.length,
        (index) => ProductEntity.fromJson(DummyData.listOfFood[index]),
      ),
      ...List.generate(
        DummyData.listOfToys.length,
        (index) => ProductEntity.fromJson(DummyData.listOfToys[index]),
      ),
      ...List.generate(
        DummyData.listOfGrommingProducts.length,
        (index) =>
            ProductEntity.fromJson(DummyData.listOfGrommingProducts[index]),
      ),
    ];
    listOfAllProducts.shuffle();
  }

  /// Clears the search field, resets the search results, and updates the UI.
  void clearSearch() {
    searchFieldController.clear();
    searchResultList = null;
    update();
  }

  /// Implements a debounce mechanism to delay the search operation.
  ///
  /// This method cancels any existing timer and starts a new one. The `onSearch`
  /// method is only called after the user has stopped typing for 700 milliseconds,
  /// improving performance by reducing the number of search queries.
  void autocompleteDebounce() {
    if (autocompleteTimer != null) {
      autocompleteTimer!.cancel();
    }
    autocompleteTimer = Timer(
      const Duration(milliseconds: 700),
      () => onSearch(),
    );
  }

  /// Performs the search based on the text in the [searchFieldController].
  ///
  /// - It splits the search query into individual words.
  /// - It filters `listOfAllProducts` to find products whose names contain all of the search words.
  /// - The search is case-insensitive.
  void onSearch() {
    searchResultList = [];

    // Extract individual search words from the input text
    List<String> searchWords = searchFieldController.text.toLowerCase().split(
      " ",
    );
    searchResultList = listOfAllProducts.where((product) {
      String productName = product.name.toLowerCase();

      // Check if all search words are contained within the product name
      return searchWords.every((word) => productName.contains(word));
    }).toList();
    update();
  }

  // ===========================================================================
  // ♻️ Lifecycle Methods
  // ===========================================================================

  @override
  /// Initializes the controller when it is first created.
  ///
  /// This method sets up the [searchFieldController] and populates the
  /// initial list of all products.
  void onInit() {
    searchFieldController = TextEditingController();
    initAllProducts();
    super.onInit();
  }

  @override
  /// Disposes of the controllers to prevent memory leaks when the widget is removed.
  void dispose() {
    searchFieldController.dispose();
    autocompleteTimer?.cancel();
    super.dispose();
  }
}

import 'package:get/get.dart';

import '../../data/services/shop_service.dart';
import '../../domain/entities/product_entity.dart';

class ShopController extends GetxController {

  final ShopService _service = ShopService();

  /// FEATURED PRODUCTS
  var featuredProducts = <ProductEntity>[].obs;

  /// ALL PRODUCTS
  var allProducts = <ProductEntity>[].obs;

  /// LOADING STATES
  var isLoadingFeatured = false.obs;

  var isLoadingAll = false.obs;

  @override
  void onInit() {

    super.onInit();

    loadFeaturedProducts();

    loadAllProducts();
  }

  // =====================================================
  // LOAD FEATURED PRODUCTS
  // =====================================================

  Future<void> loadFeaturedProducts() async {

    try {

      isLoadingFeatured.value = true;

      final data =
          await _service.getFeaturedProducts();

      featuredProducts.value = data
          .map<ProductEntity>(
            (item) =>
                ProductEntity.fromJson(item),
          )
          .toList();

      print(
        "FEATURED PRODUCTS >>> ${featuredProducts.length}",
      );

    } catch (e) {

      print("FEATURED SHOP ERROR: $e");

    } finally {

      isLoadingFeatured.value = false;
    }
  }

  // =====================================================
  // LOAD ALL PRODUCTS
  // =====================================================

  Future<void> loadAllProducts() async {

    try {

      isLoadingAll.value = true;

      final data =
          await _service.getAllProducts();

      allProducts.value = data
          .map<ProductEntity>(
            (item) =>
                ProductEntity.fromJson(item),
          )
          .toList();

      print(
        "ALL PRODUCTS >>> ${allProducts.length}",
      );

    } catch (e) {

      print("ALL PRODUCTS ERROR: $e");

    } finally {

      isLoadingAll.value = false;
    }
  }
}

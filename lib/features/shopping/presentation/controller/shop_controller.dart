import 'package:get/get.dart';

import '../../data/services/shop_service.dart';

class ShopController extends GetxController {

  final ShopService _service = ShopService();

  var products = [].obs;

  var isLoading = false.obs;

  @override
  void onInit() {

    super.onInit();

    loadProducts();
  }

  Future<void> loadProducts() async {

    try {

      isLoading.value = true;

      final data = await _service.getProducts();

      products.value = data;

      print("SHOP PRODUCTS >>> ${products.length}");

    } catch (e) {

      print("SHOP ERROR: $e");

    } finally {

      isLoading.value = false;
    }
  }
}

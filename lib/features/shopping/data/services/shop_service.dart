import 'package:get/get.dart';

class ShopService extends GetConnect {

  // =====================================================
  // FEATURED PRODUCTS
  // =====================================================

  Future<List<dynamic>> getFeaturedProducts() async {

    final response = await get(
      'http://192.168.40.54:8000/api/v1/shop/products/featured',
    );

    if (response.statusCode == 200) {

      return response.body;

    } else {

      throw Exception(
        'Error loading featured products',
      );
    }
  }

  // =====================================================
  // ALL PRODUCTS
  // =====================================================

  Future<List<dynamic>> getAllProducts() async {

    final response = await get(
      'http://192.168.40.54:8000/api/v1/shop/products',
    );

    if (response.statusCode == 200) {

      return response.body;

    } else {

      throw Exception(
        'Error loading all products',
      );
    }
  }
}

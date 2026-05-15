import 'package:get/get.dart';

class ShopService extends GetConnect {

  Future<List<dynamic>> getProducts() async {

    final response = await get(
      'http://192.168.40.54:8000/api/v1/shop/products',
    );

    if (response.statusCode == 200) {

      return response.body;

    } else {

      throw Exception(
        'Error loading shop products'
      );
    }
  }
}

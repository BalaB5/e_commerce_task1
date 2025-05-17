import 'package:get/get.dart';

import '../model/protect.dart';
import '../../utils/http_client.dart';

class ProductController extends GetxController {
  RxList<Product> products = <Product>[].obs;
  RxBool isLoading = true.obs;
  RxInt tempcount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProdunct();
  }

  void fetchProdunct() async {
    try {
      isLoading(true);
      var jsonData = await Api.get('products');
      products.value = productFromJson(jsonData);
    } catch (e) {
      Get.snackbar("products api", "Please try again");
    } finally {
      isLoading(false);
    }
  }

  Future<Product?> fetchDetails(id) async {
    try {
      isLoading(true);
      var jsonData = await Api.get('products/$id');
      return Product.fromJson(jsonData);
    } catch (e) {
      Get.snackbar("products api", "Please try again");
    } finally {
      isLoading(false);
    }
    return null;
  }
}

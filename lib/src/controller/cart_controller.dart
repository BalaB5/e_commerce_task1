import 'package:get/get.dart';
import '../model/cart.dart';

class CartController extends GetxController {
  RxList<CartProtucts> carts = <CartProtucts>[].obs;
  RxDouble totelPrice = 0.0.obs;

  bool checkAlreadyAvailable(id) {
    for (var cart in carts) {
      if (cart.product.id == id) {
        return true;
      }
    }

    return false;
  }

  addQty(index) {
    carts[index].quantity++;
    totelPrice.value = totelPrice.value + carts[index].product.price!;
    carts.refresh();
  }

  removeQty(index) {
    carts[index].quantity--;

    totelPrice.value = totelPrice.value - carts[index].product.price!;
    carts.refresh();
  }
}

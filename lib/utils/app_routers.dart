import 'package:e_commerce/src/view/screens/checkout_page.dart';
import 'package:e_commerce/src/view/screens/my_card_page.dart';
import 'package:e_commerce/src/view/screens/product_details_page.dart';
import 'package:e_commerce/src/view/screens/product_page.dart';

import 'package:get/get.dart';


class AppRoutes {
  static final pages = [
    GetPage(name:'/', page: () => const ProductPage()),
    GetPage(
        name: '/protectDetails/:id',
        page: () => const ProductDetailsPage()),
    GetPage(name: '/myCard', page: () => const MyCardPage()),
    GetPage(name:'/checkout', page: () => const CheckoutPage()),
  ];
}

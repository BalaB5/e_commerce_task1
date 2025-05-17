import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/cart_controller.dart';
import '../widgets/fooder.dart';
import '../widgets/network_image_loader.dart';
import '../widgets/nav_bar.dart';

class MyCardPage extends StatefulWidget {
  const MyCardPage({super.key});

  @override
  State<MyCardPage> createState() => _MyCardPageState();
}

class _MyCardPageState extends State<MyCardPage> {
  final CartController cartController =
      Get.put(CartController(), permanent: true);

  // Simulate loading data
  final RxBool isLoading = true.obs;

  @override
  void initState() {
    super.initState();

    // Simulate network/loading delay
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(
        title: "My cart",
      ),
      body: Obx(() {
        if (isLoading.value) {
          // Show loading animation
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (cartController.carts.isEmpty) {
          // Show empty cart message
          return const Column(
            children: [
              Spacer(),
              Center(
                child: Text(
                  "Your cart is empty",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Spacer(),
              // Footer
              Fooder(),
            ],
          );
        }

        return LayoutBuilder(builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 600;

          return Column(
            children: [
              Expanded(
                child: isWide
                    ? GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: cartController.carts.length,
                        itemBuilder: (context, index) {
                          var cart = cartController.carts[index];
                          return _buildCartItem(cart, index);
                        },
                      )
                    : ListView.builder(
                        itemCount: cartController.carts.length,
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          var cart = cartController.carts[index];
                          return _buildCartItem(cart, index);
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8))),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Obx(() => Text(
                            "Total: ₹${cartController.totelPrice.value.toStringAsFixed(2)}")),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                      ),
                      child: const Text("Buy Now"),
                      onPressed: () {
                        Get.toNamed('/checkout');
                      },
                    ),
                  ],
                ),
              )
            ,const SizedBox(height: 16),
        // Footer
                    const Fooder(),
            ],
          );
        });
      }),
    );
  }

  Widget _buildCartItem(cart, int index) {
    return InkWell(
      onTap: () {
        Get.toNamed('/protectDetails');
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: 80,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 208, 208, 208),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 5),
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              flex: 1,
              child: SizedBox(
                width: 80,
                child: NetworkImageLoader(cart.product.image!),
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cart.product.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Row(
                    children: [
                      Text(
                        "₹${(cart.product.price! * cart.quantity).toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8))),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (cart.quantity > 1) {
                                  cartController.removeQty(index);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(Icons.remove),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(cart.quantity.toString()),
                            ),
                            InkWell(
                              onTap: () {
                                cartController.addQty(index);
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Icon(Icons.add),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

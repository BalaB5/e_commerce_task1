import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animations/animations.dart';

import '../../controller/cart_controller.dart';
import '../widgets/fooder.dart';
import '../widgets/network_image_loader.dart';
import '../../controller/product_controller.dart';
import '../../model/cart.dart';
import '../../model/protect.dart';
import '../widgets/nav_bar.dart';
import '../widgets/protect_cart.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String? id;
  Product? protect;

  final ProductController controller = Get.put(ProductController());
  final CartController cartController =
      Get.put(CartController(), permanent: true);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.tempcount.value = 1;
  }

  Future<void> loadData() async {
    controller.tempcount.value = 1;
    id = Get.parameters['id'];
    protect = await controller.fetchDetails(id);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      appBar: const NavBar(
        title: "Product Details",
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation, secondaryAnimation) =>
                  FadeThroughTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      child: child),
              child: isMobile
                  ? _buildVerticalLayout(protect!)
                  : _buildHorizontalLayout(protect!, screenWidth),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHorizontalLayout(Product protect, double screenWidth) {
    // double crossAxisCount = (screenWidth ~/ 350.0) as double;
    // crossAxisCount = crossAxisCount < 2 ? 2 : crossAxisCount;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth < 959 ? 80 : 180, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: screenWidth > 950 ? 1.5 : 0.7,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade100,
                        ),
                        child: Hero(
                          tag: protect.id ?? '',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: NetworkImageLoader(protect.image ?? ''),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 1,
                    child: _buildProductDetails(protect),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _buildSimilarProductsSection(),
            ],
          ),
        ),

        const SizedBox(height: 16),
        // Footer
        const Fooder(),
      ],
    );
  }

  Widget _buildVerticalLayout(Product protect) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 4 / 3,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade100,
                  ),
                  child: Hero(
                    tag: protect.id ?? '',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: NetworkImageLoader(protect.image ?? ''),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildProductDetails(protect),
              const SizedBox(height: 30),
              _buildSimilarProductsSection(),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Footer
        const Fooder(),
      ],
    );
  }

  Widget _buildProductDetails(Product protect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          protect.title ?? '',
          style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Starting at ₹${protect.price}',
          style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.green.shade800),
        ),
        const SizedBox(height: 16),
        const Text(
          'About',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          protect.description ?? '',
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (controller.tempcount.value > 1) {
                        controller.tempcount.value--;
                      }
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Obx(() => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          controller.tempcount.value.toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                      )),
                  IconButton(
                    onPressed: () {
                      controller.tempcount.value++;
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            // const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              onPressed: () {
                if (!cartController.checkAlreadyAvailable(protect.id)) {
                  cartController.totelPrice.value =
                      cartController.totelPrice.value + protect.price!;
                  cartController.carts.add(CartProtucts(
                    product: protect,
                    quantity: controller.tempcount.value,
                  ));
                }
                Get.toNamed('/myCard');
              },
              child: const Text('Add to Cart'),
            )
          ],
        )
      ],
    );
  }

  Widget _buildSimilarProductsSection() {
    final similarProducts =
        controller.products.where((p) => p.id != protect!.id).take(8).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recommend Products',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 290,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: similarProducts.length,
            separatorBuilder: (_, __) => const SizedBox(width: 20),
            itemBuilder: (_, index) {
              final product = similarProducts[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 250,
                  width: 200,
                  child: ProtectCart(product: product),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

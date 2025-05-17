import 'dart:async'; // For Timer
import 'package:e_commerce/src/view/widgets/fooder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/product_controller.dart';
import '../widgets/nav_bar.dart';
import '../widgets/protect_cart.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final ProductController controller = Get.put(ProductController());

  // Banner images
  final List<String> bannerImages = [
    'assets/image/banner.jpeg',
    'assets/image/banner2.jpeg',
    'assets/image/banner1.jpeg',
  ];
  int currentBannerIndex = 0;
  final PageController _pageController = PageController();

  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();

    // Auto slide banner every 4 seconds
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage = currentBannerIndex + 1;
        if (nextPage >= bannerImages.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget buildBannerSlider(double width) {
    bool isMobile = width < 600;

    return Column(
      children: [
        SizedBox(
          height: isMobile ? 180 : 300,
          width: double.infinity,
          child: PageView.builder(
            controller: _pageController,
            itemCount: bannerImages.length,
            onPageChanged: (index) {
              setState(() {
                currentBannerIndex = index;
              });
            },
            itemBuilder: (_, index) {
              return Image.asset(
                bannerImages[index],
                fit: BoxFit.cover,
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            bannerImages.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              width: currentBannerIndex == index ? 12 : 8,
              height: currentBannerIndex == index ? 12 : 8,
              decoration: BoxDecoration(
                color:
                    currentBannerIndex == index ? Colors.orange : Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;

    return Scaffold(
      appBar: const NavBar(),
      drawer: isMobile
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(color: Colors.orange),
                    child: Text('Ecommers',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 24)),
                  ),
                  ListTile(
                      title: const Text('Products'),
                      onTap: () {
                        Get.toNamed('/');
                      }),
                  ListTile(
                      title: const Text('My Card'),
                      onTap: () {
                        Get.toNamed('/myCard');
                      }),
                ],
              ),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () async {
          controller.fetchProdunct();
        },
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;
              int crossAxisCount = screenWidth ~/ 350;
              crossAxisCount = crossAxisCount < 2 ? 2 : crossAxisCount;

              bool isNarrow = screenWidth < 750;
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildBannerSlider(screenWidth),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: isNarrow ? 17 : 180, vertical: 20),
                      child: Text(
                        "Available products",
                        style: GoogleFonts.poppins(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    ),
                    GridView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: isNarrow ? 20 : 180, vertical: 10),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: controller.products.length,
                      itemBuilder: (_, index) {
                        var product = controller.products[index];
                        return ProtectCart(product: product);
                      },
                    ),
                    const SizedBox(height: 16),
                    // Footer
                    const Fooder(),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

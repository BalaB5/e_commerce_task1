import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'network_image_loader.dart';
import '../../model/protect.dart';

class ProtectCart extends StatelessWidget {
  const ProtectCart({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Get.toNamed('/protectDetails/${product.id}');
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 208, 208, 208),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 5),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: screenWidth < 500 ? 100 : 180,
              child: NetworkImageLoader(product.image ?? ''),
            ),
            Column(
              children: [
                Text(
                  product.title ?? '',
                  maxLines: 1,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  "₹${product.price}",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade800),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

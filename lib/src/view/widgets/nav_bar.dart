import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  const NavBar({super.key, this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 800;

    return AppBar(
      title: Text(title ?? "E commerce",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24)),
      centerTitle: true,
      actions: isWideScreen
          ? [
              _navButton("Products", '/'),
              _navButton("My Cart", '/myCard'),
            ]
          : [],
    );
  }

  Widget _navButton(String label, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: () => Get.toNamed(route),
        child: Text(
          label,
          style: GoogleFonts.poppins(color: Colors.black),
        ),
      ),
    );
  }
}

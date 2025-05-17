import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Fooder extends StatelessWidget {
  const Fooder({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 600;
    return Container(
      width: double.infinity, // Full width
      color: Colors.orange.shade100,
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 40, vertical: isMobile ? 20 : 40),
      child: Column(
        children: [
          Text(
            "Ecommers © 2025. All rights reserved.",
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.w500,
              color: Colors.orange.shade900,
            ),
            textAlign: TextAlign.center,
          ),
          if (!isMobile)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                "Contact us: ecommers.com | +91 2345670890",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.orange.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

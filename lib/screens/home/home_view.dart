import 'package:flutter/material.dart';
import 'package:flutter_assignment/components/colors.dart';
import 'package:flutter_assignment/components/widget.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: skinTone,
      appBar: customAppBar(grn, white, 'Barcode Scanner'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            _menuCard(
              title: "Single Product Scan",
              subtitle: "Scan one barcode and view bill",
              icon: Icons.qr_code_scanner,
              onTap: () {
                Get.toNamed('/single-scan');
              },
            ),

            const SizedBox(height: 20),

            _menuCard(
              title: "Multi Product Scan",
              subtitle: "Scan multiple products and create bill",
              icon: Icons.shopping_cart,
              onTap: () {
                Get.toNamed('/multi-scan');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 130,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              blurRadius: 8,
              offset: Offset(0, 2),
              color: Colors.black12,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: grn,
              child: Icon(icon, color: white, size: 28),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(subtitle, style: TextStyle(color: gry99)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

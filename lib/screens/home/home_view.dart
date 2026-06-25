import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/multi_scan/multi_scan_view.dart';
import 'package:barcode_scanner/screens/single_scan/single_scan_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(iconTeal, white, 'Barcode Home'),

      body: CustomBody(
        child: Column(
          children: [
            gapH(20),
            customCard(
              title: "Single Product Scan",
              subtitle: "Scan one barcode and view bill",
              icon: Icons.qr_code_scanner,
              onTap: () {
                Get.to(() => SingleScanView());
              },
            ),
            gapH(20),
            customCard(
              title: "Multi Product Scan",
              subtitle: "Scan multiple products and create bill",
              icon: Icons.shopping_cart,
              onTap: () {
                Get.to(() => MultiScanView());
              },
            ),
          ],
        ),
      ),
    );
  }
}

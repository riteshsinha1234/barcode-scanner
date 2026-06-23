import 'package:flutter/material.dart';
import 'package:flutter_assignment/components/colors.dart';
import 'package:flutter_assignment/components/widget.dart';
import 'package:flutter_assignment/screens/multi_scan/multi_scan_view.dart';
import 'package:flutter_assignment/screens/single_scan/single_scan_view.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(grn, white, 'Barcode Home'),

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

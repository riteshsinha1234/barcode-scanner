import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/multi_scan/multi_scan_view.dart';
import 'package:barcode_scanner/screens/product_management/product_manag_view.dart';
import 'package:barcode_scanner/screens/sales_history/sales_history_view.dart';
import 'package:barcode_scanner/screens/single_scan/single_scan_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        iconTeal,
        white,
        'Barcode Home',
        actionIcon: GestureDetector(
          onTap: () {
            Get.to(() => SalesHistoryView());
          },
          child: Icon(Icons.list_alt_outlined, color: white),
        ),
      ),

      body: CustomBody(
        floatingWidget: customButton(
          48.0,
          screenWidth(context),
          grn,
          white,
          40,
          () {
            Get.to(() => ProductManagementView());
          },
          customTxt("Add Product", 16, white, FontWeight.w600),
        ),
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

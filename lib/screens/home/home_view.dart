// ignore_for_file: deprecated_member_use
import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/home/home_controller.dart';
import 'package:barcode_scanner/screens/multi_scan/multi_scan_view.dart';
import 'package:barcode_scanner/screens/product_management/product_manag_view.dart';
import 'package:barcode_scanner/screens/profile/profile_view.dart';
import 'package:barcode_scanner/screens/sales_history/sales_history_view.dart';
import 'package:barcode_scanner/screens/single_scan/single_scan_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        iconTeal,
        white,
        'Barcode Home',
        actionIcon: Row(
          children: [
            GestureDetector(
              onTap: () {
                Get.to(() => SalesHistoryView());
              },
              child: const Icon(Icons.list_alt_outlined, color: white),
            ),
            const SizedBox(width: 18),
            GestureDetector(
              onTap: () {
                Get.to(() => ProfileView());
              },
              child: Icon(Icons.person, color: white),
            ),
            const SizedBox(width: 12),
          ],
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
            Spacer(),
            GestureDetector(
              onTap: () {
                controller.showLogoutDialog(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.logout, color: iconTeal),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}

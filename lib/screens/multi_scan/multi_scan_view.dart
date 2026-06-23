import 'package:flutter/material.dart';
import 'package:flutter_assignment/components/colors.dart';
import 'package:flutter_assignment/components/texts.dart';
import 'package:flutter_assignment/components/widget.dart';
import 'package:flutter_assignment/models/product_model.dart';
import 'package:flutter_assignment/screens/multi_scan/multi_scan_controller.dart';
import 'package:flutter_assignment/screens/scanner/scanner_view.dart';
import 'package:get/get.dart';

class MultiScanView extends StatelessWidget {
  MultiScanView({super.key});

  final controller = Get.put(MultiScanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(iconTeal, white, "Multi Product Scan"),

      body: CustomBody(
        child: Column(
          children: [
            customButton(
              48,
              screenWidth(context),
              iconTeal,
              white,
              40,
              () async {
                final result = await Get.to(() => const ScannerView());

                if (result != null) {
                  /// Dummy Product
                  final product = ProductModel(
                    barcode: result.toString(),
                    name: "Sample Product",
                    price: 99.0,
                  );

                  controller.addProduct(product);
                }
              },
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.qr_code_scanner, color: white),

                  gapW(10),

                  customTxt("Scan Product", 16, white, FontWeight.w600),
                ],
              ),
            ),

            gapH(20),

            Expanded(
              child: Obx(
                () => controller.cartItems.isEmpty
                    ? Center(
                        child: customTxt(
                          "No Products Scanned",
                          16,
                          black,
                          FontWeight.w600,
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = controller.cartItems[index];

                          return Card(
                            color: white,
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              title: Text(item.product.name),

                              subtitle: Text(item.product.barcode),

                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Qty: ${item.quantity}"),

                                  Text(
                                    "₹${(item.product.price * item.quantity).toStringAsFixed(2)}",
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),

            Obx(
              () => Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTxt("Total", 18, black, FontWeight.w700),

                    customTxt(
                      "₹${controller.totalAmount.toStringAsFixed(2)}",
                      18,
                      grn,
                      FontWeight.w700,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

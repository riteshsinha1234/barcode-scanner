import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/data/product_data.dart';
import 'package:barcode_scanner/models/product_model.dart';
import 'package:barcode_scanner/screens/bill/bill_view.dart';
import 'package:barcode_scanner/screens/multi_scan/multi_scan_controller.dart';
import 'package:barcode_scanner/screens/scanner/scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';

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
                final scannedCode = result.toString().trim();

                if (result != null) {
                  // ignore: avoid_print
                  print("Scanned Barcode: ${result.toString()}");
                  final box = Hive.box<ProductModel>('products');
                  try {
                    final product = products.firstWhere(
                      (item) => item.barcode.trim() == scannedCode,
                    );

                    controller.addProduct(product);
                  } catch (e) {
                    Get.snackbar(
                      "Product Not Found",
                      "No product found for barcode ${result.toString()}",
                      backgroundColor: white,
                      snackPosition: SnackPosition.TOP,
                      borderRadius: 12,
                      margin: const EdgeInsets.all(12),
                      titleText: customTxt(
                        "Product Not Found",
                        14,
                        black,
                        FontWeight.w400,
                      ),
                      messageText: customTxt(
                        "No product found for barcode ${result.toString()}",
                        14,
                        black,
                        FontWeight.w600,
                      ),
                    );
                  }
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
                              title: customTxt(
                                item.product.name,
                                16,
                                black,
                                FontWeight.w600,
                              ),
                              subtitle: customTxt(
                                item.product.barcode,
                                16,
                                black,
                                FontWeight.w600,
                              ),

                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    iconSize: 28,
                                    onPressed: () {
                                      controller.decreaseQuantity(index);
                                    },
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: laserRed,
                                    ),
                                  ),

                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      customTxt(
                                        "${item.quantity}",
                                        12,
                                        black,
                                        FontWeight.w700,
                                      ),
                                      customTxt(
                                        "₹${(item.product.price * item.quantity).toStringAsFixed(2)}",
                                        12,
                                        black,
                                        FontWeight.w700,
                                      ),
                                    ],
                                  ),

                                  IconButton(
                                    iconSize: 28,
                                    onPressed: () {
                                      controller.increaseQuantity(index);
                                    },
                                    icon: const Icon(
                                      Icons.add_circle,
                                      color: grn,
                                    ),
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

            gapH(15),

            customButton(
              48,
              screenWidth(context),
              grn,
              white,
              40,
              () {
                Get.to(() => BillView());
              },
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long, color: white),

                  gapW(10),

                  customTxt("Generate Bill", 16, white, FontWeight.w600),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

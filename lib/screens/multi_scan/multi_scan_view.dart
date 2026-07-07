import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/bill/bill_view.dart';
import 'package:barcode_scanner/screens/multi_scan/multi_scan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
            Container(
              height: 240,
              width: double.infinity,
              decoration: BoxDecoration(
                color: black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: iconTeal, width: 2.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    MobileScanner(
                      controller: controller.cameraController,
                      fit: BoxFit.cover,
                      onDetect: (capture) {
                        final barcode = capture.barcodes.first.rawValue;

                        if (barcode != null) {
                          controller.scanProduct(barcode.trim());
                        }
                      },
                    ),

                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Obx(
                        () => Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: controller.isTorchOn.value
                                ? vestYellow
                                : white,
                          ),
                          child: IconButton(
                            onPressed: controller.toggleTorch,
                            icon: Icon(
                              controller.isTorchOn.value
                                  ? Icons.flashlight_on
                                  : Icons.flashlight_off,
                              color: controller.isTorchOn.value ? white : black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            gapH(15),

            // const Divider(thickness: 5, color: gry20per,border),
            gapH(10),

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
                                14,
                                black,
                                FontWeight.w500,
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

            Obx(() {
              final hasProducts = controller.cartItems.isNotEmpty;

              return customButton(
                48,
                screenWidth(context),
                hasProducts ? grn : gry99,
                white,
                40,
                () async {
                  if (!hasProducts) return;

                  await controller.stopScanner();

                  await Get.to(() => BillView());

                  await controller.startScanner();
                },
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.receipt_long, color: white),
                    gapW(10),
                    customTxt("Generate Bill", 16, white, FontWeight.w600),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

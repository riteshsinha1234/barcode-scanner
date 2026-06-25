import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/scanner/scanner_view.dart';
import 'package:barcode_scanner/screens/single_scan/single_scan_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleScanView extends StatelessWidget {
  SingleScanView({super.key});
  final controller = Get.put(SingleScanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(iconTeal, white, "Single Product Scan"),

      body: CustomBody(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Barcode", style: TextStyle(color: gry99)),

                    gapH(5),

                    Text(
                      controller.barcode.value.isEmpty
                          ? "--"
                          : controller.barcode.value,
                    ),

                    gapH(15),

                    Text("Product", style: TextStyle(color: gry99)),

                    gapH(5),

                    Text(
                      controller.productName.value.isEmpty
                          ? "--"
                          : controller.productName.value,
                    ),

                    gapH(15),

                    Text("Price", style: TextStyle(color: gry99)),

                    gapH(5),

                    Text("₹${controller.price.value.toStringAsFixed(2)}"),
                  ],
                ),
              ),

              gapH(30),

              customButton(
                48.0,
                screenWidth(context),
                iconTeal,
                white,
                40.0,
                () async {
                  final result = await Get.to(() => const ScannerView());

                  if (result != null) {
                    controller.loadProduct(result.toString());
                  }
                },
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.qr_code_scanner, color: white, size: 20),
                    gapW(8),
                    customTxt("Scan Product", 14, white, FontWeight.w600),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

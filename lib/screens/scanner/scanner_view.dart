import 'package:flutter/material.dart';
import 'package:flutter_assignment/components/colors.dart';
import 'package:flutter_assignment/components/texts.dart';
import 'package:flutter_assignment/components/widget.dart';
import 'package:flutter_assignment/screens/scanner/scanner_controller.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerView extends StatelessWidget {
  const ScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScannerController());

    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: iconTeal,
        centerTitle: true,

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close, color: white),
        ),

        title: customTxt("Scanner", 20, white, FontWeight.w700),
      ),

      body: Stack(
        children: [
          CustomBody(
            child: Column(
              children: [
                gapH(20),
                Stack(
                  children: [
                    SizedBox(
                      height: 300,
                      width: screenWidth(context),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              height: 300,
                              width: double.infinity,
                              child: Obx(
                                () => controller.startScanning.value
                                    ? MobileScanner(
                                        controller: controller.cameraController,
                                        fit: BoxFit.cover,
                                        onDetect: (capture) {
                                          final barcode =
                                              capture.barcodes.first;

                                          if (barcode.rawValue != null) {
                                            controller.onBarcodeDetected(
                                              barcode.rawValue!,
                                            );
                                          }
                                        },
                                      )
                                    : Container(
                                        color: white,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.qr_code_scanner,
                                              size: 80,
                                              color: iconTeal,
                                            ),
                                            gapH(20),
                                            customTxt(
                                              "Ready to Scan",
                                              18,
                                              black,
                                              FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ),
                          ),

                          IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: iconTeal, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                gapH(20),
                customButton(
                  48,
                  screenWidth(context) * .8,
                  iconTeal,
                  white,
                  40,
                  () {
                    controller.openScanner();
                  },
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.qr_code_scanner, color: white),

                      gapW(10),

                      customTxt("Click to Scan", 16, white, FontWeight.w600),
                    ],
                  ),
                ),
                gapH(30),
                customTxt('Scan Product Barcode', 20, black, FontWeight.w700),

                gapH(10),
                customTxt(
                  'Place the barcode inside the frame',
                  14,
                  black,
                  FontWeight.w700,
                ),
                gapH(50),
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.isTorchOn.value ? vestYellow : white,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

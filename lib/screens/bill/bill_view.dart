import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/printer/printer_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bill_controller.dart';

class BillView extends StatelessWidget {
  BillView({super.key});

  final controller = Get.put(BillController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(iconTeal, white, "Bill Receipt"),

      body: CustomBody(
        floatingWidget: customButton(
          48,
          screenWidth(context),
          grn,
          white,
          40,
          () {
            Get.to(() => PrinterView());
          },
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.print, color: white),
              gapW(10),
              customTxt("Print Receipt", 16, white, FontWeight.w600),
            ],
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: Column(
                children: [
                  customTxt("My Store", 20, black, FontWeight.w700),

                  gapH(screenHeight(context) * .05),

                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: customTxt(
                          "Product",
                          14,
                          iconTeal,
                          FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: customTxt(
                            "Qty",
                            14,
                            iconTeal,
                            FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: customTxt(
                            "Amount",
                            14,
                            iconTeal,
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),

                  ...controller.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),

                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: customTxt(
                                  item.product.name,
                                  16,
                                  black,
                                  FontWeight.w500,
                                ),
                              ),

                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: customTxt(
                                    "${item.quantity}",
                                    16,
                                    black,
                                    FontWeight.w500,
                                  ),
                                ),
                              ),

                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: customTxt(
                                    "₹${(item.product.price * item.quantity).toStringAsFixed(2)}",
                                    14,
                                    black,
                                    FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  Divider(),

                  Row(
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
                  gapH(20),
                ],
              ),
            ),
            gapH(80),
          ],
        ),
      ),
    );
  }
}

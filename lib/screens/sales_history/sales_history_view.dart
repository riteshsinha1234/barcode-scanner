import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/sales_history/sales_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesHistoryView extends StatelessWidget {
  SalesHistoryView({super.key});

  final controller = Get.put(SalesHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(iconTeal, white, "Sales History"),
      body: CustomBody(
        child: Obx(
          () => controller.filteredSalesList.isEmpty
              ? Center(
                  child: customTxt(
                    "No Sales Found",
                    16,
                    black,
                    FontWeight.w600,
                  ),
                )
              : ListView.builder(
                  itemCount: controller.filteredSalesList.length,
                  itemBuilder: (context, index) {
                    final sale = controller.filteredSalesList[index];

                    return Card(
                      color: white,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        childrenPadding: const EdgeInsets.all(12),

                        title: customTxt(
                          "Invoice No: ${sale.invoiceNo}",
                          16,
                          black,
                          FontWeight.w600,
                        ),

                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: customTxt(
                            "Date: ${sale.saleDate}",
                            14,
                            gry99,
                            FontWeight.w400,
                          ),
                        ),

                        trailing: customTxt(
                          "₹${sale.totalAmount}",
                          16,
                          grn,
                          FontWeight.w700,
                        ),

                        children: [
                          const Divider(),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: sale.items.length,
                            itemBuilder: (context, itemIndex) {
                              final item = sale.items[itemIndex];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          customTxt(
                                            item.product.name,
                                            16,
                                            black,
                                            FontWeight.w600,
                                          ),

                                          const SizedBox(height: 4),

                                          customTxt(
                                            "₹${item.product.price} × ${item.quantity}",
                                            14,
                                            gry99,
                                            FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                    ),

                                    customTxt(
                                      "₹${item.product.price * item.quantity}",
                                      16,
                                      grn,
                                      FontWeight.w700,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                          const Divider(),

                          Align(
                            alignment: Alignment.centerRight,
                            child: customTxt(
                              "Total: ₹${sale.totalAmount}",
                              20,
                              grn,
                              FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () {
                                controller.deleteSale(index);
                              },
                              icon: const Icon(Icons.delete, color: laserRed),
                              label: customTxt(
                                "Delete Invoice",
                                14,
                                laserRed,
                                FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

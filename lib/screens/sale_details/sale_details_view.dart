import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/models/sales_model.dart';
import 'package:flutter/material.dart';

class SaleDetailsView extends StatelessWidget {
  final SalesModel sale;

  const SaleDetailsView({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(iconTeal, white, "Invoice Details"),
      body: CustomBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customTxt(
              "Invoice No: ${sale.invoiceNo}",
              18,
              black,
              FontWeight.w600,
            ),

            const SizedBox(height: 8),

            customTxt("Date: ${sale.saleDate}", 14, gry99, FontWeight.w400),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: sale.items.length,
                itemBuilder: (context, index) {
                  final item = sale.items[index];

                  return Card(
                    color: white,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                    ),
                  );
                },
              ),
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

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

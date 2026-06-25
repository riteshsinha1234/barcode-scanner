import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/sale_details/sale_details_view.dart';
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
          () => controller.salesList.isEmpty
              ? Center(
                  child: customTxt(
                    "No Sales Found",
                    16,
                    black,
                    FontWeight.w600,
                  ),
                )
              : ListView.builder(
                  itemCount: controller.salesList.length,
                  itemBuilder: (context, index) {
                    final sale = controller.salesList[index];

                    return Card(
                      color: white,
                      child: ListTile(
                        onTap: () {
                          Get.to(() => SaleDetailsView(sale: sale));
                        },

                        title: customTxt(
                          sale.invoiceNo,
                          16,
                          black,
                          FontWeight.w600,
                        ),

                        subtitle: customTxt(
                          sale.saleDate.toString(),
                          14,
                          black,
                          FontWeight.w400,
                        ),

                        trailing: customTxt(
                          "₹${sale.totalAmount}",
                          16,
                          grn,
                          FontWeight.w700,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

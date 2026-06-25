import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/product_management/product_manage_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductManagementView extends StatelessWidget {
  ProductManagementView({super.key});

  final controller = Get.put(ProductManagementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        iconTeal,
        white,
        "Product Management",
        actionIcon: GestureDetector(
          onTap: () {
            Get.dialog(ProductDialog());
          },
          child: Icon(Icons.integration_instructions, color: white),
        ),
      ),

      body: CustomBody(
        floatingWidget: Column(
          children: [
            Obx(
              () => customButton(
                48,
                screenWidth(context),
                grn,
                white,
                40,
                () {
                  if (controller.isEditing.value) {
                    controller.updateProduct();
                  } else {
                    controller.saveProduct();
                  }
                },
                Center(
                  child: customTxt(
                    controller.isEditing.value
                        ? "Update Product"
                        : "Save Product",
                    16,
                    white,
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        child: Column(
          children: [
            customTextField(
              "Product Name",
              screenWidth(context),
              16,
              (value) {},
              controller: controller.nameController,
            ),

            gapH(15),
            Row(
              children: [
                customTxt("₹", 20, iconTeal, FontWeight.w700),
                gapW(5),
                Expanded(
                  child: customTextField(
                    "Product Price",
                    screenWidth(context),
                    16,
                    (value) {},
                    controller: controller.priceController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            gapH(15),
            customTextField(
              "Barcode",
              screenWidth(context),
              16,
              (value) {},
              controller: controller.barcodeController,
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }
}

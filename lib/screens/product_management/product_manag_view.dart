// ignore_for_file: deprecated_member_use

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

            customTextField(
              "Product Price",
              screenWidth(context),
              16,
              (value) {},
              controller: controller.priceController,
              keyboardType: TextInputType.number,
              prefixText: "₹",
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

            gapH(25),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: grn, width: 1.4),
                boxShadow: [
                  BoxShadow(
                    color: black.withOpacity(.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Obx(
                    () => GestureDetector(
                      onTap: controller.isUploadingSheet.value
                          ? null
                          : () {
                              controller.uploadExcelSheet();
                            },
                      child: CircleAvatar(
                        radius: 32,
                        backgroundColor: grn.withOpacity(.18),
                        child: controller.isUploadingSheet.value
                            ? const CircularProgressIndicator()
                            : const Icon(
                                Icons.file_upload,
                                size: 32,
                                color: grn,
                              ),
                      ),
                    ),
                  ),

                  gapH(10),

                  customTxt("Upload Excel Sheet", 15, black, FontWeight.w700),

                  gapH(5),

                  customTxt(
                    "Supported: .xlsx, .csv",
                    12,
                    gry99,
                    FontWeight.w500,
                  ),

                  gapH(18),

                  Container(
                    width: double.infinity,
                    height: 1,
                    color: gry99.withOpacity(.25),
                  ),

                  gapH(14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customTxt("Uploaded Sheets", 17, black, FontWeight.w700),
                      Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: grn.withOpacity(.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: customTxt(
                            "${controller.sheets.length}",
                            13,
                            grn,
                            FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  gapH(10),

                  SizedBox(
                    height: 220,
                    child: Obx(
                      () => controller.sheets.isEmpty
                          ? Center(
                              child: customTxt(
                                "No Sheets Uploaded",
                                15,
                                gry99,
                                FontWeight.w600,
                              ),
                            )
                          : ListView.builder(
                              itemCount: controller.sheets.length,
                              itemBuilder: (context, index) {
                                final sheet = controller.sheets[index];

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: grnshad,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: iconTeal,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 42,
                                        width: 42,
                                        decoration: BoxDecoration(
                                          color: white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.description,
                                          color: iconTeal,
                                        ),
                                      ),

                                      gapW(10),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customTxt(
                                              sheet.fileName,
                                              14,
                                              black,
                                              FontWeight.w700,
                                            ),
                                            gapH(4),
                                            customTxt(
                                              "${sheet.totalProducts} Products",
                                              12,
                                              gry99,
                                              FontWeight.w500,
                                            ),
                                          ],
                                        ),
                                      ),

                                      IconButton(
                                        onPressed: () {
                                          Get.defaultDialog(
                                            title: "Delete Sheet",
                                            titleStyle: TextStyle(
                                              color: black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "outfit",
                                            ),
                                            buttonColor: iconTeal,
                                            middleTextStyle: TextStyle(
                                              color: black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,

                                              fontFamily: "outfit",
                                            ),
                                            middleText:
                                                "This will delete all products from this sheet.",
                                            textCancel: "Cancel",
                                            textConfirm: "Delete",
                                            confirmTextColor: white,
                                            onConfirm: () {
                                              Get.back();
                                              controller.deleteSheet(
                                                sheet.sheetId,
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: laserRed,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

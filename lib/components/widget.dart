import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/screens/product_management/product_manage_controller.dart'
    show ProductManagementController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

//screen size
SizedBox gapH(double value) => SizedBox(height: value);
SizedBox gapW(double value) => SizedBox(width: value);
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

//Buttons
// ignore: strict_top_level_inference
MaterialButton customButton(
  double ht,
  double wt,
  Color btnclr,
  Color bdrclr,
  double rdus,
  VoidCallback clk,
  Widget widget,
) {
  return MaterialButton(
    highlightColor: sariBlue,
    elevation: 0.0,
    height: ht,
    minWidth: wt,
    color: btnclr,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(rdus),
      side: BorderSide(color: bdrclr),
    ),
    onPressed: clk,
    child: widget,
  );
}

class CustomBody extends StatelessWidget {
  final Widget child;
  final Widget? floatingWidget;
  final Alignment alignment;

  const CustomBody({
    super.key,
    required this.child,
    this.floatingWidget,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      height: screenHeight(context),
      color: phoneGrey,

      child: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: alignment,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 30,
                  right: 20,
                  bottom: 10,
                ),
                child: child,
              ),
            ),

            if (floatingWidget != null)
              Positioned(
                left: 20,
                right: 20,
                bottom: 20,
                child: floatingWidget!,
              ),
          ],
        ),
      ),
    );
  }
}

//Home Card
Widget customCard({
  required String title,
  required String subtitle,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18),

        boxShadow: const [
          BoxShadow(blurRadius: 8, offset: Offset(0, 2), color: Colors.black12),
        ],
      ),

      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: grn,
            child: Icon(icon, color: white, size: 24),
          ),

          gapW(20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customTxt(title, 16, black, FontWeight.w700),
                gapH(5),
                customTxt(subtitle, 14, gry99, FontWeight.w500),
              ],
            ),
          ),
          gapW(20),
          const Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: iconTeal,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    ),
  );
}

// //Authentication =========================>>

Widget customTextField(
  String txt,
  double wt,
  double txtsz,
  Function(String) onChanged, {
  TextEditingController? controller,
  String? Function(String?)? validator,
  TextInputType keyboardType = TextInputType.text,
}) {
  return SizedBox(
    height: 50,
    width: wt,
    child: TextFormField(
      controller: controller,
      cursorHeight: 15,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      style: const TextStyle(color: black),
      decoration: InputDecoration(
        filled: true,
        fillColor: phoneGrey,
        contentPadding: const EdgeInsets.only(left: 12),
        hintText: txt,
        hintStyle: TextStyle(
          color: black,
          fontSize: txtsz,
          fontWeight: FontWeight.w300,
          fontFamily: "Outfit",
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1, color: iconTeal),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1, color: iconTeal),
        ),
      ),
    ),
  );
}

class ProductDialog extends StatelessWidget {
  ProductDialog({super.key});

  final ProductManagementController controller =
      Get.find<ProductManagementController>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Obx(
          () => controller.products.isEmpty
              ? SizedBox(
                  height: 120,
                  child: Center(
                    child: customTxt(
                      "No Products Found",
                      16,
                      black,
                      FontWeight.w600,
                    ),
                  ),
                )
              : SizedBox(
                  height: 400,
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      customTxt("Saved Products", 18, black, FontWeight.w700),

                      gapH(15),

                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.products.length,
                          itemBuilder: (context, index) {
                            final product = controller.products[index];

                            return Card(
                              color: white,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: customTxt(
                                            product.name,
                                            16,
                                            black,
                                            FontWeight.w600,
                                          ),
                                        ),

                                        customTxt(
                                          "₹${product.price}",
                                          16,
                                          grn,
                                          FontWeight.w700,
                                        ),
                                      ],
                                    ),

                                    gapH(5),

                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: customTxt(
                                        product.barcode,
                                        14,
                                        black,
                                        FontWeight.w400,
                                      ),
                                    ),

                                    gapH(10),

                                    const Divider(height: 1),

                                    gapH(8),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () {
                                            controller.editProduct(product);
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: iconTeal,
                                          ),
                                          label: const Text(
                                            "Edit",
                                            style: TextStyle(color: iconTeal),
                                          ),
                                        ),

                                        TextButton.icon(
                                          onPressed: () {
                                            Get.defaultDialog(
                                              title: "Delete Product",
                                              middleText: "Are you sure?",
                                              textConfirm: "Delete",
                                              textCancel: "Cancel",
                                              confirmTextColor: white,
                                              onConfirm: () {
                                                controller.deleteProduct(
                                                  product.barcode,
                                                );
                                                Get.back();
                                              },
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: laserRed,
                                          ),
                                          label: const Text(
                                            "Delete",
                                            style: TextStyle(color: laserRed),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      gapH(10),

                      customButton(
                        45,
                        double.infinity,
                        laserRed,
                        white,
                        12,
                        () => Get.back(),
                        Center(
                          child: customTxt("Close", 14, white, FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

AppBar customAppBar(Color bgclr, textclr, String title, {Widget? actionIcon}) {
  return AppBar(
    backgroundColor: bgclr,
    title: customTxt(title, 20, textclr, FontWeight.w600),
    centerTitle: true,
    automaticallyImplyLeading: false,
    actions: actionIcon != null
        ? [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: actionIcon,
            ),
          ]
        : [],
  );
}

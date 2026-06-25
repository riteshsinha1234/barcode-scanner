import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/screens/product_management/product_manage_controller.dart'
    show ProductManagementController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

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

// Widget customPassField(
//   String txt,
//   double wt,
//   double txtsz,
//   RxBool obscureTextController,
//   Function(String) onChanged,
// ) {
//   return SizedBox(
//     height: 45,
//     width: wt,
//     child: Obx(
//       () => TextFormField(
//         cursorHeight: 15,
//         obscureText: obscureTextController.value,
//         onChanged: onChanged,
//         textInputAction: TextInputAction.next,
//         style: const TextStyle(color: navyBlu),
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: white,
//           contentPadding: const EdgeInsets.only(left: 12),
//           hintText: txt,
//           hintStyle: TextStyle(
//             color: navyBlu,
//             fontSize: txtsz,
//             fontWeight: FontWeight.w300,
//             fontFamily: "Outfit",
//           ),
//           border: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//             borderSide: BorderSide(width: 1, color: navyBlu),
//           ),
//           enabledBorder: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(10)),
//             borderSide: BorderSide(width: 1, color: navyBlu),
//           ),
//           suffixIcon: GestureDetector(
//             onTap: () {
//               obscureTextController.value = !obscureTextController.value;
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: obscureTextController.value
//                   ? const Icon(
//                       Icons.no_encryption_gmailerrorred_outlined,
//                       color: navyBlu,
//                     )
//                   : const Icon(Icons.lock_open, color: navyBlu),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }

// Widget customGenderDropdown(
//   AuthController controller, {
//   String? Function(String?)? validator,
// }) {
//   return Obx(
//     () => DropdownButtonFormField<String>(
//       value: controller.selectedGender.value.isEmpty
//           ? null
//           : controller.selectedGender.value,
//       decoration: InputDecoration(
//         filled: true,
//         fillColor: white,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: navyBlu),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: const BorderSide(color: navyBlu),
//         ),
//       ),
//       hint: DefaultTextStyle.merge(
//         style: const TextStyle(
//           color: navyBlu, // now shows navyBlu instead of grey
//           fontSize: 14,
//           fontFamily: "Outfit",
//           fontWeight: FontWeight.w400,
//         ),
//         child: const Text("Select Gender"),
//       ),
//       icon: const Icon(Icons.keyboard_arrow_down_rounded, color: navyBlu),
//       dropdownColor: white,
//       style: const TextStyle(
//         color: navyBlu,
//         fontSize: 14,
//         fontFamily: "Outfit",
//         fontWeight: FontWeight.w400,
//       ),
//       isExpanded: true,
//       validator: validator,
//       items: ['Male', 'Female'].map((gender) {
//         return DropdownMenuItem(value: gender, child: Text(gender));
//       }).toList(),
//       onChanged: (value) {
//         if (value != null) controller.selectedGender.value = value;
//       },
//     ),
//   );
// }

AppBar customAppBar(Color bgclr, textclr, String title, {Widget? actionIcon}) {
  return AppBar(
    backgroundColor: bgclr,
    title: customTxt(title, 20, textclr, FontWeight.w600),
    centerTitle: true,
    automaticallyImplyLeading: false,
    actions: actionIcon != null ? [actionIcon] : [],
  );
}

// bool validateRegister(AuthController controller) {
//   if (controller.name.text.trim().isEmpty) {
//     showError("Name cannot be empty.");
//     return false;
//   }

//   // 3. Email (empty → format)
//   final email = controller.email.text.trim();
//   if (email.isEmpty) {
//     showError("Email cannot be empty.");
//     return false;
//   }
//   if (!GetUtils.isEmail(email)) {
//     showError("Please enter a valid email address.");
//     return false;
//   }

//   // 4. Gender
//   if (controller.selectedGender.value.isEmpty) {
//     showError("Please select a gender.");
//     return false;
//   }

//   // 5. Password (empty → length)
//   final password = controller.password.text;
//   if (password.isEmpty) {
//     showError("Password cannot be empty.");
//     return false;
//   }
//   if (password.length < 6) {
//     showError("Password must be at least 6 characters.");
//     return false;
//   }

//   return true;
// }

// //Login Validator  ========================>>
// bool validateLogin(AuthController controller) {
//   final email = controller.email.text.trim();
//   final password = controller.password.text;

//   if (email.isEmpty) {
//     showError("Email cannot be empty.");
//     return false;
//   }
//   if (!GetUtils.isEmail(email)) {
//     showError("Please enter a valid email address.");
//     return false;
//   }
//   if (password.isEmpty) {
//     showError("Password cannot be empty.");
//     return false;
//   }
//   if (password.length < 6) {
//     showError("Password must be at least 6 characters.");
//     return false;
//   }
//   return true;
// }

// void showError(String msg, {bool isError = true}) {
//   Get.snackbar(
//     isError ? "" : "Success",
//     msg,
//     titleText: customTxt(
//       isError ? "Validation Error" : "Success",
//       16,
//       white,
//       FontWeight.w600,
//     ),
//     messageText: customTxt(msg, 12, white, FontWeight.w400),
//     snackPosition: SnackPosition.TOP,
//     backgroundColor: isError ? lightRed : Colors.green,
//     colorText: white,
//     margin: const EdgeInsets.all(12),
//     borderRadius: 8,
//     duration: const Duration(milliseconds: 1500),
//   );
// }

// /// Call this from onTap:
// void showLogoutDialog() {
//   final ProfileController controller = Get.put(ProfileController());
//   Get.dialog(
//     Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
//       backgroundColor: white,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Icon in a circle
//             SvgPicture.asset(ImagePath.logo, height: 36, width: 36),
//             const SizedBox(height: 20),
//             // Title
//             customTxt("Log out?", 18, navyBlu, FontWeight.w600),
//             const SizedBox(height: 10),
//             // Subtitle
//             customParaTxt(
//               "You’ll need to sign in again to access your chats.",
//               14,
//               drawerClr,
//               FontWeight.w400,
//               TextAlign.center,
//             ),
//             const SizedBox(height: 24),
//             // Buttons row
//             Row(
//               children: [
//                 // Cancel
//                 Expanded(
//                   child: OutlinedButton(
//                     style: OutlinedButton.styleFrom(
//                       side: BorderSide(color: navyBlu),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                     ),
//                     onPressed: () => Get.back(),
//                     child: customTxt("Cancel", 14, navyBlu, FontWeight.w500),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 // Log out
//                 Expanded(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: navyBlu,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       padding: const EdgeInsets.symmetric(vertical: 14),
//                       elevation: 0,
//                     ),
//                     onPressed: () => controller.logout(),
//                     child: customTxt("Log out", 14, white, FontWeight.w500),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//     barrierDismissible: false,
//   );
// }

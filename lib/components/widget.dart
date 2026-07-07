import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/screens/auth/auth_controller.dart';
import 'package:barcode_scanner/screens/product_management/product_manage_controller.dart'
    show ProductManagementController;
import 'package:barcode_scanner/screens/profile/proifle_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
          BoxShadow(blurRadius: 8, offset: Offset(0, 2), color: blck12),
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

//TextFiled
Widget customTextField(
  String txt,
  double wt,
  double txtsz,
  Function(String) onChanged, {
  TextEditingController? controller,
  String? Function(String?)? validator,
  TextInputType keyboardType = TextInputType.text,
  String? prefixText,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),

        hintText: txt,
        hintStyle: TextStyle(
          color: black,
          fontSize: txtsz,
          fontWeight: FontWeight.w300,
          fontFamily: "Outfit",
        ),

        // 🔥 THIS IS THE FIX
        prefixIcon: prefixText != null
            ? Padding(
                padding: const EdgeInsets.only(left: 12, top: 2.5),
                child: customTxt(prefixText, 16, iconTeal, FontWeight.w700),
              )
            : null,

        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),

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
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Obx(
          () => SizedBox(
            height: 450,
            width: double.maxFinite,
            child: Column(
              children: [
                customTxt(
                  "Saved Products (${controller.products.length})",
                  18,
                  black,
                  FontWeight.w700,
                ),

                gapH(15),

                controller.products.isEmpty
                    ? Expanded(
                        child: Center(
                          child: customTxt(
                            "No Products Found",
                            16,
                            black,
                            FontWeight.w600,
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: controller.products.length,
                          itemBuilder: (context, index) {
                            final product = controller.products[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: grnshad,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: grn, width: 1.5),
                              ),
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
                  Center(child: customTxt("Close", 14, white, FontWeight.w600)),
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

// //Authentication =========================>>

Widget customNmEmlField(
  String txt,
  double wt,
  double txtsz,
  Function(String) onChanged, {
  TextEditingController? controller,
  String? Function(String?)? validator,
  bool isPassword = false,
}) {
  return SizedBox(
    height: 50,
    width: wt,
    child: TextFormField(
      controller: controller,
      cursorHeight: 15,
      onChanged: onChanged,
      validator: validator,
      textInputAction: TextInputAction.next,
      obscureText: isPassword,
      style: const TextStyle(color: grn),
      decoration: InputDecoration(
        filled: true,
        fillColor: white,
        contentPadding: const EdgeInsets.only(left: 12),
        hintText: txt,
        hintStyle: TextStyle(
          color: grn,
          fontSize: txtsz,
          fontWeight: FontWeight.w300,
          fontFamily: "Outfit",
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1, color: grn),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1, color: grn),
        ),
      ),
    ),
  );
}

Widget customPassField(
  String txt,
  double wt,
  double txtsz,
  RxBool obscureTextController,
  Function(String) onChanged, {
  TextEditingController? controller,
}) {
  return SizedBox(
    height: 45,
    width: wt,
    child: Obx(
      () => TextFormField(
        controller: controller,
        cursorHeight: 15,
        obscureText: obscureTextController.value,
        onChanged: onChanged,
        textInputAction: TextInputAction.next,
        style: const TextStyle(color: grn),
        decoration: InputDecoration(
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.only(left: 12),
          hintText: txt,
          hintStyle: TextStyle(
            color: grn,
            fontSize: txtsz,
            fontWeight: FontWeight.w300,
            fontFamily: "Outfit",
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1, color: grn),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1, color: grn),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              obscureTextController.value = !obscureTextController.value;
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: obscureTextController.value
                  ? const Icon(Icons.visibility_off, color: grn)
                  : const Icon(Icons.visibility, color: grn),
            ),
          ),
        ),
      ),
    ),
  );
}

bool validateRegister(AuthController controller) {
  if (controller.name.text.trim().isEmpty) {
    showError("Name cannot be empty.");
    return false;
  }

  // 3. Email (empty → format)
  final email = controller.email.text.trim();
  if (email.isEmpty) {
    showError("Email cannot be empty.");
    return false;
  }
  if (!GetUtils.isEmail(email)) {
    showError("Please enter a valid email address.");
    return false;
  }

  // 5. Password (empty → length)
  final password = controller.password.text;
  if (password.isEmpty) {
    showError("Password cannot be empty.");
    return false;
  }
  if (password.length < 6) {
    showError("Password must be at least 6 characters.");
    return false;
  }
  final confirmPassword = controller.confirmPassword.text;

  if (confirmPassword.isEmpty) {
    showError("Confirm password cannot be empty.");
    return false;
  }

  if (password != confirmPassword) {
    showError("Password and confirm password do not match.");
    return false;
  }

  return true;
}

//Login Validator  ========================>>
bool validateLogin(AuthController controller) {
  final email = controller.email.text.trim();
  final password = controller.password.text;

  if (email.isEmpty) {
    showError("Email cannot be empty.");
    return false;
  }
  if (!GetUtils.isEmail(email)) {
    showError("Please enter a valid email address.");
    return false;
  }
  if (password.isEmpty) {
    showError("Password cannot be empty.");
    return false;
  }
  if (password.length < 6) {
    showError("Password must be at least 6 characters.");
    return false;
  }
  return true;
}

void showError(String msg, {bool isError = true}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 2,
    backgroundColor: isError ? laserRed : iconTeal,
    textColor: white,
    fontSize: 14.0,
  );
}

//profile------------------->
Widget profileTile(
  IconData icon,
  String title,
  String value,
  BuildContext context,
) {
  return Container(
    width: screenWidth(context),
    margin: const EdgeInsets.only(bottom: 15),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          // ignore: deprecated_member_use
          color: black.withOpacity(0.08),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 20,
          // ignore: deprecated_member_use
          backgroundColor: grn.withOpacity(0.12),
          child: Icon(icon, color: grn, size: 22),
        ),
        gapW(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              customTxt(title, 13, gry99, FontWeight.w500),
              gapH(4),
              customTxt(value, 15, black, FontWeight.w600),
            ],
          ),
        ),
      ],
    ),
  );
}

void showEditProfileDialog(BuildContext context) {
  final ProfileController controller = Get.put(ProfileController());
  controller.editNameController.text = controller.profileName.value;

  Get.dialog(
    AlertDialog(
      backgroundColor: white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: customTxt("Edit Profile", 20, black, FontWeight.w600),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          customNmEmlField(
            "Full Name",
            double.infinity,
            15,
            (value) {},
            controller: controller.editNameController,
          ),
          gapH(15),
          customNmEmlField(
            "Email Address",
            double.infinity,
            15,
            (value) {},
            controller: controller.editEmailController,
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: customButton(
                40,
                screenWidth(context),
                white,
                gry99,
                5,
                () {
                  Get.back();
                },
                customTxt("Cancel", 15, gry99, FontWeight.w600),
              ),
            ),
            gapW(12),
            Expanded(
              child: Obx(
                () => customButton(
                  40,
                  screenWidth(context),
                  controller.isUpdating.value ? gry99 : grn,
                  white,
                  5,
                  controller.isUpdating.value
                      ? () {}
                      : () async {
                          await controller.updateProfile();
                        },
                  controller.isUpdating.value
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: white,
                          ),
                        )
                      : customTxt("Save", 15, white, FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

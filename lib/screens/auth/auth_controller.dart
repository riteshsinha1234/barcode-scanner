import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/auth/login_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final RxBool obscureConfirmPassword = true.obs;
  final RxBool obscurePassword = true.obs;

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.onClose();
  }

  void showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            const Icon(Icons.logout_rounded, color: laserRed),
            const SizedBox(width: 10),
            customTxt("Logout", 20, black, FontWeight.w600),
          ],
        ),
        content: customTxt(
          "Are you sure you want to logout from your account?",
          15,
          gry99,
          FontWeight.w400,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: customButton(
                  32,
                  screenWidth(context),
                  white,
                  gry99,
                  18,
                  () {
                    Get.back();
                  },
                  customTxt("Cancel", 15, gry99, FontWeight.w600),
                ),
              ),
              gapW(12),
              Expanded(
                child: customButton(
                  32,
                  screenWidth(context),
                  laserRed,
                  laserRed,
                  18,
                  () {
                    Get.back();
                    name.clear();
                    email.clear();
                    password.clear();
                    confirmPassword.clear();
                    obscurePassword.value = true;
                    obscureConfirmPassword.value = true;
                    Get.offAll(() => LoginView());
                  },
                  customTxt("Logout", 15, white, FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

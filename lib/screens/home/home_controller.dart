import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Future<void> logoutUser() async {
    final authController = Get.find<AuthController>();
    await authController.logoutUser();
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
                child: customButton(
                  40,
                  screenWidth(context),
                  laserRed,
                  laserRed,
                  5,
                  () async {
                    Get.back();
                    await logoutUser();
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

import 'package:barcode_scanner/screens/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController rotationController;
  late Animation<double> rotationAnimation;

  @override
  void onInit() {
    super.onInit();

    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    rotationAnimation = CurvedAnimation(
      parent: rotationController,
      curve: Curves.easeInExpo,
    );

    rotationController.forward();

    rotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Get.offAll(() => LoginView());
      }
    });
  }

  @override
  void onClose() {
    rotationController.dispose();
    super.onClose();
  }
}

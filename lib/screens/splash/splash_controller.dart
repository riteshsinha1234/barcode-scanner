import 'package:barcode_scanner/screens/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ), // Reduced slightly for a snappier feel
    );

    scaleAnimation = Tween<double>(begin: 0.0, end: 1.2).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );

    animationController.forward();

    animationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(const Duration(seconds: 1));

        Get.offAll(
          () => HomeView(), // Navigate to HomeView after the splash animation),
        );
      }
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}

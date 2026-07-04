import 'package:barcode_scanner/screens/auth/auth_controller.dart';
import 'package:barcode_scanner/screens/auth/login_view.dart';
import 'package:barcode_scanner/screens/home/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController rotationController;
  late Animation<double> rotationAnimation;

  final FirebaseAuth auth = FirebaseAuth.instance;

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
        final user = auth.currentUser;

        if (user != null) {
          if (!Get.isRegistered<AuthController>()) {
            Get.put(AuthController(), permanent: true);
          }

          Get.offAll(() => HomeView());
        } else {
          Get.offAll(() => LoginView());
        }
      }
    });
  }

  @override
  void onClose() {
    rotationController.dispose();
    super.onClose();
  }
}

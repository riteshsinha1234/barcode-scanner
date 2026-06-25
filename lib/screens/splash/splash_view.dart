import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/images.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBody(
        child: Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: controller.scaleAnimation,
                builder: (context, child) => Transform.scale(
                  scale: controller.scaleAnimation.value,
                  child: child,
                ),

                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.transparent,
                  child: Image.asset(ImagePath.logo),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: customParaTxt(
                  "Welcome to \nBarcode Scanner",
                  18,
                  sariBlue,
                  FontWeight.w700,
                  TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

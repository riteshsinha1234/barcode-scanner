import 'dart:math';

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
                animation: controller.rotationController,
                builder: (context, child) {
                  return SizedBox(
                    width: 170,
                    height: 170,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Rotating Light
                        Transform.rotate(
                          angle:
                              controller.rotationAnimation.value * 2 * pi * 12,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: 25,
                              height: 2.5,
                              decoration: BoxDecoration(
                                color: sariBlue,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    // ignore: deprecated_member_use
                                    color: sariBlue.withOpacity(0.4),
                                    blurRadius: 5,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Logo
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.transparent,
                          child: Image.asset(ImagePath.logo),
                        ),
                      ],
                    ),
                  );
                },
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

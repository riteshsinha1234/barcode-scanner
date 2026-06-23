import 'package:flutter/material.dart';
import 'package:flutter_assignment/components/colors.dart';
import 'package:flutter_assignment/components/images.dart';
import 'package:flutter_assignment/components/texts.dart';
import 'package:flutter_assignment/screens/splash/splash_controller.dart';
import 'package:get/get.dart';

class SplashView extends StatelessWidget {
  SplashView({super.key});

  // Inject the controller using Get.put
  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          // Center Animated Logo
          Center(
            child: AnimatedBuilder(
              animation: controller.scaleAnimation,
              builder: (context, child) => Transform.scale(
                scale: controller.scaleAnimation.value,
                child: child,
              ),
              child: CircleAvatar(
                radius: 80,
                backgroundColor: white,
                child: Image.asset(ImagePath.logo, width: 140, height: 140),
              ),
            ),
          ),

          // Bottom Welcome Text
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: customTxt(
                "Welcome to Agora Live",
                25,
                sariBlue,
                FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/images.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterView extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();

  RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(iconTeal, white, "Register"),
      body: CustomBody(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(ImagePath.logo, height: 120, width: 120),
              ),
              gapH(50),
              customNmEmlField(
                "Full Name",
                double.infinity,
                15,
                (value) {},
                controller: controller.name,
              ),
              gapH(20),
              customNmEmlField(
                "Email Address",
                double.infinity,
                15,
                (value) {},
                controller: controller.email,
              ),

              gapH(20),

              customPassField(
                "Password",
                double.infinity,
                15,
                controller.obscurePassword,
                (value) {},
                controller: controller.password,
              ),
              gapH(20),

              customPassField(
                "Confirm Password",
                double.infinity,
                15,
                controller.obscureConfirmPassword,
                (value) {},
                controller: controller.confirmPassword,
              ),
              gapH(30),
              Obx(
                () => customButton(
                  40.0,
                  screenWidth(context),
                  controller.isLoading.value ? gry99 : grn,
                  white,
                  30,
                  controller.isLoading.value
                      ? () {}
                      : () async {
                          if (validateRegister(controller)) {
                            await controller.registerUser();
                          }
                        },
                  controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: white,
                          ),
                        )
                      : customTxt("Register", 16, white, FontWeight.w600),
                ),
              ),
              gapH(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customTxt(
                    "Already have account?",
                    14,
                    black,
                    FontWeight.normal,
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: customTxt("Login", 14, grn, FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

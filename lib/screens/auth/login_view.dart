import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/images.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/auth/auth_controller.dart';
import 'package:barcode_scanner/screens/auth/register_view.dart';
import 'package:barcode_scanner/screens/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  final AuthController controller = Get.isRegistered<AuthController>()
      ? Get.find<AuthController>()
      : Get.put(AuthController(), permanent: true);
  LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: customAppBar(iconTeal, white, "Login"),
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
              gapH(70),

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

              gapH(30),

              customButton(
                40.0,
                screenWidth(context),
                grn,
                white,
                30,
                () {
                  if (validateLogin(controller)) {
                    showError("Login successful.", isError: false);

                    Get.offAll(() => HomeView());
                  }
                },
                customTxt("Login", 16, white, FontWeight.w600),
              ),

              gapH(15),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  customTxt("New here?", 14, black, FontWeight.normal),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => RegisterView());
                    },
                    child: customTxt(
                      "Create account",
                      14,
                      grn,
                      FontWeight.w600,
                    ),
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

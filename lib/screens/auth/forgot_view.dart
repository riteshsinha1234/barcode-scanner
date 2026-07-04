import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotView extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();

  ForgotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(iconTeal, white, "Forgot Password"),
      body: CustomBody(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gapH(60),

              Center(
                child: Icon(Icons.lock_reset_rounded, size: 95, color: grn),
              ),

              gapH(35),

              customTxt(
                "Enter your registered email address. We will send you a password reset link.",
                15,
                gry99,
                FontWeight.w400,
              ),

              gapH(30),

              customNmEmlField(
                "Email Address",
                double.infinity,
                15,
                (value) {},
                controller: controller.forgotEmail,
              ),

              gapH(30),

              Obx(
                () => customButton(
                  40,
                  screenWidth(context),
                  controller.canResend.value ? grn : gry99,
                  white,
                  30,
                  (!controller.canResend.value || controller.isLoading.value)
                      ? () {}
                      : () async {
                          await controller.forgotPassword();
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
                      : customTxt(
                          controller.canResend.value
                              ? controller.resetLinkSent.value
                                    ? "Resend Link"
                                    : "Send Reset Link"
                              : "Resend in ${controller.resendSeconds.value}s",
                          16,
                          white,
                          FontWeight.w600,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

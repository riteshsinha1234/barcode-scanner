import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/images.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/profile/proifle_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(iconTeal, white, "Profile"),
      body: CustomBody(
        alignment: Alignment.topCenter,
        child: Obx(
          () => controller.isProfileLoading.value
              ? const Center(child: CircularProgressIndicator(color: grn))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      gapH(25),

                      CircleAvatar(
                        radius: 60,
                        backgroundColor: grn,
                        backgroundImage: AssetImage(ImagePath.logo),
                      ),

                      gapH(30),

                      profileTile(
                        Icons.person_outline,
                        "Full Name",
                        controller.profileName.value.isEmpty
                            ? "No Name"
                            : controller.profileName.value,
                        context,
                      ),

                      profileTile(
                        Icons.email_outlined,
                        "Email Address",
                        controller.profileEmail.value,
                        context,
                      ),

                      profileTile(
                        Icons.storefront_outlined,
                        "Shop Number",
                        controller.shopNo.value,
                        context,
                      ),

                      gapH(15),

                      customButton(
                        40,
                        screenWidth(context),
                        grn,
                        white,
                        30,
                        () {
                          showEditProfileDialog(context);
                        },
                        customTxt("Edit Profile", 16, white, FontWeight.w600),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

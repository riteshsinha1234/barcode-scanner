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

  Widget profileTile(
    IconData icon,
    String title,
    String value,
    BuildContext context,
  ) {
    return Container(
      width: screenWidth(context),
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            // ignore: deprecated_member_use
            backgroundColor: grn.withOpacity(0.12),
            child: Icon(icon, color: grn, size: 22),
          ),
          gapW(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customTxt(title, 13, gry99, FontWeight.w500),
                gapH(4),
                customTxt(value, 15, black, FontWeight.w600),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showEditProfileDialog(BuildContext context) {
    controller.editNameController.text = controller.profileName.value;

    Get.dialog(
      AlertDialog(
        backgroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: customTxt("Edit Profile", 20, black, FontWeight.w600),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            customNmEmlField(
              "Full Name",
              double.infinity,
              15,
              (value) {},
              controller: controller.editNameController,
            ),
            gapH(15),
            customNmEmlField(
              "Email Address",
              double.infinity,
              15,
              (value) {},
              controller: controller.editEmailController,
            ),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: customButton(
                  40,
                  screenWidth(context),
                  white,
                  gry99,
                  5,
                  () {
                    Get.back();
                  },
                  customTxt("Cancel", 15, gry99, FontWeight.w600),
                ),
              ),
              gapW(12),
              Expanded(
                child: Obx(
                  () => customButton(
                    40,
                    screenWidth(context),
                    controller.isUpdating.value ? gry99 : grn,
                    white,
                    5,
                    controller.isUpdating.value
                        ? () {}
                        : () async {
                            await controller.updateProfile();
                          },
                    controller.isUpdating.value
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: white,
                            ),
                          )
                        : customTxt("Save", 15, white, FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

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

                      gapH(15),

                      customButton(
                        40,
                        screenWidth(context),
                        laserRed,
                        white,
                        30,
                        () async {
                          await controller.logoutFromProfile();
                        },
                        customTxt("Logout", 16, white, FontWeight.w600),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

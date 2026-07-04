import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/auth/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final RxString shopNo = "".obs;
  final editEmailController = TextEditingController();

  final editNameController = TextEditingController();

  final RxString profileName = "".obs;
  final RxString profileEmail = "".obs;
  final RxString profileUid = "".obs;

  final RxBool isProfileLoading = false.obs;
  final RxBool isUpdating = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isProfileLoading.value = true;

      final user = auth.currentUser;

      if (user == null) {
        showError("User not found.");
        return;
      }

      final doc = await firestore.collection("users").doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data();

        profileName.value = data?["name"] ?? user.displayName ?? "";
        profileEmail.value = data?["email"] ?? user.email ?? "";
        profileUid.value = data?["uid"] ?? user.uid;
        shopNo.value = data?["shopNo"] ?? "ShopNoR01";
      } else {
        profileName.value = user.displayName ?? "";
        profileEmail.value = user.email ?? "";
        profileUid.value = user.uid;
        shopNo.value = "ShopNoR01";
      }

      editNameController.text = profileName.value;
      editEmailController.text = profileEmail.value;
    } catch (e) {
      showError("Failed to load profile.");
    } finally {
      isProfileLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      final newName = editNameController.text.trim();
      final newEmail = editEmailController.text.trim();

      if (newName.isEmpty) {
        showError("Name cannot be empty.");
        return;
      }

      if (newEmail.isEmpty) {
        showError("Email cannot be empty.");
        return;
      }

      if (!GetUtils.isEmail(newEmail)) {
        showError("Please enter a valid email address.");
        return;
      }

      isUpdating.value = true;

      final user = auth.currentUser;

      if (user == null) {
        showError("User not found.");
        return;
      }

      await user.updateDisplayName(newName);

      if (user.email != newEmail) {
        await user.verifyBeforeUpdateEmail(newEmail);
        showError("Verification link sent to new email.", isError: false);
      }

      await firestore.collection("users").doc(user.uid).update({
        "name": newName,
        "email": newEmail,
        "updatedAt": FieldValue.serverTimestamp(),
      });

      profileName.value = newName;
      profileEmail.value = newEmail;

      showError("Profile updated successfully.", isError: false);
      Get.back();
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        showError("Please logout and login again before changing email.");
      } else {
        showError(e.message ?? "Failed to update profile.");
      }
    } catch (e) {
      showError("Failed to update profile.");
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> logoutFromProfile() async {
    final authController = Get.find<AuthController>();
    await authController.logoutUser();
  }

  @override
  void onClose() {
    editNameController.dispose();
    editEmailController.dispose();
    super.onClose();
  }
}

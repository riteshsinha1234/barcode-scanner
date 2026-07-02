import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/auth/login_view.dart';
import 'package:barcode_scanner/screens/home/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final RxBool obscureConfirmPassword = true.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> loginUser() async {
    try {
      isLoading.value = true;

      final userCheck = await firestore
          .collection("users")
          .where("email", isEqualTo: email.text.trim())
          .limit(1)
          .get();

      if (userCheck.docs.isEmpty) {
        showError("You are new here, try to register.");
        return;
      }

      await auth.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );

      showError("Login successful.", isError: false);
      clearFields();
      Get.offAll(() => HomeView());
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password" || e.code == "invalid-credential") {
        showError("Wrong password or click on Forgot Password.");
      } else if (e.code == "invalid-email") {
        showError("Please enter a valid email address.");
      } else if (e.code == "user-disabled") {
        showError("This account has been disabled.");
      } else {
        showError("Login failed. Please try again.");
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerUser() async {
    try {
      isLoading.value = true;

      final userName = name.text.trim();
      final userEmail = email.text.trim();
      final userPassword = password.text.trim();

      final userCredential = await auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      final user = userCredential.user;

      if (user == null) {
        showError("User creation failed.");
        return;
      }

      await user.updateDisplayName(userName);

      await firestore.collection("users").doc(user.uid).set({
        "name": userName,
        "email": userEmail,
        "uid": user.uid,
        "createdAt": FieldValue.serverTimestamp(),
      });

      showError("Account created successfully.", isError: false);
      clearFields();
      Get.offAll(() => HomeView());
    } on FirebaseAuthException catch (e) {
      showError(e.message ?? "Registration failed.");
    } on FirebaseException catch (e) {
      showError("Firestore error: ${e.code}");
    } catch (e) {
      showError("Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logoutUser() async {
    await auth.signOut();
    clearFields();
    obscurePassword.value = true;
    obscureConfirmPassword.value = true;
    Get.offAll(() => LoginView());
  }

  void clearFields() {
    name.clear();
    email.clear();
    password.clear();
    confirmPassword.clear();
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.onClose();
  }

  void showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            const Icon(Icons.logout_rounded, color: laserRed),
            const SizedBox(width: 10),
            customTxt("Logout", 20, black, FontWeight.w600),
          ],
        ),
        content: customTxt(
          "Are you sure you want to logout from your account?",
          15,
          gry99,
          FontWeight.w400,
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
                child: customButton(
                  40,
                  screenWidth(context),
                  laserRed,
                  laserRed,
                  5,
                  () async {
                    Get.back();
                    await logoutUser();
                  },
                  customTxt("Logout", 15, white, FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
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
  final forgotEmail = TextEditingController();
  final RxBool resetLinkSent = false.obs;

  final RxBool obscureConfirmPassword = true.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;
  final RxInt resendSeconds = 0.obs;
  final RxBool canResend = true.obs;
  Timer? resendTimer;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //Login User--------->
  Future<void> loginUser() async {
    try {
      isLoading.value = true;

      final userEmail = email.text.trim().toLowerCase();
      final userPassword = password.text.trim();

      if (userEmail.isEmpty || userPassword.isEmpty) {
        showError("Email and password are required.");
        return;
      }

      await auth.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      showError("Login successful.", isError: false);
      clearFields();
      Get.offAll(() => HomeView());
    } on FirebaseAuthException catch (e) {
      final userEmail = email.text.trim().toLowerCase();

      if (e.code == "invalid-credential" || e.code == "wrong-password") {
        try {
          final emailCheck = await firestore
              .collection("users")
              .where("email", isEqualTo: userEmail)
              .limit(1)
              .get();

          if (emailCheck.docs.isNotEmpty) {
            showError("Wrong password or click on Forgot Password.");
          } else {
            showError("New here? Click on Register to create account.");
          }
        } catch (firestoreError) {
          showError("Unable to check account. Try again.");
        }
      } else if (e.code == "invalid-email") {
        showError("Please enter a valid email address.");
      } else if (e.code == "user-disabled") {
        showError("This account has been disabled.");
      } else {
        showError("Login failed. Please try again.");
      }
    } catch (e) {
      showError("Something went wrong.");
    } finally {
      isLoading.value = false;
    }
  }

  //Register User--------->
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

      final counterRef = firestore.collection("app_data").doc("user_counter");

      final shopNo = await firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(counterRef);

        int count = 1;

        if (snapshot.exists) {
          count = (snapshot.data()?["count"] ?? 0) + 1;
        }

        transaction.set(counterRef, {"count": count});

        return "ShopNoR${count.toString().padLeft(2, '0')}";
      });

      await firestore.collection("users").doc(user.uid).set({
        "name": userName,
        "email": userEmail,
        "uid": user.uid,
        "shopNo": shopNo,
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

  //Logout User--------->
  Future<void> logoutUser() async {
    await auth.signOut();
    clearFields();
    obscurePassword.value = true;
    obscureConfirmPassword.value = true;
    Get.offAll(() => LoginView());
  }

  //Forgot Password User--------->
  Future<void> forgotPassword() async {
    try {
      final userEmail = forgotEmail.text.trim();

      if (userEmail.isEmpty) {
        showError("Email cannot be empty.");
        return;
      }

      if (!GetUtils.isEmail(userEmail)) {
        showError("Please enter a valid email address.");
        return;
      }

      isLoading.value = true;

      await auth.sendPasswordResetEmail(email: userEmail);

      resetLinkSent.value = true;
      startResendTimer();

      showError("Password reset link sent to your email.", isError: false);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        showError("Please enter a valid email address.");
      } else {
        showError("Failed to send reset email.");
      }
    } catch (e) {
      showError("Something went wrong.");
    } finally {
      isLoading.value = false;
    }
  }

  void startResendTimer() {
    resendTimer?.cancel();

    canResend.value = false;
    resendSeconds.value = 15;

    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value <= 1) {
        timer.cancel();
        canResend.value = true;
        resendSeconds.value = 0;
      } else {
        resendSeconds.value--;
      }
    });
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
    forgotEmail.dispose();
    resendTimer?.cancel();
    super.onClose();
  }
}

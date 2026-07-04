import 'package:audioplayers/audioplayers.dart';
import 'package:barcode_scanner/models/cart_item_model.dart';
import 'package:barcode_scanner/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MultiScanController extends GetxController {
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  final AudioPlayer audioPlayer = AudioPlayer();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final MobileScannerController cameraController = MobileScannerController();

  RxBool isTorchOn = false.obs;
  RxBool isScanning = false.obs;

  String cleanBarcode(String value) {
    return value.replaceAll(".0", "").replaceAll(RegExp(r'[^0-9]'), "").trim();
  }

  Future<void> playBeepSound() async {
    try {
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource('sounds/qr-code-scan-beep.mp3'));
    } catch (e) {
      Fluttertoast.showToast(msg: "Sound error");
    }
  }

  Future<void> scanProduct(String scannedCode) async {
    if (isScanning.value) return;

    isScanning.value = true;

    try {
      final user = auth.currentUser;

      if (user == null) {
        Fluttertoast.showToast(msg: "User not logged in");
        return;
      }

      final cleanCode = cleanBarcode(scannedCode);

      print("SCANNED CODE: $cleanCode");

      final doc = await firestore.collection("products").doc(cleanCode).get();

      if (doc.exists) {
        final data = doc.data()!;

        if (data["uid"] == user.uid) {
          final product = ProductModel(
            barcode: data["barcode"],
            name: data["name"],
            price: (data["price"] as num).toDouble(),
          );

          addProduct(product);

          await playBeepSound();
        } else {
          Fluttertoast.showToast(msg: "Product Not Found");
        }
      } else {
        Fluttertoast.showToast(msg: "Product Not Found");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Scan error: $e");
    } finally {
      await Future.delayed(const Duration(seconds: 2));
      isScanning.value = false;
    }
  }

  Future<void> toggleTorch() async {
    await cameraController.toggleTorch();
    isTorchOn.value = !isTorchOn.value;
  }

  void addProduct(ProductModel product) {
    final index = cartItems.indexWhere(
      (item) => item.product.barcode == product.barcode,
    );

    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(CartItemModel(product: product));
    }
  }

  void increaseQuantity(int index) {
    cartItems[index].quantity++;
    cartItems.refresh();
  }

  void decreaseQuantity(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
      cartItems.refresh();
    } else {
      cartItems.removeAt(index);
    }
  }

  void clearCart() {
    cartItems.clear();
  }

  double get totalAmount {
    double total = 0;

    for (var item in cartItems) {
      total += item.product.price * item.quantity;
    }

    return total;
  }

  int get totalItems {
    int total = 0;

    for (var item in cartItems) {
      total += item.quantity;
    }

    return total;
  }

  @override
  void onClose() {
    cameraController.dispose();
    audioPlayer.dispose();
    super.onClose();
  }
}

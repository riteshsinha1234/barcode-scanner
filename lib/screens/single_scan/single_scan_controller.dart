import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SingleScanController extends GetxController {
  RxString barcode = ''.obs;
  RxString productName = ''.obs;
  RxDouble price = 0.0.obs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> loadProduct(String scannedCode) async {
    barcode.value = scannedCode;

    final user = auth.currentUser;

    if (user == null) {
      productName.value = "User Not Logged In";
      price.value = 0.0;
      return;
    }

    final doc = await firestore.collection("products").doc(scannedCode).get();

    if (doc.exists) {
      final data = doc.data()!;

      if (data["uid"] == user.uid) {
        productName.value = data["name"];
        price.value = (data["price"] as num).toDouble();
      } else {
        productName.value = "Product Not Found";
        price.value = 0.0;
      }
    } else {
      productName.value = "Product Not Found";
      price.value = 0.0;
    }
  }
}

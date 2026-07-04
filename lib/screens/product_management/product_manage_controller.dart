import 'dart:convert';

import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/models/product_model.dart';
import 'package:barcode_scanner/screens/product_management/sheet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ProductManagementController extends GetxController {
  RxBool isEditing = false.obs;
  String editingBarcode = "";
  RxList<SheetModel> sheets = <SheetModel>[].obs;
  RxBool isUploadingSheet = false.obs;
  RxList<ProductModel> products = <ProductModel>[].obs;

  final barcodeController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    loadSheets();
  }

  Future<void> loadProducts() async {
    final user = auth.currentUser;

    if (user == null) return;

    final snapshot = await firestore
        .collection("products")
        .where("uid", isEqualTo: user.uid)
        .get();

    products.value = snapshot.docs.map((doc) {
      final data = doc.data();

      return ProductModel(
        barcode: data["barcode"],
        name: data["name"],
        price: (data["price"] as num).toDouble(),
      );
    }).toList();
  }

  Future<void> loadSheets() async {
    final user = auth.currentUser;

    if (user == null) return;

    final snapshot = await firestore
        .collection("sheets")
        .where("uid", isEqualTo: user.uid)
        .get();

    sheets.value = snapshot.docs.map((doc) {
      final data = doc.data();

      return SheetModel(
        sheetId: data["sheetId"],
        fileName: data["fileName"],
        totalProducts: data["totalProducts"],
        createdAt: data["createdAt"] == null
            ? null
            : (data["createdAt"] as Timestamp).toDate(),
      );
    }).toList();

    sheets.sort((a, b) {
      final aDate = a.createdAt ?? DateTime(2000);
      final bDate = b.createdAt ?? DateTime(2000);
      return bDate.compareTo(aDate);
    });
  }

  Future<void> uploadExcelSheet() async {
    final user = auth.currentUser;

    if (user == null) {
      Fluttertoast.showToast(msg: "User not logged in");
      return;
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["xlsx", "xls", "csv"],
        withData: true,
      );

      if (result == null) return;

      isUploadingSheet.value = true;

      final fileBytes = result.files.single.bytes;
      final fileName = result.files.single.name;
      final extension = fileName.split(".").last.toLowerCase();

      if (fileBytes == null) {
        Fluttertoast.showToast(msg: "Unable to read file");
        return;
      }

      if (extension == "xls") {
        Fluttertoast.showToast(
          msg: "Old .xls file is not supported. Please save as .xlsx",
        );
        return;
      }

      final sheetId = const Uuid().v4();
      int uploadedCount = 0;

      if (extension == "xlsx") {
        final excel = Excel.decodeBytes(fileBytes);

        for (final table in excel.tables.keys) {
          final rows = excel.tables[table]!.rows;

          for (int i = 1; i < rows.length; i++) {
            final row = rows[i];

            final name = row[0]?.value.toString().trim() ?? "";
            final barcode =
                row[1]?.value
                    .toString()
                    .replaceAll(".0", "")
                    .replaceAll(RegExp(r'[^0-9]'), "")
                    .trim() ??
                "";
            final priceText = row[2]?.value.toString().trim() ?? "";

            final price = double.tryParse(priceText);

            if (name.isEmpty || barcode.isEmpty || price == null) continue;

            await firestore.collection("products").doc(barcode).set({
              "name": name,
              "barcode": barcode,
              "price": price,
              "uid": user.uid,
              "sheetId": sheetId,
              "createdAt": FieldValue.serverTimestamp(),
            });

            uploadedCount++;
          }
        }
      } else if (extension == "csv") {
        final csvString = utf8.decode(fileBytes);
        final rows = const CsvToListConverter().convert(csvString);

        for (int i = 1; i < rows.length; i++) {
          final row = rows[i];

          if (row.length < 3) continue;

          final name = row[0].toString().trim();
          final barcode = row[1].toString().trim();
          final priceText = row[2].toString().trim();

          final price = double.tryParse(priceText);

          if (name.isEmpty || barcode.isEmpty || price == null) continue;

          await firestore.collection("products").doc(barcode).set({
            "name": name,
            "barcode": barcode,
            "price": price,
            "uid": user.uid,
            "sheetId": sheetId,
            "createdAt": FieldValue.serverTimestamp(),
          });

          uploadedCount++;
        }
      }

      if (uploadedCount == 0) {
        Fluttertoast.showToast(msg: "No valid products found in sheet");
        return;
      }

      await firestore.collection("sheets").doc(sheetId).set({
        "sheetId": sheetId,
        "fileName": fileName,
        "uid": user.uid,
        "totalProducts": uploadedCount,
        "createdAt": FieldValue.serverTimestamp(),
      });

      await loadProducts();
      await loadSheets();

      Fluttertoast.showToast(msg: "Sheet Uploaded Successfully");
    } catch (e) {
      Fluttertoast.showToast(msg: "Upload failed: $e");
    } finally {
      isUploadingSheet.value = false;
    }
  }

  Future<void> saveProduct() async {
    final user = auth.currentUser;

    if (user == null) {
      Fluttertoast.showToast(msg: "User not logged in");
      return;
    }

    final name = nameController.text.trim();
    final barcode = barcodeController.text.trim();
    final price = priceController.text.trim();

    if (name.isEmpty || barcode.isEmpty || price.isEmpty) {
      Fluttertoast.showToast(msg: "All fields are required");
      return;
    }

    final parsedPrice = double.tryParse(price);

    if (parsedPrice == null) {
      Fluttertoast.showToast(msg: "Enter valid price");
      return;
    }

    if (barcode.length != 13) {
      Fluttertoast.showToast(msg: "Barcode must contain 13 digits");
      return;
    }

    try {
      final productRef = firestore.collection("products").doc(barcode);
      final productDoc = await productRef.get();

      if (productDoc.exists) {
        Fluttertoast.showToast(msg: "Product with this barcode already exists");
        return;
      }

      await productRef.set({
        "name": name,
        "price": parsedPrice,
        "barcode": barcode,
        "uid": user.uid,
        "createdAt": FieldValue.serverTimestamp(),
      });

      await loadProducts();

      nameController.clear();
      barcodeController.clear();
      priceController.clear();

      Get.defaultDialog(
        buttonColor: iconTeal,
        titleStyle: TextStyle(
          color: black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: "outfit",
        ),
        middleTextStyle: TextStyle(
          color: black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: "outfit",
        ),
        title: "Success",
        middleText: "Product Added Successfully",
        textConfirm: "OK",
        onConfirm: () {
          Get.back();
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  Future<void> deleteProduct(String barcode) async {
    await firestore.collection("products").doc(barcode).delete();

    await loadProducts();

    Fluttertoast.showToast(msg: "Product Deleted Successfully");
  }

  void editProduct(ProductModel product) {
    nameController.text = product.name;
    priceController.text = product.price.toString();
    barcodeController.text = product.barcode;

    editingBarcode = product.barcode;
    isEditing.value = true;

    Get.back();
  }

  Future<void> deleteSheet(String sheetId) async {
    final user = auth.currentUser;

    if (user == null) return;

    final productsSnapshot = await firestore
        .collection("products")
        .where("uid", isEqualTo: user.uid)
        .where("sheetId", isEqualTo: sheetId)
        .get();

    for (final doc in productsSnapshot.docs) {
      await doc.reference.delete();
    }

    await firestore.collection("sheets").doc(sheetId).delete();

    await loadProducts();
    await loadSheets();

    Fluttertoast.showToast(msg: "Sheet Deleted Successfully");
  }

  Future<void> updateProduct() async {
    final user = auth.currentUser;

    if (user == null) return;

    final name = nameController.text.trim();
    final barcode = barcodeController.text.trim();
    final parsedPrice = double.tryParse(priceController.text.trim());

    if (parsedPrice == null) {
      Fluttertoast.showToast(msg: "Enter valid price");
      return;
    }

    if (editingBarcode != barcode) {
      await firestore.collection("products").doc(editingBarcode).delete();
    }

    await firestore.collection("products").doc(barcode).set({
      "name": name,
      "price": parsedPrice,
      "barcode": barcode,
      "uid": user.uid,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await loadProducts();

    nameController.clear();
    barcodeController.clear();
    priceController.clear();

    editingBarcode = "";
    isEditing.value = false;

    Fluttertoast.showToast(msg: "Product Updated Successfully");
  }

  void cancelEdit() {
    nameController.clear();
    barcodeController.clear();
    priceController.clear();

    editingBarcode = "";
    isEditing.value = false;
  }

  @override
  void onClose() {
    barcodeController.dispose();
    nameController.dispose();
    priceController.dispose();
    super.onClose();
  }
}

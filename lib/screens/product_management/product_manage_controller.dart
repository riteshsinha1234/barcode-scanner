import 'package:barcode_scanner/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ProductManagementController extends GetxController {
  final barcodeController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();

  late Box<ProductModel> productBox;

  RxList<ProductModel> products = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    productBox = Hive.box<ProductModel>('products');

    loadProducts();
  }

  void loadProducts() {
    products.value = productBox.values.toList();
  }

  Future<void> saveProduct() async {
    final name = nameController.text.trim();
    final barcode = barcodeController.text.trim();
    final price = priceController.text.trim();

    if (name.isEmpty || barcode.isEmpty || price.isEmpty) {
      Fluttertoast.showToast(msg: "All fields are required");
      return;
    }

    if (barcode.length != 13) {
      Fluttertoast.showToast(msg: "Barcode must contain 12 digits");
      return;
    }

    final product = ProductModel(
      barcode: barcode,
      name: name,
      price: double.parse(price),
    );

    await productBox.put(barcode, product);

    loadProducts();

    nameController.clear();
    barcodeController.clear();
    priceController.clear();

    Fluttertoast.showToast(msg: "Product Saved Successfully");
  }

  @override
  void onClose() {
    barcodeController.dispose();
    nameController.dispose();
    priceController.dispose();
    super.onClose();
  }
}

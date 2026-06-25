import 'package:barcode_scanner/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ProductManagementController extends GetxController {
  final barcodeController = TextEditingController();
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  RxBool isEditing = false.obs;
  String editingBarcode = "";

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

  Future saveProduct() async {
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

    if (productBox.containsKey(barcode)) {
      Fluttertoast.showToast(msg: "Product with this barcode already exists");
      return;
    }

    final product = ProductModel(
      barcode: barcode,
      name: name,
      price: parsedPrice,
    );

    await productBox.put(barcode, product);

    loadProducts();

    nameController.clear();
    barcodeController.clear();
    priceController.clear();

    Fluttertoast.showToast(msg: "Product Saved Successfully");
  }

  //Delete Product
  Future<void> deleteProduct(String barcode) async {
    await productBox.delete(barcode);

    loadProducts();

    Fluttertoast.showToast(msg: "Product Deleted Successfully");
  }

  //Edit Product

  void editProduct(ProductModel product) {
    nameController.text = product.name;
    priceController.text = product.price.toString();
    barcodeController.text = product.barcode;

    editingBarcode = product.barcode;

    isEditing.value = true;

    Get.back(); // close product dialog
  }

  Future<void> updateProduct() async {
    final parsedPrice = double.tryParse(priceController.text.trim());

    if (parsedPrice == null) {
      Fluttertoast.showToast(msg: "Enter valid price");
      return;
    }

    final updatedProduct = ProductModel(
      barcode: barcodeController.text.trim(),
      name: nameController.text.trim(),
      price: parsedPrice,
    );

    await productBox.delete(editingBarcode);

    await productBox.put(updatedProduct.barcode, updatedProduct);

    loadProducts();

    nameController.clear();
    priceController.clear();
    barcodeController.clear();

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

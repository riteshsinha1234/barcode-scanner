import 'package:barcode_scanner/models/sales_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SalesHistoryController extends GetxController {
  late Box<SalesModel> salesBox;

  RxList<SalesModel> salesList = <SalesModel>[].obs;
  RxList<SalesModel> filteredSalesList = <SalesModel>[].obs;

  TextEditingController searchController = TextEditingController();

  int get totalInvoices => salesList.length;

  @override
  void onInit() {
    super.onInit();
    salesBox = Hive.box<SalesModel>('sales');
    loadSales();
  }

  void loadSales() {
    salesList.value = salesBox.values.toList().reversed.toList();
    filteredSalesList.value = List.from(salesList);
  }

  void searchSales(String value) {
    if (value.trim().isEmpty) {
      filteredSalesList.value = List.from(salesList);
      return;
    }

    filteredSalesList.value = salesList.where((sale) {
      return sale.invoiceNo.toLowerCase().contains(value.toLowerCase());
    }).toList();
  }

  double getTotalSales() {
    double total = 0;

    for (final sale in salesList) {
      total += sale.totalAmount;
    }

    return total;
  }

  void deleteSale(int index) {
    final sale = filteredSalesList[index];

    final hiveIndex = salesBox.values.toList().indexOf(sale);

    if (hiveIndex != -1) {
      salesBox.deleteAt(hiveIndex);
      loadSales();

      Get.snackbar(
        "Success",
        "Invoice deleted successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

import 'package:barcode_scanner/data/product_data.dart';
import 'package:get/get.dart';

class SingleScanController extends GetxController {
  RxString barcode = ''.obs;
  RxString productName = ''.obs;
  RxDouble price = 0.0.obs;

  void loadProduct(String scannedCode) {
    barcode.value = scannedCode;

    final product = products.firstWhereOrNull((e) => e.barcode == scannedCode);

    if (product != null) {
      productName.value = product.name;
      price.value = product.price;
    } else {
      productName.value = "Product Not Found";
      price.value = 0;
    }
  }
}

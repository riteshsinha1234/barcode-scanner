import 'package:get/get.dart';

class SingleScanController extends GetxController {
  RxString barcode = ''.obs;
  RxString productName = ''.obs;
  RxDouble price = 0.0.obs;

  void loadProduct(String scannedCode) {
    barcode.value = scannedCode;

    /// Dummy Product
    productName.value = "Sample Product";

    price.value = 99.00;
  }
}

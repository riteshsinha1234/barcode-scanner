import 'package:barcode_scanner/models/product_model.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SingleScanController extends GetxController {
  RxString barcode = ''.obs;
  RxString productName = ''.obs;
  RxDouble price = 0.0.obs;

  void loadProduct(String scannedCode) {
    barcode.value = scannedCode;

    final productBox = Hive.box<ProductModel>('products');

    final product = productBox.get(scannedCode);

    if (product != null) {
      productName.value = product.name;
      price.value = product.price;
    } else {
      productName.value = "Product Not Found";
      price.value = 0.0;
    }
  }
}

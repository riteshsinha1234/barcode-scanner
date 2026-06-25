import 'package:barcode_scanner/models/cart_item_model.dart';
import 'package:get/get.dart';
import '../multi_scan/multi_scan_controller.dart';

class BillController extends GetxController {
  final multiController = Get.find<MultiScanController>();

  double get totalAmount => multiController.totalAmount;

  RxList<CartItemModel> get items => multiController.cartItems;
}

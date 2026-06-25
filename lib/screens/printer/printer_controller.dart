import 'package:bluetooth_print_plus/bluetooth_print_plus.dart';
import 'package:get/get.dart';

class PrinterController extends GetxController {
  RxList<BluetoothDevice> devices = <BluetoothDevice>[].obs;

  RxBool isScanning = false.obs;

  @override
  void onInit() {
    super.onInit();

    BluetoothPrintPlus.scanResults.listen((results) {
      devices.assignAll(results);
    });
  }

  Future<void> scanDevices() async {
    devices.clear();

    isScanning.value = true;

    try {
      await BluetoothPrintPlus.startScan(timeout: const Duration(seconds: 5));
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }

    isScanning.value = false;
  }

  Future<void> connect(BluetoothDevice device) async {
    try {
      await BluetoothPrintPlus.connect(device);

      Get.snackbar("Success", "Printer Connected");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}

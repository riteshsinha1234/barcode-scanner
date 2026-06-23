import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerController extends GetxController {
  RxBool scanned = false.obs;
  RxBool startScanning = false.obs;
  RxBool isTorchOn = false.obs;

  final MobileScannerController cameraController = MobileScannerController();

  void openScanner() {
    startScanning.value = true;
  }

  Future<void> toggleTorch() async {
    await cameraController.toggleTorch();
    isTorchOn.value = !isTorchOn.value;
  }

  void onBarcodeDetected(String value) {
    if (scanned.value) return;

    scanned.value = true;
    Get.back(result: value);
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}

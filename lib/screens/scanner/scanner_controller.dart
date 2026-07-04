import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerController extends GetxController {
  RxBool scanned = false.obs;
  RxBool startScanning = false.obs;
  RxBool isTorchOn = false.obs;

  final MobileScannerController cameraController = MobileScannerController();
  final AudioPlayer audioPlayer = AudioPlayer();

  void openScanner() {
    startScanning.value = true;
  }

  Future<void> toggleTorch() async {
    await cameraController.toggleTorch();
    isTorchOn.value = !isTorchOn.value;
  }

  Future<void> playBeepSound() async {
    try {
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource('sounds/qr-code-scan-beep.mp3'));
    } catch (_) {}
  }

  Future<void> onBarcodeDetected(String value) async {
    if (scanned.value) return;

    scanned.value = true;

    await playBeepSound();

    Get.back(result: value);
  }

  @override
  void onClose() {
    cameraController.dispose();
    audioPlayer.dispose();
    super.onClose();
  }
}

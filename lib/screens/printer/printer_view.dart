import 'package:barcode_scanner/components/colors.dart';
import 'package:barcode_scanner/components/texts.dart';
import 'package:barcode_scanner/components/widget.dart';
import 'package:barcode_scanner/screens/printer/printer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrinterView extends StatelessWidget {
  PrinterView({super.key});

  final controller = Get.put(PrinterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(iconTeal, white, "Bluetooth Printers"),

      body: CustomBody(
        child: Column(
          children: [
            customButton(
              48,
              screenWidth(context),
              iconTeal,
              white,
              40,
              () {
                controller.scanDevices();
              },
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search, color: white),
                  gapW(10),
                  customTxt("Scan Printers", 16, white, FontWeight.w600),
                ],
              ),
            ),

            gapH(20),

            Expanded(
              child: Obx(() {
                if (controller.isScanning.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: iconTeal),
                  );
                }

                if (controller.devices.isEmpty) {
                  return Center(
                    child: customTxt(
                      "No Printer Found",
                      16,
                      black,
                      FontWeight.w600,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.devices.length,
                  itemBuilder: (context, index) {
                    final device = controller.devices[index];

                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.print),
                        title: Text(device.name),
                        subtitle: Text(device.address),
                        trailing: ElevatedButton(
                          onPressed: () {
                            controller.connect(device);
                          },
                          child: const Text("Connect"),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_assignment/components/colors.dart';
import 'package:flutter_assignment/components/texts.dart';

class MultiScanView extends StatelessWidget {
  const MultiScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: customParaTxt(
          "Multi Scan \nUnder Construction😅😅",
          20,
          black,
          FontWeight.w600,
          TextAlign.center,
        ),
      ),
    );
  }
}

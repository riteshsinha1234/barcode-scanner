import 'package:flutter/material.dart';
import 'package:flutter_assignment/screens/home/home_view.dart';
import 'package:flutter_assignment/screens/multi_scan/multi_scan_view.dart';
import 'package:flutter_assignment/screens/single_scan/single_scan_view.dart';
import 'package:flutter_assignment/screens/splash/splash_view.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Barcode Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashView()),
        GetPage(name: '/home', page: () => HomeView()),
        GetPage(name: '/single scan', page: () => SingleScanView()),
        GetPage(name: '/multi scan', page: () => MultiScanView()),
      ],
    );
  }
}
